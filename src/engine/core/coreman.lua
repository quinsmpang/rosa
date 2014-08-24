local coreman = {}
coreman.component_types = {}
coreman.system_types = {}
coreman.prefabs = {}

function coreman.registerComponent(component_type)
    if coreman.component_types[component_type] ~= nil then
        error("Component type '" .. tostring(component_type) .. "' has already been registered")
    end
    
    coreman.component_types[component_type.type] = component_type
end

function coreman.getComponentClass(component_type)
    if coreman.component_types[component_type] == nil then
        error("Component type '" .. tostring(component_type) .. "' does not exist or has not been registered")
    end
    
    return coreman.component_types[component_type]
end

function coreman.registerSystem(system_type)
    if coreman.system_types[system_type] ~= nil then
        error("System type '" .. tostring(system_type) .. "' has already been registered")
    end
    
    coreman.system_types[system_type.type] = system_type
end

function coreman.getSystemClass(system_type)
    if coreman.system_types[system_type] == nil then
        error("System type '" .. tostring(system_type) .. "' does not exist or has not been registered")
    end
    
    return coreman.system_types[system_type]
end

function coreman.registerPrefab(prefab)
    if coreman.prefabs[prefab.name] ~= nil then
        error("Prefab named '" .. tostring(prefab.name) .. "' already exists")
    end
    
    coreman.prefabs[prefab.name] = prefab
end

function coreman.getPrefab(prefab_name)
    if coreman.prefabs[prefab_name] == nil then
        error("A prefab named '" .. tostring(prefab_name) .. "' does not exist")
    end
    
    return coreman.prefabs[prefab_name]
end

return coreman