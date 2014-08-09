class = require("lib.30log")

System = class()
System.type = "System"
System.hooks = {}

function System:__init(scene, enabled)
    if not Scene.is(scene, Scene) then
        error("Given scene argument is not an actual Scene instance")
    end
    
    self.scene = scene
    
    self.enabled = enabled or true
end

function System:enable()
    self.enabled = true
end

function System:disable()
    self.enabled = false
end

function System:destroy() end