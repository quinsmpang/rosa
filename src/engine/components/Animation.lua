flux = require "lib.flux.flux"

Animation = Behavior:extends()

Animation.slot = "animation"
Animation.type = "Animation"
Animation.collect = true


function Animation:__init(entity)
    Behavior.__init(self, entity)
    
    self.animation = nil
    self.finished = true
    self.start = love.timer.getTime()
    self.last_frame = 1
    self.frame = 1
    self.quad = 1
    
    self.spritesheet = nil
    
    self.animations = {}
end

function Animation:setSpritesheet(spritesheet)
    self.spritesheet = spritesheet
    
    if self.entity.drawable then
        self.entity.drawable.drawable = spritesheet.image
    end
end

function Animation:addAnimation(name, frames, speed, play_after)
    speed = speed or 100
    
    self.animations[name] = {
        frames = frames,
        speed = speed,
        play_after = play_after
    }
    
    return name
end

function Animation:playAnimation(name, starting_frame, _time_offset)
    if name == nil then
        self.animation = nil
    end
    
    starting_frame = starting_frame or 1

    local anim = self.animations[name]
    if not anim then return end
    
    self.animation = name
    
    self.finished = false
    self.last_frame = -1
    self.frame = 1
    self.start = love.timer.getTime() - (starting_frame-1) * anim.speed * 0.001 - (_time_offset or 0)
end

function Animation:getAnimationFrame()
    local anim = self.animations[self.animation]
    local predicted_frame = 1 + (love.timer.getTime() - self.start) / (anim.speed * 0.001)
    
    if predicted_frame-1 > #anim.frames and anim.play_after then
        local new_time = love.timer.getTime()
        local offset =  (anim.speed * 0.001) * #anim.frames - (new_time - self.start)
        self:playAnimation(anim.play_after, 1, offset)
    end
    
    return math.floor(math.min(math.max(predicted_frame, 1), #anim.frames))
end

function Animation:update(dt)
    if not self.entity.drawable then return end
    
    local frame = self:getAnimationFrame()
    local quad_index = self.animations[self.animation].frames[frame]
    local quad = self.spritesheet.quads[quad_index]
    
    self.entity.drawable:setQuad(quad)
end

coreman.registerComponent(Animation)