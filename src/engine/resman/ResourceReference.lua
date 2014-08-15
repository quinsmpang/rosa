class = require("lib.30log")

ResourceReference = class()

function ResourceReference:__init(resource)
    self.resource = resource
    self.modified = true
end

resref = ResourceReference