local TestScene = {}
local Player = require('src.game.entities.player')
local Config = require('src.core.config')
local Physics = require('src.game.world.physics')
local utils = require('src.core.utils')
local MapLoader = require('src.game.world.map_loader')

function TestScene:enter()
    self.player = Player.new(250, 250)

    self.camera = {
        x = 0,
        y = 0,
        smoothness = 0.2
    }

    self.map = MapLoader:generate(60, 60, true)

    self.tile_colors = {
        [1] = { 0.2, 0.8, 0.2 }, -- Grama
        [2] = { 0.2, 0.2, 1.0 }, -- Água
        [3] = { 0.8, 0.8, 0.8 }  -- Pedra
    }

    self.tile_textures = {
        -- [1] = "grass1",
        -- [2] = "water1",
        -- [3] = "rock1"
    }

    self:buildMapCollision()

    if Config:get('debug_mode') then
        print('Mundo físico inicializado:', Physics.world ~= nil)
    end
end

function TestScene:update(dt)
    self.player:update(dt)


    self.camera.x = utils.lerp(self.camera.x, self.player.position.x, self.camera.smoothness)
    self.camera.y = utils.lerp(self.camera.y, self.player.position.y, self.camera.smoothness)
end

function TestScene:draw()
    love.graphics.push()

    local screen_w = Config:get("virtual_width")
    local screen_h = Config:get("virtual_height")
    love.graphics.translate(
        screen_w / 2 - self.camera.x * Config:getScaleX(),
        screen_h / 2 - self.camera.y * Config:getScaleY()
    )

    local tile_size = Config:get("tile_size")
    for y = 1, #self.map do
        for x = 1, #self.map[y] do
            local tile = self.map[y][x]
            if tile ~= 0 then
                love.graphics.setColor(self.tile_colors[tile])
                if self.tile_textures[tile] then
                    love.graphics.draw(
                        Config:getTexture(self.tile_textures[tile]),
                        (x - 1) * tile_size,
                        (y - 1) * tile_size
                    )
                end
                love.graphics.rectangle(
                    'fill',
                    (x) * tile_size,
                    (y) * tile_size,
                    tile_size,
                    tile_size
                )
            end
        end
    end

    self.player:draw()

    love.graphics.pop()
end

function TestScene:buildMapCollision()
    local tile_size = Config:get("tile_size")

    local solid_tiles = {
        [2] = true -- Água é sólida
    }

    for y = 1, #self.map do
        for x = 1, #self.map[y] do
            local tile_type = self.map[y][x]

            if solid_tiles[tile_type] then
                local collider = {
                    type = "water",
                    x = (x + 0.4) * tile_size,
                    y = (y + 0.9) * tile_size,
                    w = tile_size,
                    h = tile_size
                }

                -- print("Adicionando colisor:", collider.x, collider.y, collider.w, collider.h)

                -- Adiciona ao mundo físico
                Physics:addEntity(collider, "map_tile", collider.x, collider.y, collider.w, collider.h)
            end
        end
    end
end

return TestScene
