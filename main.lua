push = require 'push'

Class = require 'class'

require 'StateMachine'
require 'states/BaseState'
require 'states/GameState'
require 'states/HomeState'

VIRTUAL_WIDTH = 1080
VIRTUAL_HEIGHT = 1920

background = love.graphics.newVideo('Videos/Home background.ogg')
-- background = love.video.newVideoStream('Videos/Home background.ogg')

function love.load()
    -- app window title
    love.window.setTitle('Star Wars Force Collection Remake')

    -- load fonts
    font50 = love.graphics.newFont(50)
    font80 = love.graphics.newFont(80)
    love.graphics.setFont(font80)
    
    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['home'] = function() return HomeState() end,
        ['game'] = function() return GameState() end,
    }
    gStateMachine:change('home')

    math.randomseed(os.time()) --Randomises randomiser each time program is run. 

    -- initialize virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, 0, 0, {
        vsync = true,
        fullscreen = true,
        resizable = true
    })

    love.keyboard.keysPressed = {}
end


function love.resize(w, h)
    push:resize(w, h)
end


function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    --Escape exits fullscreen
    if key == 'escape' then
        love.window.setFullscreen(false)
        love.window.maximize()
    end
    --F11 toggles between fullscreen and maximised
    if key == 'f11' then
        if love.window.getFullscreen() == false then
            love.window.setFullscreen(true)
        else
            love.window.setFullscreen(false)
            love.window.maximize()
        end
    end
end


function love.update(dt)
    gStateMachine:update(dt)
    love.keyboard.keysPressed = {}
end


function love.draw()
    push:start()

    -- love.graphics.draw(background,0,0)
    -- background:play()
    
    gStateMachine:render()

    push:finish()
end