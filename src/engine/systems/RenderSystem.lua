local rosa = require("__rosa")

local RenderSystem = rosa.types.System:extends()

RenderSystem.slot = "render_system"
RenderSystem.type = "RenderSystem"

function RenderSystem:draw()
    if not self.scene.nodes.drawable then return end
    
    for _, component in pairs(self.scene.nodes.drawable) do
        component:draw()
    end
end

rosa.coreman.registerSystem(RenderSystem)

return RenderSystem