require(rosa.prefix .. "components.Component")

coreman = {}
coreman.component_types = {}
coreman.system_types = {}

function coreman.registerComponent(component_class)
    coreman.component_types[component_class.type] = component_class
end

function coreman.newComponent(component_class, entity)
    print("1. ", component_class, entity)
    return coreman.component_types[component_class](entity)
end

function coreman.registerSystem(system_class)
    coreman.system_types[system_class.type] = system_class
end

function coreman.newSystem(system_class, scene)
    return coreman.system_types[system_class](scene)
end

return coreman