
--Robust pretty-printing dir() function
function dir(obj, pretty_mode, expand_tables, _indent_level)
    pretty_mode = pretty_mode or false
    expand_tables = expand_tables or false

    --Handle indentation levels
    local indent_level = _indent_level or 1
    local indent = ""
    local prev_indent = ""

    for i=1,indent_level do
        indent = indent .. "    "
    end

    for i=1,indent_level-1 do
        prev_indent = prev_indent .. "    "
    end
    --Done

    local result = "{"

    if pretty_mode then result = result .. "\n"; end

    local number_mode = false
    local number_mode_key = 1

    for k, v in pairs(obj) do
        if k == number_mode_key then
            number_mode = true
            number_mode_key = number_mode_key + 1
        else
            number_mode = false
            number_mode_key = nil
        end

        if pretty_mode then
            result = result .. indent
        end

        if not number_mode then
            result = result .. tostring(k) .. " = "
        end

        if type(v) == "table" then
            if v == obj then
                result = result .. "self"
            elseif expand_tables then
                result = result .. dir(v, pretty_mode, expand_tables, indent_level + 1)
            else
                result = result .. tostring(v)
            end
        else
            result = result .. str(v)
        end

        if pretty_mode then
            result = result .. ", \n"
        else
            result = result .. ", "
        end
    end
    result = result .. prev_indent .. "}"

    return result
end

function str(obj, pretty_mode)
    local obj_type = type(obj)
    if obj_type == "number" then
        return "" .. obj
    elseif obj_type == "string" then
        return '"' .. obj .. '"'
    elseif obj_type == "function" then
        return tostring(obj)
    elseif obj_type == "table" then
        return dir(obj, pretty_mode)
    elseif obj_type == "nil" then
        return "nil"
    elseif obj_type == "boolean" then
        return tostring(obj)
    else
        return tostring(obj) or "userdata/unknown"
    end
end

function debugindex(table, key)
    --print(dir(Tilemap))
    print(dir(table))
    print(dir(getmetatable(table)))
end

-- Handly string utils
function string.startswith(str, start)
   return string.sub(str,1,string.len(start)) == start
end

function string.endswith(str, _end)
   return _end=='' or string.sub(str,-string.len(_end)) == _end
end

function getDistance(x1, y1, x2, y2)
    return math.sqrt(
        math.pow(x1 - x2, 2) +
        math.pow(y1 - y2, 2)
    )
end

function getAngle(x1, y1, x2, y2)
    return math.atan2( x1 - x2,  y1 - y2 )
end

function require_leak(module_to_require)
    local before = {}
    local leaked = {}
    local return_value = nil
    
    --for k, v in pairs(getfenv()) do
    for k, v in pairs(_G) do
        before[k] = v
    end
    
    return_value = require(module_to_require)
    
    for k, v in pairs(_G) do
        if before[k] == nil then
            table.insert(leaked, k)
        end
    end
    
    return return_value, leaked
end