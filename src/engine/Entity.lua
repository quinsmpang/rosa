local Entity = rosa.class()

function Entity:__init(scene)
    self.scene = scene
    self.prefab = nil
    
    self.components = {} -- table<name:string, table<component>>
end

function Entity:destroy()
    for name, component in self.pairs(self.components) do
        self:removeComponent(name)
    end
end

function Entity:addComponent(component_type)
    local ComponentClass = rosa.coreman.getComponentClass(component_type)
    
    self.components[component_type] = self.components[component_type] or {}
    
    if not ComponentClass.allow_multiple then
        if #self.components[component_type] > 0 then
            error("This Entity already has a '" .. component_type .. "' component, and it's not possible to add more")
        end
    end
    
    local component = ComponentClass(self)
    
    table.insert(self.components[component_type], component)
    
    if ComponentClass.slot then
        if ComponentClass.allow_multiple then
            self[ComponentClass.slot] = self[ComponentClass.slot] or {}
            self[ComponentClass.slot][component] = component
        else
            self[ComponentClass.slot] = component
        end
        
        if ComponentClass.collect then
            self.scene.nodes[ComponentClass.slot] = self.scene.nodes[ComponentClass.slot] or {}
            self.scene.nodes[ComponentClass.slot][component] = component
        end
    end
    
    return component
end

function Entity:getComponent(component_type)
    local ComponentClass = coreman.gewComponentClass(component_type)
    
    if ComponentClass.allow_multiple then
        error("Use Entity:getComponents(type) for components types that can be plural")
    end
    
    if not self.components[component_type] or #self.components[component_type] == 0 then
        return nil
    end
    
    return self.components[component_type][1]
end


function Entity:getComponents(component_type)
    return self.components[component_type]
end

function Entity:removeComponent(component)
    if not self.components[component.type][component] then
        error("The component requested for removal does not belong to this entity")
    end
    
    self.components[component.type][component] = nil
    
    if component.slot then
        if component.allow_multiple then
            self[component.slot][component] = nil
        else
            self[component.slot] = nil
        end
        
        if component.collect then
            self.scene.nodes[component.slot][component] = nil
        end
    end
    
    component:Destroy()
end

return Entity