class = require("lib.30log")

Behavior = Component:extends()

Behavior.slot = nil
Behavior.type = "Behavior"
Behavior.collect = false

function Behavior:__init(entity, enabled)
    Component.__init(self, entity)
    
    self.enabled = enabled or true
end