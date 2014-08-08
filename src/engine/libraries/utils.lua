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
			local parts = loveframes.util.SplitString(filename, "([.])")
            local name = table.concat(parts, "", 1, #parts-1)
            
			table.insert(result_table, {
				path = directory, 
				fullpath = directory.. "/" ..filename, 
				requirepath = directory:gsub("/", ".") .. "." ..name,
				filename = table.concat(parts),
                name = name,
				extension = parts[#parts]
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

return utils