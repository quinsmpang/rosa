require(rosa.prefix .. "components.Component")

Drawable = Component:extends()

Drawable.slot = "drawable"
Drawable.type = "Drawable"
Drawable.collect = true

function Drawable:__init(entity)
    Component.__init(self, entity)
    
    self.transform = self.entity.transform
    
    self.drawable = nil
    self.quad = nil
    
    self.color = color or {255, 255, 255, 255}
end

function Drawable:draw()
    local x, y, r, sx, sy = 0, 0, 0, 1, 1
    
    if self.transform then
        x, y, r, sx, sy = self.transform:getTransform()
    end
    
    if self.quad then
        love.graphics.draw(self.drawable, self.quad, x, y, r, sx, sy)
    else
        love.graphics.draw(self.drawable, x, y, r, sx, sy)
    end
end

coreman.registerComponent(Drawable)