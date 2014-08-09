flux = require "lib.flux.flux"

Animation = Behavior:extends()

Animation.slot = "animation"
Animation.type = "Animation"
Animation.collect = true


function Animation:__init(entity)
    Behavior.__init(self, entity)
    
    self.animation = nil
    
    self.finished = true
    self.last_frame = -1
    
    self.frame = 1
    self.frame_time = 0
    
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

function Animation:playAnimation(name)
    if not self.animations[name] then return end
    
    self.animation = name
    self.frame = 1
    self.frame_time = self.animations[name].speed * 0.001
    
    self.finished = false
    
    self.last_frame = -1
end

function Animation:stopAnimation()
    self.finished = true
end

coreman.registerComponent(Animation)