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
    local SystemClass = coreman.getSystemClass(system_name)
    
    if self.systems[system_name] ~= nil then
        error("This Scene instance already has a '" .. system_name .. "' system")
    end
    
    local system = SystemClass(self)
    
    self.systems[system_name] = system
    
    if system.slot then
        self[system.slot] = system
    end
    
    for _, hook in ipairs(system.hooks) do
        self.hooks[hook][system] = system
    end
end

-- allowed to return nil
function Scene:getSystem(system_name)
    return self.systems[system_name]
end

function Scene:removeSystem(system)
    if not self.systems[system.name] then
        error("Given system does not belong to this Scene")
    end
    
    self.systems[system.name] = nil
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

function Scene:instantiatePrefab(prefab_name)
    return coreman.getPrefab(prefab_name):instantiate(self)
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