require(rosa.prefix .. "components.Component")

Transform = Component:extends()

Transform.slot = "transform"
Transform.type = "Transform"
Transform.collect = false

function Transform:__init(entity)
    Component.__init(self, entity)
    
    self.x = 0
    self.y = 0
    self.r = 0
    self.sx = 1.0
    self.sy = 1.0
    
    self.parent_transform = nil
    self.child_transforms = {}
end

function Transform:setParent(parent_entity)
    if self.parent_transform ~= nil then
        self.parent_transform.child_transforms[self] = nil
    end
    
    self.parent_transform = parent_entity.transform
    
    if self.parent_transform ~= nil then
        self.parent_transform.child_transforms[self] = self
    end
end

function Transform:getTransform()
    if self.parent_transform then
        local x, y, r, sx, sy = self.parent_transform:getTransform()
        x = x + math.sin(r) * self.x + math.cos(r) * self.y
        y = y + math.sin(r) * self.y + math.cos(r) * self.x
        sx = sx * self.sx
        sy = sy * self.sy
        r = r + self.r
        return x, y, r, sx, sy
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

coreman.registerComponent(Transform)