function love.conf(t)
    -- folder that app data is stored in
    t.identity = 'Galaxy Collection'

    -- app window title
    t.window.title = 'Galaxy Collection'

    --initialise window
    t.window.width = 0
    t.window.height = 0
    t.window.fullscreen = true
    t.window.resizable = true
    t.window.vsync = 1

    --Disable unused modules
    t.accelerometerjoystick = false
    t.modules.physics = false

    --Use ANGLE for graphics rending due to screen flashing issues when using OpenGL
    local ffi = require("ffi")
    local sdl = ffi.os == "Windows" and ffi.load("SDL2") or ffi.C
    
    ffi.cdef[[
    typedef enum SDL_bool {
           SDL_FALSE = 0,
           SDL_TRUE  = 1
    } SDL_bool;
    
    SDL_bool SDL_SetHint(const char *name,
                         const char *value);
    ]]
    
    sdl.SDL_SetHint("LOVE_GRAPHICS_USE_OPENGLES", "1") --Use OpenGL ES
    sdl.SDL_SetHint("SDL_OPENGL_ES_DRIVER", "1") --Use OpenGL ES through ANGLE
end