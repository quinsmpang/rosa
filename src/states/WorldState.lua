require("src.engine.Camera")

WorldState = rosa.types.State:extends()

function WorldState:load()
    love.graphics.setDefaultFilter("nearest")
    self.camera = Camera:new()
    self.camera.screen_scale = image_scale
    self.camera.pixel_perfect = true
    
    self.scene = rosa.sceneman.newScene()
    self.scene:addSystem("RenderSystem")
    self.scene:addSystem("AnimationSystem")
    
    self.mario_res = rosa.resources.ImageResource("data/img/hires-mario.png")
    self.hat1_res = rosa.resources.ImageResource("data/img/hires-mario-hat1.png")
    
    --local mario_image = love.graphics.newImage("data/img/hires-mario.png")
    --local player_tilesheet = rosa.resources.Spritesheet(love.graphics.newImage("data/img/player_sprites.png"), 16, 16)
    
    local hat_prefab = rosa.types.Prefab(
        "Mario_Hat_1",
        {
            { "Drawable", {drawable=self.hat1_res, origin_x=15, origin_y=19} },
            { "Transform", {x=0, y=-13, relative=true} }
        }
    )
    
    local mario_prefab = rosa.types.Prefab(
        "Mario",
        {
            { "Drawable", {drawable=self.mario_res, origin_x=16, origin_y=16} },
            --{ "Animation", {spritesheet=player_spritesheet} },
            { "Transform", {x=60, y=0, r=math.pi / 180.0 * 30, relative=true} }
        },
        {hat = "Mario_Hat_1"}
    )
    
    self.player = self.scene:instantiatePrefab("Mario")
    local old_player = self.player
    for i=1, 11 do
        local next_player = self.scene:instantiatePrefab("Mario")
        old_player:addChild(next_player)
        old_player = next_player
    end
    
    local hat = self.scene:instantiatePrefab("Mario_Hat_1")
    self.player:addChild(hat)
    self.player:tagChild(hat, "hat")
end

function WorldState:update(dt)
    rosa.resman.update(dt)
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

function WorldState:draw()
    --love.graphics.setBackgroundColor(unpack(colors[4]))
    love.graphics.clear()
    
    self.scene:draw(self.camera)
end