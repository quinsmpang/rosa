local rosa = require("__rosa")

local Drawable = rosa.types.Component:extends()

Drawable.__name = "Drawable"
Drawable.type = "drawable"
Drawable.collect = true

function Drawable:__init(entity)
    Drawable.super.__init(self, entity)
    
    self.color = {255, 255, 255, 255}
    self.layer = ""
    self.layer_order = 0
end

function Drawable:getBoundingBox()
    return nil
end

return Drawable