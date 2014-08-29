local rosa = require("__rosa")

local Drawable = rosa.types.Component:extends()

Drawable.slot = "drawable"
Drawable.type = "Drawable"
Drawable.collect = true

function Drawable:__init(entity)
    self.super.__init(self, entity)
    
    self.drawable = nil -- Resource reference
    self.color = {255, 255, 255, 255}
    self.quad = nil
    
    self.origin_x = 0
    self.origin_y = 0
    
    -- Runtime prop(s)
    self._drawable = nil -- Cached drawable from the resource
end

function Drawable:draw()
    if self._drawable == nil or self.drawable.modified then
        self._drawable = self.drawable.resource.data
        self.drawable.modified = false
    end
        
    local x, y, r, sx, sy = 0, 0, 0, 1, 1

    if self.entity.transform then
        x, y, r, sx, sy = self.entity.transform:getTransform()
    end
    
    x = x - (math.cos(r) * self.origin_x - math.sin(r) * self.origin_y)
    y = y - (math.sin(r) * self.origin_x + math.cos(r) * self.origin_y)
    
    if self.quad ~= nil then
        love.graphics.draw(self._drawable, self.quad, x, y, r, sx, sy)
    else
        love.graphics.draw(self._drawable, x, y, r, sx, sy)
    end
end

rosa.coreman.registerComponent(Drawable)

return Drawable