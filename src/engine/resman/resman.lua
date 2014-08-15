resman = {}

resman.update_delay = 1.0
resman._until_update = resman.update_delay

resman.file_resources = {}
resman.id_resources = {}

resman.filetype_map = {}

resman.resources = {}

function resman.getResource(path_specifier)
    if resman.resources[path_specifier] ~= nil then
        return resman.resources[path_specifier]:getReference()
    end
    
    local protocol, path = path_specifier:match("([^:]*):(.+)")
    local extension = path:match("[^%.]-%.(.+)") or ""
    
    if protocol == "file" then
        local ResourceClass = resman.filetype_map[extension]
        if ResourceClass == nil then
            error("The '" .. extension .. "'extension isn't mapped to a resource type")
        end
        
        return ResourceClass(path):getReference()
    elseif protocol == "id" then
        error("Requested dynamic resource does not exist. Create it first.")
    end
end

function resman.update(dt)
    resman._until_update = resman._until_update - dt
    
    if resman._until_update <= 0.0 then
        for path, resource in pairs(resman.file_resources) do
            if love.filesystem.getLastModified(path) > resource.source_last_modified then
                resource:reload()
            end
        end
        
        resman._until_update = resman.update_delay
    end
end

function resman.getNewID()
    local new_id = nil
    while (new_id == nil) or (resman.id_resources[new_id] ~= nil) do
        new_id = rosa.utils.randomID(8, "base64")
    end
    
    return new_id
end

function resman.registerResource(resource)
    resman.resources[resource.source] = resource
    
    local protocol, path = resource.source:match("([^:]*):(.+)")
    
    if protocol == "id" then
        resman.id_resources[path] = resource
    elseif protocol == "file" then
        resman.file_resources[path] = resource
    else
        error("Invalid protocol: '" .. tostring(protocol) .."'")
    end
end

--function resman.buildTree(path_parts, resource)
    --
--end

function resman.registerResourceClass(resource_class)
    for _, ext in ipairs(resource_class.extensions) do
        resman.filetype_map[ext] = resource_class
    end
end

return resman