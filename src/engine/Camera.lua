local rosa = require("__rosa")

Camera = rosa.class()

function Camera:__init(x, y, scaleX, scaleY, rotation, screen_scale, pixel_perfect)
    self.x = x or 0
    self.y = y or 0
    self.scaleX = scaleX or 1
    self.scaleY = scaleY or 1
    self.rotation = rotation or 0.0
    self.screen_scale = screen_scale or 1
    self.pixel_perfect = pixel_perfect or false
end


function Camera:set()
    love.graphics.push()
    love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
    love.graphics.rotate(-self.rotation)
    if self.pixel_perfect then
        love.graphics.translate(math.floor(-self.x), math.floor(-self.y))
    else
        love.graphics.translate(-self.x, -self.y)
    end
end

function Camera:unset()
    love.graphics.pop()
end

function Camera:move(dx, dy)
    self.x = self.x + (dx or 0)
    self.y = self.y + (dy or 0)
end

function Camera:rotate(dr)
    self.rotation = self.rotation + dr
end

function Camera:scale(sx, sy)
    sx = sx or 1
    self.scaleX = self.scaleX * sx
    self.scaleY = self.scaleY * (sy or sx)
end

function Camera:scaleAround(x, y, sx, sy)
    sx = sx or 1
    sy = sy or sx
    self.scaleX = self.scaleX * sx
    self.scaleY = self.scaleY * sy
    self:move(-x, -y)
    self.x = self.x * sx
    self.y = self.y * sy
    self:move(x, y)
end

function Camera:setPosition(x, y)
    self.x = x or self.x
    self.y = y or self.y
end

function Camera:setScale(sx, sy)
    self.scaleX = sx or self.scaleX
    self.scaleY = sy or sx or self.scaleY
end

function Camera:getMousePosition()
    return self:translatePosition(love.mouse.getX(), love.mouse.getY())
end

function Camera:translatePosition(x, y)
    return x * self.scaleX / self.screen_scale + self.x, y * self.scaleY / self.screen_scale  + self.y
end