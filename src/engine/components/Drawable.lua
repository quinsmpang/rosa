require(rosa.prefix .. "components.Component")

Drawable = Component:extends()

Drawable.slot = "drawable"
Drawable.type = "Drawable"
Drawable.collect = true

function Drawable:__init(entity)
    Component.__init(self, entity)
    
    self.drawable = nil -- Resource reference
    self.color = {255, 255, 255, 255}
    self.quad = nil
    
    -- Runtime prop(s)
    self._drawable = nil -- Cached drawable from the resource
end

coreman.registerComponent(Drawable)