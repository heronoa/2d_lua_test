Config = require("src.core.config")

local Button = {
    label = "",
    action = nil,
    position = { x = 0, y = 0 },
    width = 200,
    height = 40,
    state = "normal",
    align = "center"
}

Button.__index = Button

function Button.new(params)
    local self = setmetatable({}, Button)

    self.label = params.label or ""
    self.action = params.action or nil
    self.position = params.position or { x = 0, y = 0 }
    self.width = params.width or 200
    self.height = params.height or 40
    self.state = "normal"

    return self
end

function Button:update(dt)
    local mx, my = love.mouse.getPosition()
    mx = mx / Config:getScaleX(mx)
    my = my / Config:getScaleY(my)

    self.state = 'normal'
    if Button:isHovered(mx, my) then
        self.state = love.mouse.isDown(1) and 'pressed' or 'hover'
    end
end

function Button:draw()
    local colors = {
        normal = { 0.3, 0.3, 0.5 },
        hover = { 0.4, 0.4, 0.7 },
        pressed = { 0.2, 0.2, 0.4 }
    }

    love.graphics.setColor(colors[self.state])
    love.graphics.rectangle('fill', self.position.x, self.position.y, self.width, self.height)

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(
        self.label,
        self.position.x,
        self.position.y + self.height / 2 - 10,
        self.width,
        self.align
    )
end

function Button:isHovered(mx, my)
    return mx >= self.position.x and
        mx <= self.position.x + self.width and
        my >= self.position.y and
        my <= self.position.y + self.height
end

function Button:activate()
    if self.action then
        self.action()
    end
end

return Button
