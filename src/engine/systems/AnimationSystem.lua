require(rosa.prefix .. "systems.System")

AnimationSystem = System:extends()

AnimationSystem.slot = "animation_system"
AnimationSystem.type = "AnimationSystem"
AnimationSystem.hooks = { "update" }

function AnimationSystem.update(dt)
    for _, animation in pairs(self.scene.nodes) do
        -- WIP
        --animation.predicted_frame = 
        --animation.entity.drawable.quad = animation.spritesheet.quads[animation.quad]
    end
end

coreman.registerSystem(AnimationSystem)