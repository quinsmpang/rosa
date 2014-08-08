require(rosa.prefix .. "systems.System")

RenderSystem = System:extends()

RenderSystem.slot = "render_system"
RenderSystem.type = "RenderSystem"

function RenderSystem:draw()
    if not self.scene.nodes.drawable then return end
    
    for _, drawable in pairs(self.scene.nodes.drawable) do
        drawable:draw()
    end
end

coreman.registerSystem(RenderSystem)