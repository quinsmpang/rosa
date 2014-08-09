require("lib.loveframes")

require("src.utils")

console = {}
console.toggled = false

console.main_panel = nil

console.output_panel = nil
console.output_box = nil
console.input_panel = nil
console.input_box = nil

console.command_no = 1

console.input_history = {}
console.history_pos = -1
console.current_input = ""

function console.initialize()
    console.createConsole()
end

function console.createConsole()
    console.main_panel = loveframes.Create("panel")
	console.main_panel:SetSize(love.graphics.getWidth(), love.graphics.getWidth() * 0.3)
	console.main_panel:SetPos(0, -console.main_panel.height)
    console.toggled = false
	
    console.output_panel = loveframes.Create("panel", console.main_panel)
    console.output_panel:SetPos(0, 0)
    console.output_panel.Update = function(object)
		object:SetSize(console.main_panel:GetWidth(), console.main_panel:GetHeight() - 24)
    end
    
    console.input_panel = loveframes.Create("panel", console.main_panel)
    console.input_panel.Update = function(object)
		object:SetSize(console.main_panel:GetWidth(), 24)
        object:SetPos(0, console.main_panel:GetHeight() - 24)
    end
    
    console.output_box = loveframes.Create("textinput", console.output_panel)
    console.output_box:SetMultiline(true)
    console.output_box:SetEditable(false)
    console.output_box:ShowLineNumbers(false)
    console.output_box:SetMouseWheelScrollAmount(12)
    console.output_box:SetButtonScrollAmount(4)
    console.output_box.Update = function(object)
        object:SetSize(console.output_panel.width, console.output_panel.height)
    end
    
    
    console.input_box = loveframes.Create("textinput", console.input_panel)
    console.input_box:SetMultiline(false)
    console.input_box.Update = function(object)
        object:SetSize(console.input_panel.width, console.input_panel.height)
    end
    
    console.input_box.OnEnter = function(object, text)
        console.runCommand(text)
        table.insert(console.input_history, text)
        console.input_box:Clear()
        console.current_input = "" -- Clear any input the user might have input before going towards earlier commands
    end
    
    local original_RunKey = console.input_box.RunKey
    console.input_box.RunKey = function(obj, key, istext)
        if key == "up" then
            if (#console.input_history == 0) then return end
            
            if console.history_pos == -1 and #console.input_history > 0 then
                console.current_input = console.input_box:GetText()
                console.history_pos = #console.input_history
                console.input_box:SetText(console.input_history[console.history_pos])
            elseif console.history_pos > 1 then
                console.history_pos = console.history_pos - 1
                console.input_box:SetText(console.input_history[console.history_pos])
            end
        elseif key == "down" then
            if console.history_pos == -1 then
                return
            elseif console.history_pos < #console.input_history then
                console.history_pos = console.history_pos + 1
                console.input_box:SetText(console.input_history[console.history_pos])
            else
                console.history_pos = -1
                console.input_box:SetText(console.current_input)
                console.current_input = ""
            end
        elseif key == "tab" then
            -- Do nothing, not implemented so far
        else
            original_RunKey(obj, key, istext)
        end
    end
    
end

function console.runCommand(text)
    do
        print = function(...)
            local arg = {...}
            local text_to_print = ""
            for i, v in ipairs(arg) do
                if i ~= #arg then
                    text_to_print = text_to_print .. tostring(v) .. "\t"
                else
                    text_to_print = text_to_print .. tostring(v)
                end
            end
            
            console.output_box:SetText(
                console.output_box:GetText()
                 .. text_to_print .. "\n\n"
            )
        end
        
        console.output_box:SetText(
            console.output_box:GetText()
             .. "\nIn [" .. console.command_no .. "]: " .. text .. "\n\n"
        )
        
        local code, err = loadstring(text)
        
        -- It's probably a statement, load it as one
        if err then
            code = loadstring("return " .. text)
        end
        
        local success, result = xpcall(code, 
            function(err)
                console.output_box:SetText(
                    console.output_box:GetText()
                     .. "Err [".. console.command_no .. "]: " .. err
                     .. "\n\n"
                )
            end
        )
        
        if success then
            console.output_box:SetText(
                console.output_box:GetText()
                 .. "Out [".. console.command_no .. "]: " .. str(result, true)
                 .. "\n\n"
            )
        end
        
        console.command_no = console.command_no + 1
    end
end

function console.hideConsole()
    flux.to(console.main_panel, 0.1, {y=-console.main_panel.height}):oncomplete(function() console.main_panel.visible = false; end)
    console.toggled = false
    console.input_box:SetFocus(false)
end

function console.showConsole()
    console.main_panel.visible = true
    flux.to(console.main_panel, 0.1, {y=0})
    console.toggled = true
    console.input_box:SetFocus(true)
end

function console.toggleConsole()
    if console.toggled then
        console.hideConsole()
    else
        console.showConsole()
    end
end

console.initialize()

return console