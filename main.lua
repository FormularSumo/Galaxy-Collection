push = require 'push'

Class = require 'class'

require 'Card'
require 'Button'
require 'Characters/Character stats'
require 'StateMachine'
require 'states/BaseState'
require 'states/GameState'
require 'states/HomeState'

VIRTUAL_WIDTH = 1920
VIRTUAL_HEIGHT = 1080

Battle1 = Button('Battle 1.png')

background_video = love.graphics.newVideo('Videos/Stary background.ogv')

desert_background = love.graphics.newImage('Desert_background.png')

function love.load()
    -- app window title
    love.window.setTitle('Star Wars Force Collection Remake')

    -- load fonts
    font50 = love.graphics.newFont(50)
    font80 = love.graphics.newFont(80)
    font80SW = love.graphics.newFont('Distant Galaxy.ttf',80)
    love.graphics.setFont(font80)

    sounds = {
        ['Imperial March piano only'] = love.audio.newSource('Music/Imperial March piano only.mp3','stream'),
        ['Imperial March duet'] = love.audio.newSource('Music/Imperial March duet.mp3','stream'),
        ['cool music'] = love.audio.newSource('Music/cool music.mp3','stream')
    }

    love.audio.setVolume(1)


    -- initialize virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, 0, 0, {
        vsync = true,
        fullscreen = true,
        resizable = true
    })
    
    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['home'] = function() return HomeState() end,
        ['game'] = function() return GameState() end,
    }
    gStateMachine:change('home')

    math.randomseed(os.time()) --Randomises randomiser each time program is run. 

    P1_deck = {}
    P2_deck = {}
    next_round_P1_deck = {}
    P1_deck_cards = {}
    P2_deck_cards = {}

    -- P1_deck_cards[0] = 'AhsokaS7'
    P1_deck_cards[1] = 'AnakinF3'
    P1_deck_cards[2] = 'BabyYoda'
    P1_deck_cards[3] = 'BenKenobi'
    P1_deck_cards[4] = 'C3P0'
    P1_deck_cards[5] = 'Chewbacca'
    -- P1_deck_cards[6] = 'DarthSidiousReborn'
    P1_deck_cards[7] = 'DarthVader'
    P1_deck_cards[8] = 'Ewok'
    P1_deck_cards[9] = 'FarmboyLuke'
    P1_deck_cards[10] = 'HanSoloOld'
    P1_deck_cards[11] = 'Hondo'
    for i = 12,17,1 do
        P1_deck_cards[i] = 'Ewok'
    end

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
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

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key] 
end

function love.mousereleased(x,y,button)
    love.mouse.buttonsPressed[button] = true
    mouseLastX,mouseLastY = love.mouse.getPosition()
    mouseLastX,mouseLastY = push:toGame(mouseLastX,mouseLastY)
end

function love.touchpressed()
    love.mouse.buttonsPressed[1] = true
    mouseLastX,mouseLastY = love.mouse.getPosition()
    mouseLastX,mouseLastY = push:toGame(mouseLastX,mouseLastY)
end

function love.update(dt)
    gStateMachine:update(dt)
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end


function love.draw()
    push:start()
    gStateMachine:render()
    push:finish()
end
