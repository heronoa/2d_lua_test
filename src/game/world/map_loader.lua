local MapLoader = {}

function MapLoader:generate(width, height, island)
    local map = {}
    
    -- Initialize map with grass (1)
    for y = 1, height do
        map[y] = {}
        for x = 1, width do
            map[y][x] = 1
        end
    end

    if island then
        for y = 1, height do
            map[y][1] = 2
            map[y][width] = 2
        end
        for x = 1, width do
            map[1][x] = 2
            map[height][x] = 2
        end
    end

    -- Function to add water flow
    local function addWaterFlow()
        local x, y = math.random(1, width), math.random(1, height)
        local length = math.random(5, math.min(width, height))
        for i = 1, length do
            if x > 0 and x <= width and y > 0 and y <= height then
                map[y][x] = 2
                if math.random() > 0.5 then
                    x = x + math.random(-1, 1)
                else
                    y = y + math.random(-1, 1)
                end
            end
        end
    end

    -- Function to add rocks
    local function addRocks()
        for i = 1, math.random(5, 15) do
            local x, y = math.random(1, width), math.random(1, height)
            if map[y][x] == 1 then
                map[y][x] = 3
            end
        end
    end

    -- Add water flows
    for i = 1, math.random(1, 3) do
        addWaterFlow()
    end

    -- Add rocks
    addRocks()

    return map
end

return MapLoader