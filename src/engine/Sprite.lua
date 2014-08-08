require "src.engine.objects.SceneObject"

flux = require "lib.flux.flux"

Sprite = SceneObject:extends()

function Sprite:__init(spritesheet, x, y)
    SceneObject.__init(self, x, y)
    
    self.rotation = 0
    self.scale_x = 1.0
    self.scale_y = 1.0
    
    self.animation = nil
    self.animation_start = love.timer.getTime()
    self.animation_frame = 1
    
    self.spritesheet = spritesheet -- can be nil
    
    self.animations = {}
end

function Sprite:addAnimation(name, frames, speed, play_after)
    speed = speed or 100
    
    self.animations[name] = {
        frames = frames,
        speed = speed,
        play_after = play_after
    }
    
    return name
end

function Sprite:playAnimation(name, starting_frame, _time_offset)
    if name == nil then
        self.animation = nil
    end
    
    starting_frame = starting_frame or 1

    local anim = self.animations[name]
    if not anim then return end
    
    self.animation = name
    self.animation_frame = starting_frame
    
    self.animation_start = love.timer.getTime() - (starting_frame-1) * anim.speed * 0.001 - (_time_offset or 0)
end

function Sprite:getAnimationFrame()
    local anim = self.animations[self.animation]
    local predicted_frame = 1 + (love.timer.getTime() - self.animation_start) / (anim.speed * 0.001)
    
    if predicted_frame-1 > #anim.frames and anim.play_after then
        local new_time = love.timer.getTime()
        local offset =  (anim.speed * 0.001) * #anim.frames - (new_time - self.animation_start)
        self:playAnimation(anim.play_after, 1, offset)
    end
    
    
    return math.floor(math.min(math.max(predicted_frame, 1), #anim.frames))
end

function Sprite:draw()
    local r = self.rotation
    local sx = self.scale_x * (self.flip_x and -1 or 1)
    local sy = self.scale_y * (self.flip_y and -1 or 1)
    local x = self.x + self.spritesheet.tile_width  * (self.flip_x and 1 or 0)
    local y = self.y + self.spritesheet.tile_height * (self.flip_y and 1 or 0)
    
    if self.animation ~= nil then
        local frame = self:getAnimationFrame()
        
        local n = self.animations[self.animation].frames[frame]
        local quad = self.spritesheet.quads[n]
        
        love.graphics.draw(self.spritesheet.image, quad, x, y, r, sx, sy)
    else
        love.graphics.draw(self.spritesheet.image, x, y, r, sx, sy)
    end
end