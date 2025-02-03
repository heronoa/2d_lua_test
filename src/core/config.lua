local Config = {
    settings = {
        debug_mode = true,
        virtual_width = 1200,
        virtual_height = 720,
        scale = 1,
        scale_x = 1,
        scale_y = 1,
        tile_size = 64
    },
    textures = {}
}

local function mergeTables(t1, t2)
    local result = {}
    for k, v in pairs(t1) do result[k] = v end
    for k, v in pairs(t2) do result[k] = v end
    return result
end

function Config:initialize(settings)
    self.settings =
        mergeTables(self.settings, settings or {})

    self.settings.tile_size = self.settings.tile_size or 64
    self.settings.virtual_height = self.settings.virtual_height or 1080
    self.settings.virtual_width = self.settings.virtual_width or 1920

    self.textures.tiles:setFilter('nearest', 'nearest')
    self.textures.player:setFilter('nearest', 'nearest')

    self.textures.player = love.graphics.newImage('assets/graphics/player.png')
    self.textures.tiles = love.graphics.newImage('assets/graphics/summer_tiles.png')

    self.textures.grass1 = love.graphics.newQuad(0, 0, 16, 16, self.textures.tiles:getDimensions())
    self.textures.water1 = love.graphics.newQuad(176, 208, 16, 16, self.textures.tiles:getDimensions())
    self.textures.rock1 = love.graphics.newQuad(64, 96, 16, 16, self.textures.tiles:getDimensions())
    self.textures.player_idle = love.graphics.newQuad(0, 0, 16, 16, self.textures.player:getDimensions())




    self:updateWindowScale()
end

function Config:updateWindowScale()
    local window_w, window_h = love.graphics.getDimensions()

    self.settings.scale_x = window_w / (self.settings.virtual_width)
    self.settings.scale_y = window_h / (self.settings.virtual_height)
end

function Config:getScaleX()
    return self.settings.scale_x
end

function Config:getScaleY()
    return self.settings.scale_y
end

function Config:get(key)
    return self.settings[key]
end

function Config:getTexture(key)
    return self.textures[key]
end

function Config:scalePoint(x, y)
    return x / Config:getScaleX(), y / Config:getScaleY()
end

return Config
