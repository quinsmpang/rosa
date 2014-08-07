function love.run()
    if love.math then
        love.math.setRandomSeed(os.time())
    end

    if love.event then
        love.event.pump()
    end

    if love.load then love.load(arg) end

    -- We don't want the first frame's dt to include time taken by love.load.
    if love.timer then love.timer.step() end

    local dt = 0

    -- Main loop time.
    while true do
        local status_text = ""
        -- Process events.
        if love.event then
            love.event.pump()
            for e,a,b,c,d in love.event.poll() do
                if e == "quit" then
                    if not love.quit or not love.quit() then
                        if love.audio then
                            love.audio.stop()
                        end
                        return
                    end
                end
                love.handlers[e](a,b,c,d)
            end
        end

        -- Update dt, as we'll be passing it to update
        if love.timer then
            love.timer.step()
            dt = love.timer.getDelta()
        end

        -- Call update and draw
        if love.update then
            --local success, result = pcall(love.update, debug.traceback, dt) -- will pass 0 if love.timer is disabled
            local success, result = xpcall(love.update, 
                function(err) return debug.traceback(err) end,
                dt
            ) -- will pass 0 if love.timer is disabled
            if not success then
                status_text = status_text .. "love.update is offline: \n" .. result .. "\n"
            end
        end

        if love.window and love.graphics and love.window.isCreated() then
            love.graphics.clear()
            love.graphics.origin()
            
            if love.draw then
                --local success, result = pcall(love.draw)
                local success, result = xpcall(love.draw,
                    function(err) return debug.traceback(err) end
                )
                
                --Set canvas to screen
                local canvas = love.graphics.getCanvas()
                love.graphics.setCanvas()
                
                if not success then
                    -- Add to the status text, and clear the screen
                    status_text = status_text .. "love.draw is offline\n" .. result .. "\n"
                    love.graphics.setBackgroundColor(0, 0, 0, 255)
                    love.graphics.clear()
                end
                -- Print the status text
                love.graphics.setColor(0, 255, 0, 255)
                love.graphics.printf(status_text, 20, 20, 600)
                love.graphics.setCanvas(canvas)
            end
            
            love.graphics.present()
        end

        if love.timer then love.timer.sleep(0.001) end
    end
end