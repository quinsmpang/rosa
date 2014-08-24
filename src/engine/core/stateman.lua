local stateman = {}
stateman.current_state = nil
stateman.__dummy_func = function() end
stateman.pause = false

function stateman.setState(state)
    if state == nil then
        stateman.current_state:quit()
        
        stateman.current_state = nil
    else
        stateman.current_state = state
        state:load()
    end
    
    stateman.setPause(false)
end

function stateman.update(dt)
    if not stateman.pause and stateman.current_state then
        stateman.current_state:update(dt)
    end
end

function stateman.draw()
    if stateman.current_state then
        stateman.current_state:draw()
    end
end

function stateman.quit()
    stateman.setState(nil)
end

function stateman.setPause(pause)
    stateman.pause = pause
end

function stateman.textinput(text)
    if stateman.current_state then
        stateman.current_state:textinput(text)
    end
end

return stateman