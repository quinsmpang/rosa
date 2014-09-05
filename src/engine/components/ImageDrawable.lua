local rosa = require("__rosa")

local ImageDrawable = rosa.components.Drawable:extends()

ImageDrawable.__name = "ImageDrawable"
ImageDrawable.type = "drawable"
ImageDrawable.collect = true

function ImageDrawable:__init(entity)
    ImageDrawable.super.__init(self, entity)
    
    self.image = nil -- Resource reference
    self.quad = nil
    
    self.origin_x = 0
    self.origin_y = 0
    
    -- Runtime prop(s)
    self._image = nil -- Cached image from the self.image resource
end

function ImageDrawable:getBoundingBox()
    local w, h = self._image:getDimensions()
    local x, y, r, _, _ = self.entity.transform:getTransform()
    local x1, y1, x2, y2 = x, y, x+w, y+h
    
    x3 = self.origin_x + (x1 - self.origin_x) * math.cos(r) + (y1 - self.origin_y) * math.sin(r)
    y3 = self.origin_y - (x1 - self.origin_x) * math.sin(r) + (y1 - self.origin_y) * math.cos(r)
    
    x4 = self.origin_x + (x2 - self.origin_x) * math.cos(r) + (y2 - self.origin_y) * math.sin(r)
    y4 = self.origin_y - (x2 - self.origin_x) * math.sin(r) + (y2 - self.origin_y) * math.cos(r)
    
    return math.min(x3, x4), math.min(y3, y4), math.max(x3, x4), math.max(y3, y4)
end

rosa.coreman.registerComponent(ImageDrawable)

return ImageDrawable