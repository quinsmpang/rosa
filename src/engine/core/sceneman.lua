require(rosa.prefix .. "Scene")

sceneman = {}
sceneman.scenes = {}

function sceneman.newScene()
    local new_scene = Scene()
    
    sceneman.scenes[new_scene] = new_scene
    
    return new_scene
end

function sceneman.update(dt)
    
end

function sceneman.draw()
    sceneman.current_state:draw()
end

function sceneman.quit()
    sceneman.setState(nil)
end

function sceneman.setPause(pause)
    sceneman.pause = pause
end

return sceneman