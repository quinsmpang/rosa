require "src.utils"

json = require "lib.dkjson"

ResourceManager = {}
setmetatable(ResourceManager,{
    __index = ResourceManager;
});

function ResourceManager:new()
    --Layout for all_data, data_by_module, and data_by_game is
    -- this.*[resource_type][resource_name]
    return setmetatable(
        {
            modules_loaded = {},
            games_loaded = {},
            resources = {},
            all_data = {},
            modules = {},
            games = {},
            __indent = 0,
        },
        getmetatable(self)
    ); --create a new table and give it the metatable of ResourceManager
end

function ResourceManager:_changeIndent(n)
    self.__indent = math.max(0, self.__indent + n)
end

msg = {
    NORMAL = 0,
    WARNING = 1,
    ERROR = 2
}

function ResourceManager:_log(text, msg_type)
    local msg_type = msg_type or msg.NORMAL
    local line = ""

    for i=1,self.__indent do
        line = "  " .. line
    end

    if msg_type == msg.NORMAL then
        line = line .. text
    elseif msg_type == msg.WARNING then
        line = line .. "[WARNING] " .. text
    elseif msg_type == msg.NORMAL then
        line = line .. "[ERROR] " .. text
    end

    print(line)
end

function ResourceManager:loadData()
    for i, filename in love.filesystem.getDirectoryItems("data") do
        local filepath = "data/" .. filename
        if love.filesystem.isFile(filepath) then
            if string.endswith(filename, ".module") then
                local error_msg = filepath .. " is a module file. Loading modules from files not supported yet"
                self:_log(error_msg, msg.ERROR)
                error(error_msg)
            end
        elseif love.filesystem.isDirectory(filepath) then
            if string.endswith(filename, ".module") then
                self:loadModule(string.sub(str, 1, -8))
            end
        else
            self:_log(filepath .. " not a file or a directory, ignoring", msg.WARNING)
        end
    end
end

function ResourceManager:loadModule(module_name)
    self:_log("Loading module " .. module_name .. ":")
    self:_changeIndent(1)

    self.modules_loaded[module_name] = module_name

    self:includeFile(module_name, "index.json", true)

    self:_changeIndent(-1)
    self:_log("Succesfully loaded module " .. module_name .. ";")
end

function ResourceManager:_absolutePath(module_name, resource_path)
    local include_path = ""

    if string.startswith(resource_path, "/") then
        --Absolute include, loads files from other modules as well
        include_path = "data" .. resource_path
    else
        --Relative include from inside the current module
        include_path = "data/" .. module_name .. ".module/" .. resource_path
    end

    return include_path
end

function ResourceManager:loadImage(module_name, absPath)
    self:_log("resource:image:" .. absPath)
    self.resources[absPath] = love.graphics.newImage(absPath)
end

ResourceManager._resourceLoaders = {
    [".png"] = ResourceManager.loadImage,
    [".jpg"] = ResourceManager.loadImage,
    [".jpeg"] = ResourceManager.loadImage
}

function ResourceManager:scanAndLoadResources(module_name, data)
    for field, value in pairs(data) do
        if type(value) == "string" then
            local _, ext = value:match("(.+)(%..+)")
            local loader = self._resourceLoaders[ext]
            if loader then
                local absPath = self:_absolutePath(module_name, value)
                
                if self.resources[absPath] == nil then
                    loader(self, module_name, absPath)
                end
                data[field] = absPath
            end
        elseif type(value) == "table" then
           self:scanAndLoadResources(module_name, value)
        end
    end
end

