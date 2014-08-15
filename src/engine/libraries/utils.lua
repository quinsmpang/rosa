local utils = {}

-- Originates from the LoveFrames project, Creative Commons Attribution 3.0 Unported licensed, modified
function utils.getDirectoryFiles(directory, recurse, _result_table)
	local result_table = _result_table or {}
    recurse = recurse or false
    
	local subdirectories = {}
	local files = love.filesystem.getDirectoryItems(directory)
	
	for _, filename in ipairs(files) do
		local isdir = love.filesystem.isDirectory(directory.. "/" ..filename)
		if isdir == true and recurse == true then
			table.insert(subdirectories, directory.. "/" .. filename)
		else
			local parts = utils.splitString(filename, "%.")
            local name = table.concat(parts, "", 1, #parts-1)
            
			table.insert(result_table, {
				path = directory, 
				fullpath = directory.. "/" ..filename, 
				requirepath = directory:gsub("/", ".") .. "." ..name,
				filename = table.concat(parts),
                name = name,
				extension = parts[#parts],
                debug = parts
			})
		end
	end
	
	if #subdirectories > 0 then
		for _, filename in ipairs(subdirectories) do
			utils.getDirectoryContents(filename, recurse, result_table)
		end
	end
	
	return result_table
end

function utils.splitString(text, separator)
    local part = ""
    local result = {}
    
    if not text:find(separator) then
        return {text}
    end
    
    while true do
        part, text = text:match("(.-)" .. separator .. "(.+)")
        
        if text:find(separator) then
            table.insert(result, part)
        else
            table.insert(result, part)
            table.insert(result, text)
            break
        end
    end
    
    return result
end

function utils.random_choice(table_or_str)
    local index = math.random(1, #table_or_str)
    if type(table_or_str) == "table" then
        return table_or_str[index]
    elseif type(table_or_str) == "string" then
        return table_or_str:sub(index, index)
    end
end

function utils.randomID(length, spec)
    spec = spec or "base64"
    local charset = nil
    local result = ""
    
    if spec == "base64" then
        charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    elseif spec == "digits" then
        charset = "0123456789"
    elseif spec == "letters" then
        charset = "abcdefghijklmnopqrstuvwxyz"
    end
    
    for i=1, length do
        result = result .. utils.random_choice(charset)
    end
    
    return result
end

return utils