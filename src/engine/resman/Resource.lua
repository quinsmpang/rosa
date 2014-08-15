class = require("lib.30log")

require(rosa.prefix .. "resman.ResourceReference")

Blah = class()

function Blah:__init()
    return 1
end

Resource = class()

Resource.type = "resource"
Resource.extensions = {}

-- Resource() - create new empty resource
-- Resource({...}) - create new resource with params (resource-dependent)
-- Resource(filename) - load resource from a file
-- Resource(source, data) - load resource from string data
function Resource:__init(...)
    local args = {...}
    
    self.source = nil
    self.source_last_modified = nil
    self.last_modified = nil
    self.resource = nil
    self.references = rosa.datatypes.weaktable()
    --self.references = rosa.utils.defaultdict(function() return ResourceReference(self) end)
    
    if #args == 0 then
        self:createEmpty()
    elseif #args == 1 and type(args[1]) == "table" then
        self:create(args[1])
    elseif #args == 1 and type(args[1]) == "string" then
        self:fromFile(args[1])
    elseif #args == 2 and type(args[1]) == "string" and type(args[2]) == "string" then
        self:fromData(args[1], args[2])
    else
        error("Invalid arguments")
    end
    
    resman.registerResource(self)
end

function Resource:getReference()
    local ref = ResourceReference(self)
    self.references[ref] = ref
    
    return ref
end

function Resource:createEmpty()
    self.source = "id:" .. rosa.resman.getNewID()
    self.last_modified = love.timer.getTime()
    self.source_last_modified = 0
end

function Resource:create(data)
    self.source = "id:" .. rosa.resman.getNewID()
    self.last_modified = love.timer.getTime()
    self.source_last_modified = 0
end

function Resource:fromFile(filename)
    self.source = "file:" .. filename
    self.last_modified = love.timer.getTime()
    self.source_last_modified = love.filesystem.getLastModified(filename)
end

function Resource:fromData(source, data)
    self.source = source
    self.last_modified = love.timer.getTime()
    self.source_last_modified = 0
end

function Resource:reload()
    print("Reloading '" .. self.source .. "'")
    local protocol, path = self.source:match("([^:]*):(.+)")
    if protocol == "id" then
        return -- It's impossible to reload manually created resources
    elseif protocol == "file" then
        self:fromFile(path)
    else
        error("Only file and id protocols are supported")
        -- TODO: Default to resman.reload or something
    end
    
    for _, ref in pairs(self.references) do
        ref.modified = true
    end
end