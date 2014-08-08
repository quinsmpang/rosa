class = require("lib.30log")

require(rosa.prefix .. "Entity")

Scene = class()

function Scene:__init()
    -- Entities contained in this scene
    self.entities = {}
    
    -- Systems operating on this scene
    self.systems = {}
    
    -- System hooks
    self.hooks = {
        draw = {},
        update = {},
        
        keypressed = {},
        keyreleased = {},
        
        mousepressed = {},
        mousereleased = {},
    }
    
    -- Collections for components that need collecting
    self.nodes = {}
end

function Scene:addSystem(system_name)
    -- TODO: Error out on occupied slots, or destroy the previous system
    local system = coreman.newSystem(system_name, self)
    self.systems[system_name] = system
    
    self[system.slot] = system
    
    for _, hook in ipairs(system.hooks) do
        self.hooks[hook][system] = system
    end
end

function Scene:removeSystem(system_name)
    if self.systems[system_name] then return end
    
    local system = self.systems[system_name]
    
    self.systems[system_name] = nil
    self[system.slot] = nil
    
    for _, hook in ipairs(system.hooks) do
        self.hooks[hook][system] = nil
    end
end

function Scene:newEntity()
    local entity = Entity(self)
    
    self.entities[entity] = entity
    
    return entity
end

function Scene:removeEntity(entity)
    if self.entities[entity] == nil then return end
    
    self.entities[entity] = nil
    
    entity:Destroy()
end

function Scene:draw(camera)
    if not self.render_system then return end
    
    if camera ~= nil then camera:set() end
    
    self.render_system:draw()
    
    if camera ~= nil then camera:unset() end
end

function Scene:update(dt)
    for _, system in pairs(self.hooks.update) do
        system:update(dt)
    end
end