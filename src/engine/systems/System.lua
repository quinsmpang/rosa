class = require("lib.30log")

System = class()
System.type = "System"
System.hooks = {}

function System:__init(scene, enabled)
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