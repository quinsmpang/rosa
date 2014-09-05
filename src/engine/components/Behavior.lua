local rosa = require("__rosa")

local Behavior = rosa.types.Component:extends()

Behavior.__name = "Behavior"
Behavior.type = nil
Behavior.collect = false

function Behavior:__init(entity, enabled)
    Behavior.super.__init(self, entity)
    
    self.enabled = enabled or true
end

return Behavior