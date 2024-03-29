local rosa = require("__rosa")

local Tilemap = rosa.components.Component:extends()

-- WIP

Tilemap.__name = "Tilemap"
Tilemap.type = "tilemap"
Tilemap.collect = false

require(rosa.prefix .. "components.internal.TilemapChunk")

function Tilemap:__init(x, y, chunk_width, chunk_height, limits)
    SceneObject.__init(self, x, y)
    
    -- Chunk data
    self._chunks = {}
    self.chunk_width = chunk_width or 16
    self.chunk_height = chunk_height or chunk_width or 16
    
    -- Tileset data
    self.tileset = nil
    
    self.limits = limits -- Can be nil
end

function Tilemap:getChunk(chunk_x, chunk_y)
    local key = chunk_x .. "," .. chunk_y
    if not self._chunks[key] then
        print("Generating chunk " .. key)
        self._chunks[key] = TilemapChunk(self, chunk_x, chunk_y, self.chunk_width, self.chunk_height)
    end
    
    return self._chunks[key]
end

function Tilemap:getChunkAt(x, y)
    return self:getChunk(math.floor(x / self.chunk_width) + 1, math.floor(y / self.chunk_height) + 1)
end

function Tilemap:setTile(x, y, tile)
    local chunk = self:getChunkAt(x, y)
    chunk:setTile( x % self.chunk_width + 1, y % self.chunk_height + 1, tile)
end

function Tilemap:getTile(x, y)
    local chunk = self:getChunkAt(x, y)
    chunk:getTile( x % self.chunk_width + 1, y % self.chunk_height + 1)
end

function Tilemap:setTileset(spritesheet)
    self.tileset = spritesheet
    
    for _, chunk in pairs(self._chunks) do
        chunk:setTileset(spritesheet)
    end
end

function Tilemap:draw()
    for _, chunk in pairs(self._chunks) do
        chunk:draw()
    end
end

rosa.coreman.registerComponent(Tilemap)

return Tilemap