local empty_quad = love.graphics.newQuad(0, 0, 0, 0, 1, 1)

local Spritesheet = rosa.types.Resource:extends()

Spritesheet.class_name = "Spritesheet"
Spritesheet.type = "spritesheet"
Spritesheet.extensions = {}

function Spritesheet:__init(image, tile_width, tile_height)
    --Resource.__init(self)
    
    self.image = image
    
    self.tile_width = tile_width or image:getWidth()
    self.tile_height = tile_height or image:getHeight()
    
    self.quads = {}
    
    local w, h = image:getWidth(), image:getHeight()
    
    for y = 1, (h / self.tile_height) do
        for x = 1, (w / self.tile_width) do
            local quad = love.graphics.newQuad(
                (x-1)*self.tile_width,
                (y-1)*self.tile_height,
                self.tile_width,
                self.tile_height, 
                w,
                h
            )
            table.insert(self.quads, quad)
        end
    end
end

-- TODO: Add tagged sprites. MAAAAYBE

rosa.resman.registerResourceClass(Spritesheet)

return Spritesheet