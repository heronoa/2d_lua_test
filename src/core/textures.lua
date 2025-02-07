local texturesLoader = {
    textures = {}
}

function texturesLoader:load()
    self.textures.player = love.graphics.newImage('assets/graphics/player.png')
    self.textures.tiles = love.graphics.newImage('assets/graphics/summer_tiles.png')
    self.textures.dummy = love.graphics.newImage('assets/graphics/dummy.png')

    self.textures.tiles:setFilter('nearest', 'nearest')
    self.textures.player:setFilter('nearest', 'nearest')
    self.textures.dummy:setFilter('nearest', 'nearest')

    self.textures.grass1 = love.graphics.newQuad(0, 32, 16, 16, self.textures.tiles:getDimensions())
    self.textures.water1 = love.graphics.newQuad(176, 208, 16, 16, self.textures.tiles:getDimensions())
    self.textures.rock1 = love.graphics.newQuad(64, 96, 16, 16, self.textures.tiles:getDimensions())

    self.textures.player_idle = love.graphics.newQuad(0, 0, 60, 60, self.textures.player:getDimensions())

    local x_factor = 65
    local y_factor = 65


    self.textures.player_idle_s = love.graphics.newQuad(0, 0 * y_factor, 60, 60, self.textures.player:getDimensions())
    self.textures.player_idle_n = love.graphics.newQuad(0, 1 * y_factor, 60, 60, self.textures.player:getDimensions())
    self.textures.player_idle_e = love.graphics.newQuad(0, 2 * y_factor, 60, 60, self.textures.player:getDimensions())
    self.textures.player_idle_w = love.graphics.newQuad(0, 3 * y_factor, 60, 60, self.textures.player:getDimensions())

    local walking_frame_line = 5 * y_factor

    self.textures.player_walking_n_1 = love.graphics.newQuad(0 * x_factor, walking_frame_line, 60, 60,
        self.textures.player:getDimensions())
    self.textures.player_walking_n_2 = love.graphics.newQuad(1 * x_factor, walking_frame_line, 60, 60,
        self.textures.player:getDimensions())
    self.textures.player_walking_n_3 = love.graphics.newQuad(2 * x_factor, walking_frame_line, 60, 60,
        self.textures.player:getDimensions())
    self.textures.player_walking_n_4 = love.graphics.newQuad(3 * x_factor, walking_frame_line, 60, 60,
        self.textures.player:getDimensions())
    self.textures.player_walking_n_5 = love.graphics.newQuad(4 * x_factor, walking_frame_line, 60, 60,
        self.textures.player:getDimensions())
    self.textures.player_walking_n_6 = love.graphics.newQuad(5 * x_factor, walking_frame_line, 60, 60,
        self.textures.player:getDimensions())

    self.textures.player_walking_e_1 = love.graphics.newQuad(0 * x_factor, walking_frame_line + y_factor, 60, 60,
        self.textures.player:getDimensions())
    self.textures.player_walking_e_2 = love.graphics.newQuad(1 * x_factor, walking_frame_line + y_factor, 60, 60,
        self.textures.player:getDimensions())
    self.textures.player_walking_e_3 = love.graphics.newQuad(2 * x_factor, walking_frame_line + y_factor, 60, 60,
        self.textures.player:getDimensions())
    self.textures.player_walking_e_4 = love.graphics.newQuad(3 * x_factor, walking_frame_line + y_factor, 60, 60,
        self.textures.player:getDimensions())
    self.textures.player_walking_e_5 = love.graphics.newQuad(4 * x_factor, walking_frame_line + y_factor, 60, 60,
        self.textures.player:getDimensions())
    self.textures.player_walking_e_6 = love.graphics.newQuad(5 * x_factor, walking_frame_line + y_factor, 60, 60,
        self.textures.player:getDimensions())

    self.textures.player_walking_w_1 = love.graphics.newQuad(0 * x_factor, walking_frame_line + 2 * y_factor, 60, 60,
        self.textures.player:getDimensions())
    self.textures.player_walking_w_2 = love.graphics.newQuad(1 * x_factor, walking_frame_line + 2 * y_factor, 60, 60,
        self.textures.player:getDimensions())
    self.textures.player_walking_w_3 = love.graphics.newQuad(2 * x_factor, walking_frame_line + 2 * y_factor, 60, 60,
        self.textures.player:getDimensions())
    self.textures.player_walking_w_4 = love.graphics.newQuad(3 * x_factor, walking_frame_line + 2 * y_factor, 60, 60,
        self.textures.player:getDimensions())
    self.textures.player_walking_w_5 = love.graphics.newQuad(4 * x_factor, walking_frame_line + 2 * y_factor, 60, 60,
        self.textures.player:getDimensions())
    self.textures.player_walking_w_6 = love.graphics.newQuad(5 * x_factor, walking_frame_line + 2 * y_factor, 60, 60,
        self.textures.player:getDimensions())

    self.textures.player_walking_s_1 = love.graphics.newQuad(0 * x_factor, walking_frame_line - y_factor, 60, 60,
        self.textures.player:getDimensions())
    self.textures.player_walking_s_2 = love.graphics.newQuad(1 * x_factor, walking_frame_line - y_factor, 60, 60,
        self.textures.player:getDimensions())
    self.textures.player_walking_s_3 = love.graphics.newQuad(2 * x_factor, walking_frame_line - y_factor, 60, 60,
        self.textures.player:getDimensions())
    self.textures.player_walking_s_4 = love.graphics.newQuad(3 * x_factor, walking_frame_line - y_factor, 60, 60,
        self.textures.player:getDimensions())
    self.textures.player_walking_s_5 = love.graphics.newQuad(4 * x_factor, walking_frame_line - y_factor, 60, 60,
        self.textures.player:getDimensions())
    self.textures.player_walking_s_6 = love.graphics.newQuad(5 * x_factor, walking_frame_line - y_factor, 60, 60,
        self.textures.player:getDimensions())

    self.textures.dummy_idle = love.graphics.newQuad(0, 0, 16, 16,
        self.textures.dummy:getDimensions())
    self.textures.dummy_idle_s = love.graphics.newQuad(0, 16, 16, 16,
        self.textures.dummy:getDimensions())

    return self.textures
end

texturesLoader:load()

return texturesLoader
