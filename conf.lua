function love.conf(t)
    t.identity = nil                   -- The name of the save directory (string)
    t.version = "0.9.0"                -- The LÖVE version this game was made for (string)
    t.console = false                   -- Attach a console (boolean, Windows only)

    t.window.title = "Akasha, the reality engine" -- The window title (string)
    --t.window.icon = "data/images/icon.png" -- Filepath to an image to use as the window's icon (string)
    t.window.width = 800               -- The window width (number)
    t.window.height = 600              -- The window height (number)
    t.window.borderless = false        -- Remove all border visuals from the window (boolean)
    t.window.resizable = false         -- Let the window be user-resizable (boolean)

    t.window.vsync = true
end
