local AnimationSystem = rosa.types.System:extends()

AnimationSystem.slot = "animation_system"
AnimationSystem.type = "AnimationSystem"
AnimationSystem.hooks = { "update" }

function AnimationSystem:update(dt)
    if self.scene.nodes.animation == nil then return end
    
    for _, anim in pairs(self.scene.nodes.animation) do
        if not anim.finished then
            anim.frame_time = anim.frame_time - dt
            
            while anim.frame_time < 0 do
                local current_animation = anim.animations[anim.animation]
                
                anim.frame = anim.frame + 1
                anim.frame_time = anim.frame_time + current_animation.speed * 0.001
                
                if anim.frame > #current_animation.frames then
                    if current_animation.play_after then
                        anim:playAnimation(current_animation.play_after)
                    else
                        anim.finished = true
                    end
                end
            end
            
            if anim.frame ~= anim._last_frame then
                anim.last_frame = anim.frame
                
                local quad_n = anim.animations[anim.animation].frames[anim.frame]
                local quad = anim.spritesheet.quads[quad_n]
                --print("CHANGING QUAD TO " .. tostring(quad_n) .. " (" .. anim.frame .. ")")
                anim.entity.drawable.quad = quad
            end
        end
    end
end

rosa.coreman.registerSystem(AnimationSystem)

return AnimationSystem