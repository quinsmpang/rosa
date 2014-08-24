local Component = rosa.class()

-- slot: What slot/name in the entity this component occupies
-- type: the class name of this component, TODO: AA
-- collect: Whether this component should be pooled for any systems that might want to iterate on it
Component.slot = nil
Component.type = "Component"
Component.collect = false
Component.allow_multiple = false

function Component:__init(entity)
    if not rosa.types.Entity.is(entity, rosa.types.Entity) then
        error("Given entity argument is not an actual Entity instance")
    end
    
    -- entity: The entity this component is attached to
    self.entity = entity
end

function Component:destroy() end

return Component