local utils = {}

function utils.lerp(a, b, t)
    return a + (b - a) * t
end

function utils.normalize(x, y)
    local length = math.sqrt(x ^ 2 + y ^ 2)
    if length == 0 then return { x = 0, y = 0 } end
    return { x = x / length, y = y / length }
end

function utils.vectorLength(x, y)
    return math.sqrt(x ^ 2 + y ^ 2)
end

function utils.gridToScreen(grid_x, grid_y)
    local tile_size = Config:get("tile_size")
    return
        (grid_x - grid_y) * tile_size / 2,
        (grid_x + grid_y) * tile_size / 4
end

function utils.screenToGrid(x, y)
    local tile_size = Config.tile_size
    return {
        x = ((x / (tile_size / 2)) + (y / (tile_size / 4))) / 2,
        y = ((y / (tile_size / 4)) - (x / (tile_size / 2))) / 2
    }
end

function utils.approach(current, target, step)
    if current < target then
        return math.min(current + step, target)
    else
        return math.max(current - step, target)
    end
end

return utils
