local GameState = require('src.core.game_state')
local Config = require('src.core.config')

function love.load()
    love.window.setMode(
        virtual_width or 1200, virtual_height or 720,
        {
            resizable = false,
            vsync = 0,
            minwidth = 1200,
            minheight = 720
        }
    )

    Config:initialize({
        debug_mode = true,
        virtual_width = 1200,
        virtual_height = 720,
        scale_mode = 'nearest'
    })

    local virtual_width, virtual_height = Config:get('virtual_width'), Config:get('virtual_height')

    print('Virtual Width: ' .. virtual_width)
    print('Virtual Height: ' .. virtual_height)


    love.window.setTitle('isometric_rpg')

    GameState:registerStates({
        MainMenu = require('ui.menus.main_menu'),
        Game = require('src.game.scenes.test_scene'),
        -- PauseMenu = require('src.ui.menus.pause_menu'),
        -- Settings = require('src.ui.menus.settings')
    })

    GameState:switch('MainMenu')
end

local function drawDebugOverlay()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print('FPS: ' .. love.timer.getFPS(), 10, 10)
    love.graphics.print('Current State: ' .. GameState:currentName(), 10, 30)
    love.graphics.print('Mouse Position' .. tostring(love.mouse.getX()) .. ', ' .. tostring(love.mouse.getY()), 10, 90)
    love.graphics.print('Debug Mode: ' .. tostring(Config.debug_mode), 10, 70)


    local currentState = GameState:current()
    if currentState and currentState.player and currentState.player.position then
        local p = currentState.player.position
        love.graphics.print(string.format('Player Position: (%.1f, %.1f)', p.x, p.y), 10, 50)
    end
end

function love.update(dt)
    GameState:update(dt)
end

function love.draw()
    love.graphics.push()

    local sx, sy = Config:getScaleX(), Config:getScaleY()

    love.graphics.scale(sx, sy)

    GameState:draw()


    if Config.debug_mode then
        drawDebugOverlay()
    end

    love.graphics.pop()
end

function love.mousepressed(x, y, button)
    local gameX, gameY = Config:scalePoint(x, y)
    GameState:mousepressed(gameX, gameY, button)
end

function love.keypressed(key)
    GameState:keypressed(key)
end

function love.resize(w, h)
    Config:updateWindowSize(w, h)
end
