--require "modrun"

require("src.love_utils")

require("src.engine")

colors = {
    {9, 18, 73, 255},
    {99, 51, 102, 255},
    {195, 91, 111, 255},
    {255, 209, 193, 255},
}

function love.load(arg)
    initializeEngine()

    love.keyboard.setKeyRepeat(false)
    math.randomseed(os.time())
    
    image_scale = 2
    canvas_width = love.graphics.getWidth() / image_scale
    canvas_height = love.graphics.getHeight() / image_scale
    
    canvas = love.graphics.newCanvas(canvas_width, canvas_height)
    canvas:setFilter("nearest", "nearest")
    love.graphics.setCanvas(canvas)
    
    require("src.states.GameState")
    stateman.setState(GameState())
end

function initializeEngine()
    -- Load the ZeroBrane Studio debugger
    if arg[#arg] == "-debug" then
        require("mobdebug").start()
    end
    
    -- Load the profiler
    if arg[#arg] == "-profile" then
        ProFi = require("lib.ProFi")
        ProFi:start()
    end
    
    -- Tweening library
    flux = require("lib.flux.flux")
    
    -- GUI library
    require("lib.loveframes")
    
    -- Input subsystems
    keyboard = rosa.keyboard
    mouse = rosa.mouse
    
    -- Debug console
    console = rosa.console
    --require("src.engine.console")
    
    -- Managers
    stateman = rosa.stateman
    --sceneman = rosa.sceneman
    
    --ui_enabled = true
    --createMenubar(menu_template)
end

function shutdownEngine()
    if ProFi then
		ProFi:stop()
		ProFi:writeReport( 'MyProfilingReport.txt' )
    end
end

function love.update(dt)
    loveframes.update(dt)
    flux.update(dt)
    
    
    stateman.update(dt)
    
    keyboard.update(dt)
    mouse.update(dt)
end

function love.quit()
    stateman.quit()
    
    shutdownEngine()
end

function love.draw()
    ------
    -- camera:set()
    love.graphics.setCanvas(canvas)
    love.graphics.setColor(255, 255, 255, 255)
    
    stateman.draw()
    -- camera:unset()
    ------
    
    love.graphics.setCanvas()
    love.graphics.draw(canvas, 0, 0, 0, image_scale, image_scale)
    
    loveframes.draw()
end

function love.keypressed(key, isrepeat)
    loveframes.keypressed(key)
    
    if key == '`' then
        console.toggleConsole()
    end
    
    if not console.toggled then
        keyboard.keypressed(key)
    end
    
    if key == "f2" then
        takeScreenshot()
    elseif key == "f4" then
        love.event.push ( "quit" )
    end
end

function love.keyreleased(key)
    loveframes.keyreleased(key)
    
    keyboard.keyreleased(key)
end

function love.mousepressed(x, y, button)
    if loveframes.hover then
        loveframes.mousepressed(x, y, button)
    else
        mouse.mousepressed(x, y, button)
    end
end

function love.mousereleased(x, y, button)
    loveframes.mousereleased(x, y, button)
    mouse.mousereleased(x, y, button)
end

function love.textinput(text)
    stateman.textinput(text)
    loveframes.textinput(text)
end