mapGen = require("mapGen")


function love.load()
    -- Game states
    GameState = {
        current = "menu",
        saved = nil -- Will store game state when paused
    }

    TileProps = {
        [1] = { walkable = true, colors = { 0.2, 0.8, 0.2 } },
        [2] = { walkable = false, colors = { 0.2, 0.2, 1.0 } },
        [3] = { walkable = false, colors = { 0.5, 0.5, 0.5 } }
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


    NPCs = {
        {
            gridX = 7,
            gridY = 7,
            health = 100,
            alive = true,
            damageNumbers = {}
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

        for _, npc in ipairs(NPCs) do
            if npc.alive then
                for i = #npc.damageNumbers, 1, -1 do
                    local dmg = npc.damageNumbers[i]
                    dmg.timer = dmg.timer - dt
                    dmg.yOffset = dmg.yOffset - 50 * dt -- Velocidade de subida
                    
                    if dmg.timer <= 0 then
                        table.remove(npc.damageNumbers, i)
                    end
                end
            end
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
    mapWidth = 25
    mapHeight = 25

    Player = {
        gridX = 5,
        gridY = 5,
        moving = false,
        attacking = false,
        speed = 1,
        screenX = 0,
        screenY = 0,
        facing = "S" -- N, S, E, W
    }


    NPCs = {
        {
            gridX = 7,
            gridY = 7,
            health = 100,
            alive = true,
            damageNumbers = {}
        }
    }

    Map = mapGen.generateMap(mapWidth, mapHeight)
    -- {
    --     { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
    --     { 1, 1, 2, 2, 1, 1, 3, 3, 1, 1 },
    --     { 1, 1, 2, 2, 1, 1, 3, 3, 1, 1 },
    --     { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
    --     { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
    --     { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
    --     { 1, 1, 3, 3, 1, 1, 2, 2, 1, 1 },
    --     { 1, 1, 3, 3, 1, 1, 2, 2, 1, 1 },
    --     { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
    --     { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }
    -- }

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
    local playerInitialX, playerInitialY = playerScreenX - tileWidth / 2, playerScreenY - tileHeight
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", playerInitialX, playerInitialY, tileWidth, tileHeight * 2)
    love.graphics.setColor(1, 1, 1)


    for _, npc in ipairs(NPCs) do
        if npc.alive then
            local npcScreenX, npcScreenY = gridToScreen(npc.gridX, npc.gridY)
            local npcInitialX = npcScreenX - tileWidth / 2
            local npcInitialY = npcScreenY - tileHeight
            love.graphics.setColor(0, 0, 1) -- Cor azul para NPC
            love.graphics.rectangle("fill", npcInitialX, npcInitialY, tileWidth, tileHeight * 2)
        end
    end

    -- Draw player facing direction
    local facingX, facingY = Player.gridX, Player.gridY
    if Player.facing == "N" then
        facingY = facingY - 1
    elseif Player.facing == "S" then
        facingY = facingY + 1
    elseif Player.facing == "W" then
        facingX = facingX - 1
    elseif Player.facing == "E" then
        facingX = facingX + 1
    end

    if facingX >= 1 and facingX <= mapWidth and facingY >= 1 and facingY <= mapHeight then
        local tileScreenX, tileScreenY = gridToScreen(facingX, facingY)

        local centerX = tileScreenX
        local centerY = tileScreenY + tileHeight / 2

        love.graphics.setColor(1, 1, 0)
        love.graphics.print("X", centerX - 10, centerY - 8) -- Ajuste fino para centralizar

        love.graphics.setColor(1, 1, 1)
    end


    love.graphics.setColor(1, 1, 1)
    for _, npc in ipairs(NPCs) do
        if npc.alive then
            -- ... (código de desenho do NPC existente)

            -- Desenha os números de dano
            local npcScreenX, npcScreenY = gridToScreen(npc.gridX, npc.gridY)
            for _, dmg in ipairs(npc.damageNumbers) do
                local alpha = math.max(0, dmg.timer) -- Transparência decrescente
                local textY = (npcScreenY - tileHeight) - dmg.yOffset -- Posição ajustada
                
                love.graphics.setColor(1, 0, 0, alpha)
                love.graphics.printf(
                    tostring(dmg.amount),
                    npcScreenX - 20, -- Centraliza horizontalmente
                    textY,
                    40,
                    "center"
                )
            end
        end
    end

    love.graphics.pop()
end

function NPCCollision(x, y)
    for _, npc in ipairs(NPCs) do
        if npc.alive and npc.gridX == x and npc.gridY == y then
            return false
        end
    end
    return true
end

function handleGameInput(key)
    if key == "escape" then
        GameState.saved = {
            player = { gridX = Player.gridX, gridY = Player.gridY },
            map = Map
        }
        GameState.current = "paused"
    elseif not Player.moving then
        local newX, newY = Player.gridX, Player.gridY

        if key == "w" then
            newY = newY - 1
            Player.facing = "N"
        elseif key == "s" then
            newY = newY + 1
            Player.facing = "S"
        elseif key == "a" then
            newX = newX - 1
            Player.facing = "W"
        elseif key == "d" then
            newX = newX + 1
            Player.facing = "E"
        elseif key == "space" then
            -- Attack
            Player.attacking = true
            Timer.after(0.5, function()
                Player.attacking = false
            end)
        end

        if newX >= 1 and newX <= mapWidth and newY >= 1 and newY <= mapHeight and Map[newY][newX] ~= 0 and TileProps[Map[newY][newX]].walkable and NPCCollision(newX, newY) then
            Player.gridX = newX
            Player.gridY = newY
            Player.moving = true
        end
    end
end

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
        [3] = { 0.5, 0.5, 0.5 }  -- Stone
    }

    love.graphics.setColor(TileProps[tileType].colors)
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

function attack()
    local targetX, targetY = Player.gridX, Player.gridY

    -- Determinar a posição alvo baseado na direção
    if Player.facing == "N" then
        targetY = targetY - 1
    elseif Player.facing == "S" then
        targetY = targetY + 1
    elseif Player.facing == "E" then
        targetX = targetX + 1
    elseif Player.facing == "W" then
        targetX = targetX - 1
    end

    -- Verificar se o alvo está dentro do mapa
    if targetX >= 1 and targetX <= mapWidth and targetY >= 1 and targetY <= mapHeight then
        -- Procurar NPCs na posição alvo
        for _, npc in ipairs(NPCs) do
            if npc.alive and npc.gridX == targetX and npc.gridY == targetY then
                npc.health = npc.health - 20
                
                -- Adiciona o número de dano à lista
                table.insert(npc.damageNumbers, {
                    amount = 20,
                    timer = 1, -- Tempo de exibição em segundos
                    yOffset = 0 -- Posição vertical inicial
                })
                
                if npc.health <= 0 then
                    npc.alive = false
                end
                break
            end
        end
    end
end

function love.mousepressed(x, y, button)

    if x >= 0 and x <= love.graphics.getWidth() and y >= 0 and y <= love.graphics.getHeight() then

        x = x - Camera.x 
        y = y - Camera.y
        local gridX = math.floor((y + x / 2) / tileHeight)
        local gridY = math.floor((y - x / 2) / tileHeight)

        print("Clicked on grid position: " .. gridX .. ", " .. gridY)
    end
    if GameState.current == "playing" and button == 1 then
        attack()
    end
end
