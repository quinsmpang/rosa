class = require("lib.30log")

Resource = class()

function Resource:__init(source)
    self.source = source
end

function Resource.create()
    return Resource()
end