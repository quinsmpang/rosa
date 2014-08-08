rosa = {}

rosa.prefix = (...):match("(.-)[^%.]+$") .. "engine."
rosa.directory = rosa.prefix:gsub("%.", "/")

local dir = rosa.prefix

rosa.utils = require(dir .. "libraries.utils")

-- Require the base classes
require(dir .. "components.Component")
require(dir .. "Entity")
require(dir .. "Scene")
require(dir .. "State")

-- Require the systems
rosa.keyboard = require(dir .. "systems.keyboard")
rosa.mouse    = require(dir .. "systems.mouse")
rosa.console  = require(dir .. "systems.console")

-- And the managers
rosa.stateman = require(dir .. "systems.stateman")
rosa.sceneman = require(dir .. "systems.sceneman")
rosa.componentman = require(dir .. "systems.componentman")
rosa.renderman = require(dir .. "systems.renderman")

-- Require the individual components
local files = rosa.utils.getDirectoryFiles(rosa.directory .. "components", false)
for k, v in pairs(files) do
    if v.extension == "lua" then
        require(v.requirepath)
    end
end

