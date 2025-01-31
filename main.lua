-- main.lua
function love.load()
    -- Game states
    GameState = {
        current = "menu",
        saved = nil -- Will store game state when paused
    }

    -- Menu system
    Menus = {
        main = {
            options = { "Start Game", "Exit" },
            selected = 1
        },
        pause = {
            options = { "Resume", "Main Menu" },
            selected = 1
        }
    }

    -- Initialize fonts
    TitleFont = love.graphics.newFont(32)
    MenuFont = love.graphics.newFont(24)
end


function love.update(dt)
    if GameState.current == "playing" then
        -- Update game logic here
        if Player.moving then
            local targetX, targetY = gridToScreen(Player.gridX, Player.gridY)
            local newPlayerX, newPlayerY = lerp(Player.screenX, targetX, Player.speed),
                lerp(Player.screenY, targetY, Player.speed)
        
            Player.screenX = newPlayerX
            Player.screenY = newPlayerY

            if math.abs(Player.screenX - targetX) < 1 and math.abs(Player.screenY - targetY) < 1 then
                Player.moving = false
            end
        end

        if (Player.screenX and Player.screenY) then
            -- Update camera position
            Camera.x = love.graphics.getWidth() / 2 - Player.screenX
            Camera.y = love.graphics.getHeight() / 2 - Player.screenY
        end
    end
end

function love.draw()
    if GameState.current == "menu" then
        drawMainMenu()
    elseif GameState.current == "playing" then
        drawGame()
    elseif GameState.current == "paused" then
        drawGame()
        drawPauseMenu()
    end
end

function love.keypressed(key)
    if GameState.current == "menu" then
        handleMainMenuInput(key)
    elseif GameState.current == "playing" then
        handleGameInput(key)
    elseif GameState.current == "paused" then
        handlePauseMenuInput(key)
    end
end

-- Main Menu Functions
function drawMainMenu()
    love.graphics.setFont(TitleFont)
    love.graphics.printf("Skyrim 2D", 0, 100, love.graphics.getWidth(), "center")

    love.graphics.setFont(MenuFont)
    for i, option in ipairs(Menus.main.options) do
        local y = 200 + (i * 50)
        local color = { 1, 1, 1 }
        if i == Menus.main.selected then
            color = { 1, 0.5, 0 }
        end
        love.graphics.setColor(color)
        love.graphics.printf(option, 0, y, love.graphics.getWidth(), "center")
    end
end

function handleMainMenuInput(key)
    if key == "up" then
        Menus.main.selected = math.max(1, Menus.main.selected - 1)
    elseif key == "down" then
        Menus.main.selected = math.min(#Menus.main.options, Menus.main.selected + 1)
    elseif key == "return" then
        if Menus.main.selected == 1 then
            initializeGame()
            GameState.current = "playing"
        elseif Menus.main.selected == 2 then
            love.event.quit()
        end
    end
end

-- Game Functions
function initializeGame()
    -- Game initialization code from previous example
    tileWidth = 64
    tileHeight = 32
    mapWidth = 10
    mapHeight = 10

    Player = {
        gridX = 5,
        gridY = 5,
        moving = false,
        speed = 0.2,
        screenX = 0,
        screenY = 0
    }

    Map = {
        { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
        { 1, 1, 2, 2, 1, 1, 3, 3, 1, 1 },
        { 1, 1, 2, 2, 1, 1, 3, 3, 1, 1 },
        { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
        { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
        { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
        { 1, 1, 3, 3, 1, 1, 2, 2, 1, 1 },
        { 1, 1, 3, 3, 1, 1, 2, 2, 1, 1 },
        { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
        { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }
    }

    Camera = {
        x = 0,
        y = 0
    }
end

function drawGame()
    love.graphics.push()
    love.graphics.translate(Camera.x, Camera.y)

    -- Draw map
    for y = 1, mapHeight do
        for x = 1, mapWidth do
            if Map[y][x] ~= 0 then
                local screenX, screenY = gridToScreen(x, y)
                drawTile(screenX, screenY, Map[y][x])
            end
        end
    end

    -- Draw player
    local playerScreenX, playerScreenY = gridToScreen(Player.gridX, Player.gridY)
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", playerScreenX - tileWidth / 2, playerScreenY - tileHeight, tileWidth, tileHeight * 2)
    love.graphics.setColor(1, 1, 1)

    love.graphics.pop()
end

function handleGameInput(key)
    if key == "escape" then
        GameState.saved = {
            player = { gridX = Player.gridX, gridY = Player.gridY },
            map = Map
        }
        GameState.current = "paused"
    elseif not Player.moving then
        -- Original movement code
        local newX, newY = Player.gridX, Player.gridY

        if key == "w" then
            newY = newY - 1
        elseif key == "s" then
            newY = newY + 1
        elseif key == "a" then
            newX = newX - 1
        elseif key == "d" then
            newX = newX + 1
        end

        if newX >= 1 and newX <= mapWidth and newY >= 1 and newY <= mapHeight and Map[newY][newX] ~= 0 and Map[newY][newX] ~= 2 then
            Player.gridX = newX
            Player.gridY = newY
            Player.moving = true
        end
    end
end

-- Pause Menu Functions
function drawPauseMenu()
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setFont(TitleFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Paused", 0, 100, love.graphics.getWidth(), "center")

    love.graphics.setFont(MenuFont)
    for i, option in ipairs(Menus.pause.options) do
        local y = 200 + (i * 50)
        local color = { 1, 1, 1 }
        if i == Menus.pause.selected then
            color = { 1, 0.5, 0 }
        end
        love.graphics.setColor(color)
        love.graphics.printf(option, 0, y, love.graphics.getWidth(), "center")
    end
end

function handlePauseMenuInput(key)
    if key == "up" then
        Menus.pause.selected = math.max(1, Menus.pause.selected - 1)
    elseif key == "down" then
        Menus.pause.selected = math.min(#Menus.pause.options, Menus.pause.selected + 1)
    elseif key == "return" then
        if Menus.pause.selected == 1 then
            GameState.current = "playing"
        elseif Menus.pause.selected == 2 then
            GameState.current = "menu"
            GameState.saved = nil
        end
    elseif key == "escape" then
        GameState.current = "playing"
    end
end

-- Helper functions (same as before)
function gridToScreen(x, y)
    local screenX = (x - y) * tileWidth / 2
    local screenY = (x + y) * tileHeight / 2
    return screenX, screenY
end

function drawTile(x, y, tileType)
    local colors = {
        [1] = { 0.2, 0.8, 0.2 }, -- Grass
        [2] = { 0.2, 0.2, 1.0 }, -- Water
        [3] = { 0.5, 0.5, 0.5 } -- Stone
    }

    love.graphics.setColor(colors[tileType])
    local points = {
        x, y,
        x + tileWidth / 2, y + tileHeight / 2,
        x, y + tileHeight,
        x - tileWidth / 2, y + tileHeight / 2
    }
    love.graphics.polygon("fill", points)
    love.graphics.setColor(1, 1, 1)
end

function lerp(a, b, t)
    return a + (b - a) * t
end
