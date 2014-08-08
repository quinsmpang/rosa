require(rosa.prefix .. "components.Component")

componentman = {}
componentman.types = {}

function componentman.register(component_class)
    componentman.types[component_class.type] = component_class
end

function componentman.createComponent(component_class, entity)
    return componentman.types[component_class](entity)
end

return componentman