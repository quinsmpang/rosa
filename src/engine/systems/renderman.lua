require(rosa.prefix .. "Scene")

renderman = {}

function renderman.draw(scene)
    if not scene.nodes.drawable then return end
    
    for _, drawable in pairs(scene.nodes.drawable) do
        drawable:draw()
    end
end

return renderman