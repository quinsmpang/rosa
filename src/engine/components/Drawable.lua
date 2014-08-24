require(rosa.prefix .. "components.Component")

local Drawable = rosa.types.Component:extends()

Drawable.slot = "drawable"
Drawable.type = "Drawable"
Drawable.collect = true

function Drawable:__init(entity)
    self.super.__init(self, entity)
    
    self.drawable = nil -- Resource reference
    self.color = {255, 255, 255, 255}
    self.quad = nil
    
    -- Runtime prop(s)
    self._drawable = nil -- Cached drawable from the resource
end

rosa.coreman.registerComponent(Drawable)

return Drawable