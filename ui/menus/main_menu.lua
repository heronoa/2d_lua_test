local Menu = {}
Menu.__index = Menu
local Button = require('ui.widgets.button')
local Config = require('src.core.config')
local GameState = require('src.core.game_state')

local function loadFont(path, size)
    local success, font = pcall(love.graphics.newFont, path, size)
    return success and font or love.graphics.newFont(size)
end

function Menu:enter()
    self.buttons = {
        Button.new({
            label = "New Game",
            action = function()
                GameState:switch('Game')
            end,
            position = { x = 0, y = 200 },
            width = 200,
            height = 40
        }),
        Button.new({
            label = "Load Game",
            action = function()
                GameState:switch('Game')
            end,
            position = { x = 0, y = 260 },
            width = 200,
            height = 40
        }),
        Button.new({
            label = "Settings",
            action = function()
                GameState:switch('Settings')
            end,
            position = { x = 0, y = 320 },
            width = 200,
            height = 40
        }),
        Button.new({
            label = "Quit",
            action = function()
                love.event.quit()
            end,
            position = { x = 0, y = 380 },
            width = 200,
            height = 40
        })
    }

    self.animation = {
        timer = 0,
        title_offset = -100
    }

    self.font = loadFont("assets/fonts/main.ttf", 24)
    self.title_font = loadFont("assets/fonts/title.ttf", 48)

    if Config:get("debug_mode") then
        print("Menu entered and initialized")
    end

    return self
end

function Menu:update(dt)
    self.animation.timer = self.animation.timer + dt
    self.animation.title_offset = math.sin(self.animation.timer) * 10
    -- self.animation.title_offset = math.min(0, self.animation.title_offset + 200 * dt)

    for _, button in ipairs(self.buttons) do
        button:update(dt)
    end
end

function Menu:draw()
    local sx, sy = Config:getScaleX(), Config:getScaleY()

    love.graphics.push()
    love.graphics.scale(sx, sy)

    love.graphics.setColor(0.1, 0.1, 0.2)
    local virtual_width, virtual_height = Config:get("virtual_width"), Config:get("virtual_height")

    love.graphics.rectangle('fill', 0, 0, virtual_width, virtual_height)

    love.graphics.setFont(self.title_font)
    love.graphics.setColor(0.9, 0.9, 1)
    love.graphics.printf("Isometric RPG", 0, Config:get('virtual_height') / 6 + self.animation.title_offset,
        Config:get("virtual_width"), 'center')

    love.graphics.setFont(self.font)
    local center_x = Config:get("virtual_width") / 2

    for _, button in ipairs(self.buttons) do
        button.position.x = center_x - button.width / 2
        button:draw()
    end

    love.graphics.pop()
end

function Menu:keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function Menu:mousepressed(x, y, button)
    local scaled_x = x / Config:getScaleX()
    local scaled_y = y / Config:getScaleY()


    for _, button in ipairs(self.buttons) do
        if button:isHovered(scaled_x, scaled_y) then
            button:activate()
        end
    end
end

return Menu
