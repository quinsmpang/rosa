local rosa = require("__rosa")

local Transform = rosa.components.Component:extends()

Transform.__name = "Transform"
Transform.type = "transform"
Transform.collect = false

function Transform:__init(entity)
    Transform.super.__init(self, entity)
    
    self.x = 0
    self.y = 0
    self.r = 0
    self.sx = 1.0
    self.sy = 1.0
    
    self.relative = false
end

function Transform:getTransform()
    if self.relative then
        if self.entity.parent and self.entity.parent.transform then
            local x, y, r, sx, sy = self.entity.parent.transform:getTransform()
            x = x + (math.cos(r) * self.x - math.sin(r) * self.y)
            y = y + (math.sin(r) * self.x + math.cos(r) * self.y)
            sx = sx * self.sx
            sy = sy * self.sy
            r = r + self.r
            return x, y, r, sx, sy
        end
    end
    
    return self.x, self.y, self.r, self.sx, self.sy
end

function Transform:destroy()
    if self.parent_transform ~= nil then
        self.parent_transform[self] = self
    end
    
    if #self.child_transforms > 0 then
        for _, child in pairs(self.child_transforms) do
            child.parent_transform = nil
        end
    end
    
    self.child_transforms = nil
end

rosa.coreman.registerComponent(Transform)

return Transform