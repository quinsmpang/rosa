local RenderSystem = rosa.types.System:extends()

RenderSystem.slot = "render_system"
RenderSystem.type = "RenderSystem"

function RenderSystem:draw()
    if not self.scene.nodes.drawable then return end
    
    for _, component in pairs(self.scene.nodes.drawable) do
        if component._drawable == nil or component.drawable.modified then
            component._drawable = component.drawable.resource.resource
            component.drawable.modified = false
        end
        
        local x, y, r, sx, sy = 0, 0, 0, 1, 1
    
        if component.entity.transform then
            x, y, r, sx, sy = component.entity.transform:getTransform()
        end
        
        if component.quad ~= nil then
            love.graphics.draw(component._drawable, component.quad, x, y, r, sx, sy)
        else
            love.graphics.draw(component._drawable, x, y, r, sx, sy)
        end
    end
end

rosa.coreman.registerSystem(RenderSystem)

return RenderSystem