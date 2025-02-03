local bump = require 'lib.bump'
local Physics = {
    initialized = false,
    world = nil
}

function Physics:initialize()
    if not self.initialized then
        self.world = bump.newWorld(64)
        self.world:add({physics_id = 'block'}, 50, 100, 200, 32)
        self.initialized = true
        print("Physics initialized| Tipo:", type(self.world))
    end

    print("map already initialized")
    return self.world
end

function Physics:addEntity(entity, type, x, y, w, h)
    if not self.initialized then
        error("Physics world not initialized!", type(self.world))
    end
    self.world:add(entity, x, y, w, h)
    entity.physics_id = type
end

function Physics:move(entity, x, y)
    if not self.world then
        error("Physics world not initialized!")
    end
    return self.world:move(entity, x, y)
end

function Physics:queryRect(x, y, w, h)
    return self.world:queryRect(x, y, w, h)
end

Physics:initialize()

return Physics
