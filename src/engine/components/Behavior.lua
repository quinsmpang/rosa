local Behavior = rosa.types.Component:extends()

Behavior.slot = nil
Behavior.type = "Behavior"
Behavior.collect = false

function Behavior:__init(entity, enabled)
    self.super.__init(self, entity)
    
    self.enabled = enabled or true
end

return Behavior