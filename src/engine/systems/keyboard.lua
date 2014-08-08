keyboard = {}

function keyboard.start()
    keyboard.mapping = {
        rctrl = "ctrl",
        lctrl = "ctrl",
        
        rshift = "shift",
        lshift = "shift",
        
        ralt = "alt",
        lalt = "alt",
        
        rgui = "meta",
        lgui = "meta",
        
        [" "] = "space",
        ["-"] = "minus"
    }
    
    -- Those should be in alphabetic order
    keyboard.base_modkeys = {
        alt = 1,
        ctrl = 2,
        meta = 3,
        shift = 4
    }
    
    -- Modkeys that are down
    keyboard.modkeys_down = {}
    
    -- Raw keys and if they're down
    keyboard.down_raw = {}
    -- Different modkeys or modkey combinations
    keyboard.down = {}
    
    -- Latest events!
    keyboard.just_pressed_raw = {}
    keyboard.just_released_raw = {}
    keyboard.just_pressed = {}
    keyboard.just_released = {}
end



function keyboard._translateKeyCode(keycode)
    if keyboard.mapping[keycode] then
        return keyboard.mapping[keycode]
    else
        return keycode
    end
end

function keyboard._splitKeyString(keystring)
    local modkeys = {}
    for elem in string.gmatch(keystring, "[^-]+") do
        table.insert(modkeys, elem)
    end
    
    -- Put the key in separate variable from the modkeys
    local key = table.remove(modkeys, #modkeys)
    
    table.sort(modkeys,
        function(a, b)
            return keyboard.base_modkeys[a] > keyboard.base_modkeys[b]
        end
    )
    
    return table.concat(modkeys, "-"), key
end

function keyboard._getKeystring(modkeys, keycode)
    local keystring = ""
    for modkey, _ in pairs(modkeys) do
        keystring = keystring .. modkey .. "-"
    end
    return keystring .. keycode
    
--    return table.concat(modkeys, '-') .. '-' .. keycode
end

function keyboard.update(dt)
    keyboard.just_pressed_raw = {}
    keyboard.just_released_raw = {}
    keyboard.just_pressed = {}
    keyboard.just_released = {}
end

function keyboard.keypressed(keycode)
    keycode = keyboard._translateKeyCode(keycode)
    
    -- Calculate the full keystring
    local keystring = keyboard._getKeystring(keyboard.modkeys_down, keycode)
    
    -- Get sorted modkeys as a string
    local modkeys, _ = keyboard._splitKeyString(keystring)
    
    -- Raw key down
    keyboard.down_raw[keycode] = true
    keyboard.just_pressed_raw[keycode] = true
    
    -- Taking modifiers into account
    keyboard.down[keycode] = keyboard.down[keycode] or {}
    keyboard.down[keycode][modkeys] = true
    keyboard.just_pressed[keycode] = keyboard.just_pressed[keycode] or {}
    keyboard.just_pressed[keycode][modkeys] = true
    
    -- Modifier keys
    if keyboard.base_modkeys[keycode] then
        keyboard.modkeys_down[keycode] = true
    end
end

function keyboard.keyreleased(keycode)
    keycode = keyboard._translateKeyCode(keycode)
    
    -- Clear key pressed flag(s)
    keyboard.down_raw[keycode] = nil
    
    -- Freshly released keys
    keyboard.just_released_raw[keycode] = true
    
    for modkeys, _ in pairs(keyboard.down[keycode] or {}) do
        keyboard.just_released[keycode] = keyboard.just_released[keycode] or {}
        keyboard.just_released[keycode][modkeys] = true
    end
    
    -- Clear key pressed flag(s)
    keyboard.down[keycode] = {}
    
    -- Modifier keys
    if keyboard.base_modkeys[keycode] then
        keyboard.modkeys_down[keycode] = nil
    end
end



function keyboard._checkKeyTable(keystring, raw, adv, complex)
    -- Checks state of a key table
    complex = complex or false
    if not complex then
        return raw[keystring] or false
    else
        local modkeys, keycode = keyboard._splitKeyString(keystring)
        
        return (adv[keycode] or {})[modkeys] or false
    end
end

function keyboard._iterateInputEvents(raw, adv, complex)
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

function keyboard.isDown(keystring, complex)
    return keyboard._checkKeyTable(keystring, keyboard.down_raw, keyboard.down, complex)
end

function keyboard.justPressed(keystring, complex)
    return keyboard._checkKeyTable(keystring, keyboard.just_pressed_raw, keyboard.just_pressed, complex)
end

function keyboard.justReleased(keystring, complex)
    return keyboard._checkKeyTable(keystring, keyboard.just_released_raw, keyboard.just_released, complex)
end

function keyboard.iterateJustPressed(complex)
    return coroutine.wrap( function() keyboard._iterateInputEvents(keyboard.just_pressed_raw, keyboard.just_pressed, complex) end )
end

function keyboard.iterateJustReleased(complex)
    return coroutine.wrap( function() keyboard._iterateInputEvents(keyboard.just_released_raw, keyboard.just_released, complex) end )
end

function keyboard.iterateDown(complex)
    return coroutine.wrap( function() keyboard._iterateInputEvents(keyboard.down_raw, keyboard.down, complex) end )
end

function keyboard.keypadDirection(up, down, left, right, speed)
    speed = speed or 1
    
    local x, y = 0, 0
    if keyboard.isDown(up) then
        y = -1
    elseif keyboard.isDown(down) then
        y = 1
    end
    
    if keyboard.isDown(left) then
        x = -1
    elseif keyboard.isDown(right) then
        x = 1
    end
    
    return x * speed, y * speed
end

keyboard.start()

return keyboard