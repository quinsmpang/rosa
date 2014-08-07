class = require("lib.30log")

require "src.engine.objects.SceneObject"

Scene = class()

function Scene:__init()
    self.objects = {}
end

function Scene:addObject(scene_object, x, y)
    self.objects[scene_object] = scene_object
    if x and y then 
        scene_object:setPos(x, y)
    end
end


function Scene:draw()
    for _, object in pairs(self.objects) do
        object:draw()
    end
end

function Scene:update(dt)
    -- Update physics
    --for _, object in pairs(self.objects) do
        --
    --end
end