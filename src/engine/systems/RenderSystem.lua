local rosa = require("__rosa")

local defaultdict = rosa.datatypes.defaultdict

local RenderSystem = rosa.types.System:extends()

RenderSystem.__name = "RenderSystem"
RenderSystem.type = "render_system"

function RenderSystem:__init(scene, enabled)
    RenderSystem.super.__init(self, scene, enabled)
    
    self._layers = {""}
    self._reverse_layers = {[""] = 1}
end

RenderSystem:property("layers",
    function(self) return self._layers end, 
    function(self, v)
        --print(rosa.utils.str(v))
        self._layers = v; table.insert(v, "")
        self._reverse_layers = {}
        for i, layer in ipairs(self._layers) do
            self._reverse_layers[layer] = i
        end
    end
)

RenderSystem:property("reverse_layers",
    function(self) return self._reverse_layers end
)

function RenderSystem:draw()
    if not self.scene.nodes.drawable then return end
    local to_draw = defaultdict(function() return defaultdict(function() return {} end) end)
    
    for _, drawable in pairs(self.scene.nodes.drawable) do
        -- TODO: Visibility checks.
        -- TODO: Add spatial hashing (maybe?)
        local layer = (self.reverse_layers[drawable.layer] ~= nil) and to_draw[drawable.layer] or ""
        table.insert(to_draw[drawable.layer], {drawable.layer_order, drawable})
    end
    
    for i, layer_name in ipairs(self.layers) do
        local layer = to_draw[layer_name] or {}
        table.sort(layer, function(a, b) return a[1] < b[1] end)
        
        for i, v in ipairs(layer) do
            drawable = v[2]
            if drawable.__name == "ImageDrawable" then
                self:drawImageDrawable(drawable)
            elseif drawable.__name == "BatchDrawable" then
                self:drawBatchDrawable(drawable)
            elseif drawable.__name == "MeshDrawable" then
                self:drawMeshDrawable(drawable)
            elseif drawable.type == "custom_image" then
                drawable:draw()
            end
        end
    end
end

function RenderSystem:drawImageDrawable(drawable)
    if drawable._image == nil or drawable.image.modified then
        drawable._image = drawable.image.resource.data
        drawable.image.modified = false
    end
        
    local x, y, r, sx, sy = 0, 0, 0, 1, 1

    if drawable.entity.transform then
        x, y, r, sx, sy = drawable.entity.transform:getTransform()
    end
    
    x = x - (math.cos(r) * drawable.origin_x - math.sin(r) * drawable.origin_y)
    y = y - (math.sin(r) * drawable.origin_x + math.cos(r) * drawable.origin_y)
    
    if self.quad ~= nil then
        love.graphics.draw(drawable._image, self.quad, x, y, r, sx, sy)
    else
        love.graphics.draw(drawable._image, x, y, r, sx, sy)
    end
end

rosa.coreman.registerSystem(RenderSystem)

return RenderSystem