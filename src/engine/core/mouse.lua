local mouse = {}

function mouse.start()
    mouse.mapping = {
        l = "lmb",
        m = "mmb",
        r = "rmb",
        
        wd = "wheel_down",
        wu = "wheel_up",
        
        x1 = "extra1",
        x2 = "extra2"
    }
    mouse.base_modkeys = rosa.keyboard.base_modkeys
    
    mouse.prev_position = {0, 0}
    mouse.raw_position = {0, 0}
    
    -- Raw buttons and if they're down
    mouse.down_raw = {}
    -- Different modkeys or modkey combinations
    mouse.down = {}
    
    -- Latest events!
    mouse.just_pressed_raw = {}
    mouse.just_released_raw = {}
    mouse.just_pressed = {}
    mouse.just_released = {}
end

function mouse._translateButtonCode(button)
    if mouse.mapping[button] then
        return mouse.mapping[button]
    else
        return button
    end
end

function mouse._splitKeyString(keystring)
    local modkeys = {}
    for elem in string.gmatch(keystring, "[^-]+") do
        table.insert(modkeys, elem)
    end
    
    -- Put the key in separate variable from the modkeys
    local key = table.remove(modkeys, #modkeys)
    
    table.sort(modkeys,
        function(a, b)
            return mouse.base_modkeys[a] > mouse.base_modkeys[b]
        end
    )
    
    return table.concat(modkeys, "-"), key
end

function mouse._getKeystring(modkeys, button)
    local keystring = ""
    for modkey, _ in pairs(modkeys) do
        keystring = keystring .. modkey .. "-"
    end
    return keystring .. button
end

function mouse.update(dt)
    mouse.just_pressed_raw = {}
    mouse.just_released_raw = {}
    mouse.just_pressed = {}
    mouse.just_released = {}
    
    mouse.prev_position = mouse.raw_position
    mouse.raw_position = {love.mouse.getPosition()}
end

function mouse.mousepressed(x, y, button)
    button = mouse._translateButtonCode(button)
    -- Calculate the full keystring
    local keystring = mouse._getKeystring(rosa.keyboard.modkeys_down, button)
    
    -- Get sorted modkeys as a string
    local modkeys, _ = mouse._splitKeyString(keystring)
    
    -- Raw key down
    mouse.just_pressed_raw[button] = true
    
    -- Taking modifiers into account
    mouse.just_pressed[button] = mouse.just_pressed[button] or {}
    mouse.just_pressed[button][modkeys] = true
    
    -- Don't mark wheel up/down as down - they never get released
    if button ~= "wheel_up" and button ~= "wheel_down" then
        mouse.down_raw[button] = true
        mouse.down[button] = rosa.keyboard.down[button] or {}
        mouse.down[button][modkeys] = true
    end
end

function mouse.mousereleased(x, y, button)
    button = mouse._translateButtonCode(button)
    
    -- Freshly released keys
    if mouse.down_raw[button] ~= nil then
        mouse.just_released_raw[button] = true
    end
    
    -- Clear key pressed flag(s)isPressed
    mouse.down_raw[button] = nil
    
    for modkeys, _ in pairs(mouse.down[button] or {}) do
        mouse.just_released[button] = mouse.just_released[button] or {}
        mouse.just_released[button][modkeys] = true
    end
    
    -- Clear key pressed flag(s)
    mouse.down[button] = {}
end





function mouse._checkKeyTable(keystring, raw, adv, complex)
    -- Checks state of a key table
    complex = complex or false
    if not complex then
        return raw[keystring] or false
    else
        local modkeys, keycode = mouse._splitKeyString(keystring)
        
        return (adv[keycode] or {})[modkeys] or false
    end
end

function mouse._iterateInputEvents(raw, adv, complex)
    -- Does stuff. Don't question.
    complex = complex or false
    if not complex then
        for key, _ in pairs(raw) do
            coroutine.yield(key)
        end
    else
        for key, subtable in pairs(adv) do
            for modkeys, _ in pairs(subtable) do
                if modkeys ~= "" then
                    coroutine.yield(modkeys .. "-" ..key)
                else
                    coroutine.yield(key)
                end
            end
        end
    end
end

function mouse.isDown(keystring, complex)
    return mouse._checkKeyTable(keystring, mouse.down_raw, mouse.down, complex)
end

function mouse.justPressed(keystring, complex)
    return mouse._checkKeyTable(keystring, mouse.just_pressed_raw, mouse.just_pressed, complex)
end

function mouse.justReleased(keystring, complex)
    return mouse._checkKeyTable(keystring, mouse.just_released_raw, mouse.just_released, complex)
end

function mouse.iterateJustPressed(complex)
    return coroutine.wrap( function() mouse._iterateInputEvents(mouse.just_pressed_raw, mouse.just_pressed, complex) end )
end

function mouse.iterateJustReleased(complex)
    return coroutine.wrap( function() mouse._iterateInputEvents(mouse.just_released_raw, mouse.just_released, complex) end )
end

function mouse.iterateDown(complex)
    return coroutine.wrap( function() mouse._iterateInputEvents(mouse.down_raw, mouse.down, complex) end )
end

mouse.start()

return mouse