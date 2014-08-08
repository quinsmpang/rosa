rosa = {}

rosa.prefix = (...):match("(.-)[^%.]+$") .. "engine."
rosa.directory = rosa.prefix:gsub("%.", "/")

local dir = rosa.prefix

rosa.utils = require(dir .. "libraries.utils")

-- Require the base classes
require(dir .. "components.Component")
require(dir .. "components.Behavior")
require(dir .. "Entity")
require(dir .. "Scene")
require(dir .. "State")
require(dir .. "systems.System")

-- Require the systems
rosa.keyboard = require(dir .. "core.keyboard")
rosa.mouse    = require(dir .. "core.mouse")
rosa.console  = require(dir .. "core.console")

-- And the managers
rosa.stateman = require(dir .. "core.stateman")
rosa.sceneman = require(dir .. "core.sceneman")
rosa.coreman  = require(dir .. "core.coreman")

-- Require the systems
local files = rosa.utils.getDirectoryFiles(rosa.directory .. "systems", false)
for k, v in pairs(files) do
    if v.extension == "lua" then
        require(v.requirepath)
    end
end

-- Require the individual components
local files = rosa.utils.getDirectoryFiles(rosa.directory .. "components", false)
for k, v in pairs(files) do
    if v.extension == "lua" then
        require(v.requirepath)
    end
end
