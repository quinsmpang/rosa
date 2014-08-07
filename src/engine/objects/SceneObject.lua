class = require("lib.30log")

SceneObject = class()

function SceneObject:__init(x, y)
    self.x = x or 0
    self.y = y or 0
    
    self.vel_x = 0
    self.vel_y = 0
end

function SceneObject:draw() end
