local rosa = require("__rosa")

local Entity = rosa.class()

function Entity:__init(scene, parent) -- parent can be nil
    self.scene = scene
    self.prefab = nil
    
    if parent ~= nil then
        parent.children[self] = self
    end
        
    self.parent = parent -- nil or entity
    self.children = {} -- entity --> true/tag or tag --> entity
    
    self.components = {} -- table<name:string, table<component>>
end

function Entity:addChild(entity)
    if not rosa.types.Entity.is(entity, rosa.types.Entity) then
        error("Given entity argument is not an actual Entity instance")
    end
    if self.children[entity] ~= nil then
        return -- Should this error?
    end
    
    entity:setParent(self)
end

function Entity:removeChild(entity)
    if self.children[entity] == nil then
        error("Given entity is not a child of this entity")
    end
    entity:setParent(nil)
end

function Entity:setParent(entity)
    if entity == self.parent then return end
    
    if self.parent ~= nil then
        local tag = self.parent.children[self]
        self.parent.children[tag] = nil
        self.parent.children[self] = nil
    end
    
    self.parent = entity
    
    self.parent.children[self] = true
end

function Entity:tagChild(entity, tag)
    if self.children[entity] == nil then
        error("Given entity is not a child of this entity")
    end
    self.children[tag] = entity
    self.children[entity] = tag
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
    
    if ComponentClass.type then
        if ComponentClass.allow_multiple then
            self[ComponentClass.type] = self[ComponentClass.type] or {}
            self[ComponentClass.type][component] = component
        else
            self[ComponentClass.type] = component
        end
        
        if ComponentClass.collect then
            self.scene.nodes[ComponentClass.type] = self.scene.nodes[ComponentClass.type] or {}
            self.scene.nodes[ComponentClass.type][component] = component
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
    
    if component.type then
        if component.allow_multiple then
            self[component.type][component] = nil
        else
            self[component.type] = nil
        end
        
        if component.collect then
            self.scene.nodes[component.type][component] = nil
        end
    end
    
    component:Destroy()
end

return Entity