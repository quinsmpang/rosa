local rosa = require("__rosa")

local RenderSystem = rosa.types.System:extends()

RenderSystem.slot = "render_system"
RenderSystem.type = "RenderSystem"

function RenderSystem:__init(scene, enabled)
    self.super.__init(self, scene, enabled)
end

function RenderSystem:draw()
    if not self.scene.nodes.drawable then return end
    
    for _, drawable in pairs(self.scene.nodes.drawable) do
        drawable:draw()
    end
end

rosa.coreman.registerSystem(RenderSystem)

return RenderSystem