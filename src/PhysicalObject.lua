class = require("lib.30log")

require "src.love_utils"

PhysicalObject = class()

function PhysicalObject:__init(x, y, world)
    self._physics_world = worlds
    self.x = x
    self.y = y
    
    self.bounds = nil
end

-- Returns position rounded to a 1,1 grid
function PhysicalObject:getPosR()
    return math.floor(self.x), math.floor(self.y)
end

function PhysicalObject:checkCollision(other)
    return false
end

function PhysicalObject:draw(debug)
    return nil
end