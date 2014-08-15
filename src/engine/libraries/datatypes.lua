datatypes = {}

function datatypes.defaultdict(default_value_factory)
  local object = {}
  local metatable = {}
  metatable.__index = function(object, key)
    local value = rawget(object, key)
    return value or default_value_factory()
  end
  setmetatable(object, metatable)
  return object
end

function datatypes.weakref(target)
    return setmetatable({ref=target}, {__mode = "v"})
end

function datatypes.weaktable()
    return setmetatable({}, {__mode = "v"})
end

return datatypes