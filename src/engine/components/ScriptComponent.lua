require(rosa.prefix .. "components.Component")

ScriptComponent = Behavior:extends()

ScriptComponent.slot = "script"
ScriptComponent.type = "ScriptComponent"
ScriptComponent.collect = true
ScriptComponent.allow_multiple = true

function ScriptComponent:__init(entity, enabled)
    Behavior.__init(self, entity, enabled or false)
    
    self.transform = self.entity.transform
    
    self.drawable = nil
    self.quad = nil
    
    self.color = color or {255, 255, 255, 255}
end

function ScriptComponent:update(dt) end