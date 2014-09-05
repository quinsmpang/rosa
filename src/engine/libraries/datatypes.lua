local datatypes = {}

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

function datatypes.reqtable(prefix, suffix, original_table)
    if string.sub(prefix, string.len(prefix)) ~= "." then
        prefix = prefix .. "."
    end
    suffix = suffix or ""
    if string.sub(suffix, 0) ~= "." and suffix ~= "" then
        suffix = "." .. suffix
    end
    
    return setmetatable(original_table or {}, {
        __index = function(t, key)
            t[key] = require(prefix .. key .. suffix)
            return t[key]
        end
    })
end

return datatypes