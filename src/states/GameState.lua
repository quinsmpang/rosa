require("src.engine.Camera")

--require "src.engine.objects.Tilemap"
--require "src.engine.objects.Sprite"

require "src.engine.resources.Spritesheet"

GameState = State:extends()

function GameState:load()
    self.camera = Camera:new()
    self.camera.screen_scale = image_scale
    self.camera.pixel_perfect = true
    
    self.scene = sceneman.newScene()
    self.scene:addSystem("RenderSystem")
    
    self.player = self.scene:newEntity()
    self.player:addComponent("Drawable")
    self.player.drawable.drawable = love.graphics.newImage("data/img/hires-mario.png")
    
    self.player:addComponent("Animation")
    
    player_tilesheet = Spritesheet(love.graphics.newImage("data/img/player_sprites.png"), 16, 16)
    self.player.animation:setSpritesheet(player_tilesheet)
    
    self.player.animation:addAnimation("idle", {1})
    self.player.animation:addAnimation("start walking", {2}, 100, "walk")
    self.player.animation:addAnimation("walk", {3, 4, 5}, 100, "walk")
    
    self.player.animation:playAnimation("start walking")
    
    --self.terrain_tileset = Spritesheet(love.graphics.newImage("data/img/terrain_tiles.png"), 16, 16)
    --self.player_tilesheet = Spritesheet(love.graphics.newImage("data/img/player_sprites.png"), 16, 16)
    --
    --self.map1 = Tilemap(0, 0, 12, 12)
    --self.map1:setTileset(self.terrain_tileset)
    --self.map1:setTile(4, 3, 1)
    --self.map1:setTile(4, 4, 4)
    --self.map1:setTile(4, 5, 1)
    --self.map1:setTile(4, 6, 4)
    
    --self.player = Sprite(self.player_tilesheet, 24, 24)
    --
    --self.player:addAnimation("idle", {1})
    --self.player:addAnimation("start walking", {2}, 100, "walk")
    --self.player:addAnimation("walk", {3, 4, 5}, 100, "walk")
    --
    --self.player:playAnimation("start walking")
    --
    --
    --self.scene:addObject(self.map1)
    --self.scene:addObject(self.player)
end

function GameState:update(dt)
    --local mx, my = self.camera:getMousePosition()
    --local tx = math.floor(mx / self.map1.tileset.tile_width)
    --local ty = math.floor(my / self.map1.tileset.tile_height)
    --if mouse.isDown("lmb", true) then
        --self.map1:setTile(tx, ty, 1)
    --elseif mouse.isDown("rmb", true) then
        --self.map1:setTile(tx, ty, 0)
    --elseif mouse.isDown("ctrl-lmb", true) then
        --self.map1:setTile(tx, ty, 4)
    --end
    --
    --if keyboard.isDown("q") then self.player.flip_x = true  end
    --if keyboard.isDown("e") then self.player.flip_x = false end
    
    local dx, dy = keyboard.keypadDirection("w", "s", "a", "d", 240 * dt)
    self.camera:move(dx, dy)
    
    self.scene:update(dt)
end

function GameState:draw()
    --love.graphics.setBackgroundColor(unpack(colors[4]))
    love.graphics.clear()
    
    self.scene:draw(self.camera)
end