function ResourceManager:loadDataEntry(module_name, data, path)
    local name = data["name"]
    local data_type = data["type"]
    
    self:_log(data_type .. ":" .. name)

    data["_module"] = module_name
    data["_source"] = path

    -- If this resource type does not exist, create it
    if self.all_data[data_type] == nil then
        self.all_data[data_type] = {}
    end

    -- If this resource type does not exist, create it
    if self.modules[module_name]["_data"][data_type] == nil then
        self.modules[module_name]["_data"][data_type] = {}
    end
    
    -- Add the data entry to the indexes
    self.all_data[data_type][name] = data
    self.modules[module_name]["_data"][data_type][name] = data
    
    -- Load any resources this data entry might be referencing
    self:scanAndLoadResources(module_name, data)
end

function ResourceManager:includeFile(module_name, file_path, is_module)
    local is_module = is_module or false
    local path = "data/" .. module_name .. ".module/" .. file_path
    self:_log("Including file " .. path)
    self:_changeIndent(1)

    local file_contents = love.filesystem.read(path)
    if file_contents == nil then
        local message = file_path .. " doesn't exist"
        self:_log(message, msg.ERROR)
        error(message)
    end
    local json_data = json.decode(file_contents)
    if json_data == nil then
        local message = file_path .. " is a malformed JSON file and cannot be loaded"
        self:_log(message, msg.ERROR)
        error(message)
    end

    -- Load and store module data, and process dependencies
    if is_module == true then
        if json_data["module_info"] ~= nil then
            local info = json_data["module_info"]

            self.modules[module_name] = info
            self.modules[module_name]["_source"] = path
            self.modules[module_name]["_data"] = {}

            -- Load other modules this module depends on if they're not loaded yet
            if info["requires"] ~= nil then
                for _, dependency in pairs(info["requires"]) do
                    if self.modules_loaded[dependency] == nil then
                        --self:includeFile(module_name, include_path)
                        self:loadModule(dependency)
                    end
                end
            end

            if info["master_module"] == true then
                self:_log("This is a game module")
                self.games[module_name] = self.modules[module_name]
                --Make a copy of dependencies and append self, since it might contain data too
                --NOTE: Copying via {unpack(...)} depends on maximum stack size, which is low in Lua, but high in LuaJIT. Should not be a problem
                local submodules = {unpack(self.games[module_name]["requires"])}
                table.insert(submodules, module_name)
                self.games[module_name]["_submodules"] = submodules
            end
        else
            local message = file_path .. ": Module " .. module_name .. " is not a module"
            self:_log(message, msg.ERROR)
            error(message)
        end
    end

    --Include other files, only ones inside the module
    if json_data["includes"] ~= nil then
        for _, include_path in pairs(json_data["includes"]) do
            self:includeFile(module_name, include_path)
        end
    end

    --Load data entries
    if json_data["data"] ~= nil then
        self:_log("Loading data:")
        self:_changeIndent(1)
        local i=0
        for _, data in pairs(json_data["data"]) do
            self:loadDataEntry(module_name, data, path)
            i = i + 1
        end
        self:_changeIndent(-1)
        self:_log("Loaded " .. i .. " data entries")
    end

    self:_changeIndent(-1)
    self:_log("Include complete")
end

function ResourceManager:getData(data_type, name)
    return self.all_data[data_type][name]
end

function ResourceManager:getResource(path)
    return self.resources[path]
end

-- Iterate through all data loaded
function ResourceManager:iterateData(data_type)
    return pairs(self.all_data.data_type)
end

-- Iterate through all data of a certain type of a module
function ResourceManager:iterateModuleData(module_name, data_type)
    return pairs(self.modules[module_name]._data[data_type])
end

-- Iterate through all data of a certain type of a game
function ResourceManager:iterateGameData(game_module_name, data_type)
    local function iterate_game_data()
        for _, module_name in pairs(self.games[game_module_name]["_submodules"]) do
            for name, data in pairs(self.modules[module_name]._data[data_type]) do
                coroutine.yield(name, data)
            end
        end
    end

    local cr = coroutine.create(iterate_game_data)
    return function()
        local ok, name, data = coroutine.resume(cr)
        if ok ~= true then return nil; end
        return name, data
    end
end