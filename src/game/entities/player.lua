local Player = {}
Player.__index = Player

local utils = require('src.core.utils')
local Config = require('src.core.config')
local Physics = require('src.game.world.physics')

function Player.new(inital_x, initial_y)
    local self = setmetatable({}, Player)

    self.position = { x = inital_x or 640, y = initial_y or 360 }
    self.situations = {
        idle = 'idle',
        idle_n = 'idle_n',
        idle_s = 'idle_s',
        idle_w = 'idle_w',
        idle_e = 'idle_e',
        walking = 'walking',
        attacking = 'attacking'
    }
    self.direction = 's'
    self.situation = "idle"
    self.velocity = { x = 0, y = 0 }
    self.speed = 400
    self.acceleration = 1800
    self.friction = 1600
    self.size = { width = 40, height = 60 }

    self.facing = {
        angle = math.pi / 2,
        indicator_distance = 80
    }

    self.animation = {
        timer = 0,
        frame = 1,
        walk_cycle = { 1, 2, 3, 4, 5, 6 }
    }

    if not Physics.initialized then
        Physics:initialize()
    end

    Physics:addEntity(self, 'player', self.position.x, self.position.y, self.size.width, self.size.height)


    return self
end

function Player:update(dt)
    local move_x, move_y = 0, 0

    if love.keyboard.isDown('w') then
        move_y = -1
    end
    if love.keyboard.isDown('s') then
        move_y = 1
    end
    if love.keyboard.isDown('a') then
        move_x = -1
    end
    if love.keyboard.isDown('d') then
        move_x = 1
    end



    local move_vector = utils.normalize(move_x, move_y)

    self.velocity.x = self.velocity.x + move_vector.x * self.acceleration * dt
    self.velocity.y = self.velocity.y + move_vector.y * self.acceleration * dt

    local current_speed = utils.vectorLength(self.velocity.x, self.velocity.y)

    if current_speed > self.speed then
        local normalized = utils.normalize(self.velocity.x, self.velocity.y)
        self.velocity.x = normalized.x * self.speed
        self.velocity.y = normalized.y * self.speed
    end

    if move_x == 0 and move_y == 0 then
        local friction = self.friction * dt
        self.velocity.x = utils.approach(self.velocity.x, 0, friction)
        self.velocity.y = utils.approach(self.velocity.y, 0, friction)
    end

    local target_x = self.position.x + self.velocity.x * dt
    local target_y = self.position.y + self.velocity.y * dt

    -- if move_x ~= 0 or move_y ~= 0 then
    -- For gamepad support'
    --     self.facing.angle = math.atan2(self.velocity.y, self.velocity.x)
    -- end

    if love.mousepressed then
        local mouse_x, mouse_y = love.mouse.getPosition()
        local player_x, player_y = Config:get("virtual_width") / 2, Config:get("virtual_height") / 2
        local angle = math.atan2(mouse_y - player_y, mouse_x - player_x)
        self.facing.angle = angle

        local angleRange = math.pi / 4

        if angle < angleRange and angle > -angleRange then
            self:changeDirection("e")
        elseif angle < -angleRange and angle > -math.pi + angleRange then
            self:changeDirection("n")
        elseif angle < -math.pi + angleRange or angle > math.pi - angleRange then
            self:changeDirection("w")
        else
            self:changeDirection("s")
        end
    end

    local actual_x, actual_y, cols, len = Physics:move(self, target_x, target_y)
    self.position.x = actual_x
    self.position.y = actual_y

    if move_x ~= 0 or move_y ~= 0 then
        self:changeSituation("walking")

        self.animation.timer = self.animation.timer + dt
        if self.animation.timer > 0.1 then
            self.animation.frame = self.animation.frame % #self.animation.walk_cycle + 1
            self.animation.timer = 0
        end
    else
        self.animation.frame = 1
        self:changeSituation("idle")
    end
end

function Player:getScreenPosition()
    return self.position.x - Config:get('tile_size') / 2, self.position.y - Config:get('tile_size') / 2
end

function Player:draw()
    if Config:getTexture("player") and Config:getTexture("player_idle") then
        if (self.situation == "walking") then
            love.graphics.draw(
                Config:getTexture('player'),
                Config:getTexture('player_' ..
                    self.situation .. '_' .. self.direction .. '_' .. self.animation.walk_cycle[self.animation.frame]),
                self.position.x - 30,
                self.position.y - 90,
                0,
                self.size.width / 24,
                self.size.height / 24,
                1,
                1
            )
        else
            love.graphics.draw(
                Config:getTexture('player'),
                Config:getTexture('player_' .. self.situation .. "_" .. self.direction),
                self.position.x - 30,
                self.position.y - 90,
                0,
                self.size.width / 24,
                self.size.height / 24,
                1,
                1
            )
        end
    else
        love.graphics.setColor(0.8, 0.2, 0.2)
        love.graphics.rectangle(
            'fill',
            self.position.x - self.size.width / 2,
            self.position.y - self.size.height,
            self.size.width,
            self.size.height
        )
    end



    self:drawFacingIndicator((self.position.x or 0), ((self.position.y - self.size.height / 2) or 0))

    if (self:getScreenPosition() ~= nil) then
        love.graphics.translate(self:getScreenPosition())
    end


    if Config.debug_mode then
        love.graphics.setColor(0, 1, 0, 0.5)
        love.graphics.rectangle('line', self.position.x - self.size.width / 2, self.position.y - self.size.height,
            self.size.width,
            self.size.height)

        love.graphics.setColor(1, 1, 0)
        love.graphics.line(
            (self.position.x or 0),
            (self.position.y or 0),
            (self.position.x or 0) + math.cos(self.facing.angle) * 30,
            (self.position.y or 0) + math.sin(self.facing.angle) * 30
        )
    end
end

function Player:drawFacingIndicator(x, y)
    local indicator_x = x + math.cos(self.facing.angle) * self.facing.indicator_distance
    local indicator_y = y + math.sin(self.facing.angle) * self.facing.indicator_distance

    if Config.debug_mode then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(string.format('Facing: %.2f', self.facing.angle), x, y)
    end

    love.graphics.setColor(1, 0, 0)
    love.graphics.line(
        indicator_x - 10,
        indicator_y - 10,
        indicator_x + 10,
        indicator_y + 10
    )
    love.graphics.line(
        indicator_x + 10,
        indicator_y - 10,
        indicator_x - 10,
        indicator_y + 10
    )
end

function Player:changeDirection(direction)
    self.direction = direction
end

function Player:changeSituation(situation)
    self.situation = situation
end

return Player
