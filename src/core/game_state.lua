local GameState = {
    current = nil,
    states = {}
}

function GameState:registerStates(states)
    for name, state in pairs(states) do
        self.states[name] = state
    end
end

function GameState:switch(name, params)
    if self.current and self.current.exit then
        self.current:exit()
    end
    self.current = self.states[name]
    if self.current.enter then
        if Config:get("debug_mode") then
            print("Switching to " .. name)
        end
        self.current:enter(params or {})
    end
end

function GameState:update(dt)
    if self.current and self.current.update then
        self.current:update(dt)
    end
end

function GameState:draw()
    if self.current and self.current.draw then
        self.current:draw()
    end
end

function GameState:keypressed(...)
    if self.current and self.current.keypressed then
        self.current:keypressed(...)
    end
end

function GameState:mousepressed(...)
    if self.current and self.current.mousepressed then
        self.current:mousepressed(...)
    end
end

return GameState
