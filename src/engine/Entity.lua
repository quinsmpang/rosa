class = require("lib.30log")

Entity = class()

function Entity:__init(scene)
    self.scene = scene
    self.components = {}
end

function Entity:destroy()
    for name, component in self.pairs(self.components) do
        self:removeComponent(name)
    end
end

function Entity:addComponent(component_name)
    local component = componentman.createComponent(component_name, self)
    
    self.components[component_name] = component
    self[component.slot] = component
    
    if component.collect then
        self.scene.nodes[component.slot] = self.scene.nodes[component.slot] or {}
        self.scene.nodes[component.slot][component] = component
    end
end

function Entity:removeComponent(component_name)
    local component = self.components[component_name]
    
    self[component.slot] = nil
    self.components[component_name] = nil
    
    if component.collect then
        self.scene.nodes[component.slot][component] = nil
    end
    
    component:destroy()
end