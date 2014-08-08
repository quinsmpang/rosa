class = require("lib.30log")

require(rosa.prefix .. "Entity")

Scene = class()

function Scene:__init()
    -- Entities contained in this scene
    self.entities = {}
    
    -- Collections for components that need collecting
    self.nodes = {}
end

function Scene:newEntity()
    local entity = Entity(self)
    
    self.entities[entity] = entity
    
    return entity
end

--function Scene:addEntity(entity)
    --self.entities[entity] = entity
    --
    --for _, component in pairs(entity.components) do
        --if component.collect then
            --self.nodes[component.type] = self.nodes[component.type] or {}
            --self.nodes[component.type][component] = component
        --end
    --end
--end

function Scene:removeEntity(entity)
    if self.entities[entity] == nil then return end
    
    self.entities[entity] = nil
    
    entity:Destroy()
end

-- TODO: Use renderman
function Scene:draw()
    rosa.renderman.draw(self)
    --for _, object in pairs(self.entities) do
        --object:draw()
    --end
end

function Scene:update(dt)
    -- Update physics
    --for _, object in pairs(self.entities) do
        --
    --end
end