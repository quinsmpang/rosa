local rosa = require("__rosa")

local ResourceReference = rosa.class()

function ResourceReference:__init(resource)
    self.resource = resource
    self.modified = true
end

return ResourceReference