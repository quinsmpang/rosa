local Resource = rosa.types.Resource
local ResourceReference = rosa.types.ResourceReference

local Prefab = rosa.class()

function Prefab:__init(name, component_table)
    self.name = name
    self.components = {}
    
    -- component_table = { { "ComponentClass", {prop1=0, prop2=0}}, ... }
    if component_table then
        for i, component_def in ipairs(component_table) do
            self:addComponent(component_def[1], component_def[2] or {})
        end
    end
    
    rosa.coreman.registerPrefab(self)
end

function Prefab:addComponent(component_type, properties)
    -- TODO: Add validation of prefabs
    self.components[component_type] = self.components[component_type] or {}
    table.insert(self.components[component_type], properties)
end

function Prefab:instantiate(scene)
    local entity = scene:newEntity()
    entity.prefab = self
    
    for component_type, list in pairs(self.components) do
        for i, properties in ipairs(list) do
            local component = entity:addComponent(component_type)
            for property, value in pairs(properties) do
                --print("Setting " .. property .. " to " .. tostring(value))
                if Resource.is(value, Resource) then
                    component[property] = value:getReference()
                elseif ResourceReference.is(value, ResourceReference) then
                    component[property] = value.resource:getReference()
                else
                    component[property] = value
                end
            end
        end
    end
    
    return entity
end

return Prefab