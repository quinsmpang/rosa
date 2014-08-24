rosa = {}
rosa.types = {}

rosa.resources = {}
rosa.components = {}
rosa.systems = {}

rosa.prefix = (...):match("(.-)[^%.]+$") .. "engine."
rosa.directory = rosa.prefix:gsub("%.", "/")

local dir = rosa.prefix

-- External libraries
rosa.class = require(dir .. "libraries.30log")
rosa.tween = require(dir .. "libraries.flux.flux")

require(dir .. "libraries.loveframes")
rosa.frames = loveframes
--loveframes = nil

-- Internal libraries
rosa.utils = require(dir .. "libraries.utils")
rosa.datatypes = require(dir .. "libraries.datatypes")

-- Require the base classes
rosa.types.Component = require(dir .. "components.Component")
rosa.types.Behavior = require(dir .. "components.Behavior")
rosa.types.Entity = require(dir .. "Entity")
rosa.types.Scene = require(dir .. "Scene")
rosa.types.State = require(dir .. "State")
rosa.types.ResourceReference = require(dir .. "resman.ResourceReference")
rosa.types.Resource = require(dir .. "resman.Resource")
rosa.types.Prefab = require(dir .. "Prefab")
rosa.types.System = require(dir .. "systems.System")

-- Require the systems
rosa.keyboard = require(dir .. "core.keyboard")
rosa.mouse    = require(dir .. "core.mouse")
rosa.console  = require(dir .. "core.console")

-- And the managers
rosa.stateman = require(dir .. "core.stateman")
rosa.sceneman = require(dir .. "core.sceneman")
rosa.coreman  = require(dir .. "core.coreman")

-- Resource manager
rosa.resman = require(dir .. "resman.resman")

-- Require the systems
local files = rosa.utils.getDirectoryFiles(rosa.directory .. "systems", false)
for k, v in pairs(files) do
    if v.extension == "lua" then
        local SystemClass = require(v.requirepath)
        rosa.systems[SystemClass.type] = SystemClass
    end
end

-- Require the individual components
local files = rosa.utils.getDirectoryFiles(rosa.directory .. "components", false)
for k, v in pairs(files) do
    if v.extension == "lua" then
        local ComponentClass = require(v.requirepath)
        rosa.components[ComponentClass.type] = ComponentClass
    end
end

-- Require the resource types
local files = rosa.utils.getDirectoryFiles(rosa.directory .. "resources", false)
for k, v in pairs(files) do
    if v.extension == "lua" then
        local ResourceClass = require(v.requirepath)
        rosa.resources[ResourceClass.class_name] = ResourceClass
    end
end

return rosa