local TilemapChunk = rosa.class()

function TilemapChunk:__init(tilemap, chunk_x, chunk_y, width_in_tiles, height_in_tiles)
    self.parent = tilemap
    
    self.chunk_x = chunk_x
    self.chunk_y = chunk_y
    self.width = width_in_tiles
    self.height = height_in_tiles
    
    self.modified = true
    self.tiles = {}
    for x = 1, self.width do
        table.insert(self.tiles, {})
        for y = 1, self.height do
            table.insert(self.tiles[x], 0)
        end
    end
    
    self._sprite_batch = nil
end

function TilemapChunk:setTileset(spritesheet)
    self._sprite_batch = nil
    self.modified = true
end

function TilemapChunk:regenerateSpriteBatch()
    --print("Request to regenerate sprite batch")
    if self._sprite_batch == nil then
        if self.parent.tileset ~= nil then
            self._sprite_batch = love.graphics.newSpriteBatch(self.parent.tileset.image, self.width * self.height)
        else
            return
        end
    end
    
    self._sprite_batch:clear()
    
    --print("Regenerating the sprite batch")
    
    local tileset = self.parent.tileset
    
    for x = 1, self.width do
        for y = 1, self.height do
            local tile = self.tiles[x][y]
            local tx, ty = (x-1) * tileset.tile_width, (y-1) * tileset.tile_height
            if (tile ~= 0) then
                self._sprite_batch:add(tileset.quads[tile], tx, ty)
            end
        end
    end
    
    self.modified = false
end

function TilemapChunk:setTile(x, y, tile)
    if self.tiles[x][y] ~= tile then
        self.tiles[x][y] = tile
        self.modified = true
    end
    
    return true
end

function TilemapChunk:getTile(x, y)
    if x < 1 or y < 1 or x > self.width or y > self.height then
        return 0
    end
    
    return self.tiles[x][y]
end

function TilemapChunk:draw()
    if self.modified then
        self:regenerateSpriteBatch()
    end
    
    local x = self.parent.x + (self.chunk_x-1) * self.width * self.parent.tileset.tile_width
    local y = self.parent.y + (self.chunk_y-1) * self.height * self.parent.tileset.tile_height
    
    love.graphics.draw(self._sprite_batch, x, y)
end

return TilemapChunk