push = require 'push'

Class = require 'class'

require 'Card'
require 'Button'
require 'Slider'
require 'Characters/Character stats'
require 'StateMachine'
require 'states/BaseState'
require 'states/GameState'
require 'states/HomeState'
require 'campaign'
require 'other functions'

function love.load()
    --Operating System
    OS = love.system.getOS()

    -- app window title
    love.window.setTitle('Star Wars Force Collection Remake')
    
    VIRTUAL_WIDTH = 1920
    VIRTUAL_HEIGHT = 1080

    math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6))) --Randomises randomiser each time program is run. String is reversed to preserve low bits in time (eg second, millisecodns) rather than high bits (years, hours) when rounding - see http://lua-users.org/wiki/MathLibraryTutorial
    math.random()
    
    -- initialize virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, 0, 0, {
        vsync = true,
        fullscreen = true,
        resizable = true
    })

    -- load fonts
    font50 = love.graphics.newFont(50)
    font80 = love.graphics.newFont(80)
    font80SW = love.graphics.newFont('Fonts/Distant Galaxy.ttf',80)
    font80SW_runes = love.graphics.newFont('Fonts/Aurebesh Bold.ttf',80)
    font100 = love.graphics.newFont(100)
    love.graphics.setFont(font80)

    sounds = {
        ['Imperial March piano only'] = love.audio.newSource('Music/Imperial March piano only.oga','stream'),
        ['Imperial March duet'] = love.audio.newSource('Music/Imperial March duet.mp3','stream'),
        ['Battle music 1'] = love.audio.newSource('Music/Battle music 1.mp3','stream')
    }

    background_video = love.graphics.newVideo('Videos/Starry Background.ogv')

    sand_dunes = love.graphics.newVideo('Videos/Sand Dunes.ogv')

    desert_background = love.graphics.newImage('Backgrounds/Desert_background.png')
    
    gui = {}

    love.filesystem.setIdentity('Star Wars Force Collection Remake')
    P1_deck_cards = {}
    P2_deck_cards = {}

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
    mouseDown = false
    mouseLastX = 0
    mouseLastY = 0
    focus = true
    joysticks = love.joystick.getJoysticks()

    P1_deck_file = love.filesystem.read('Player 1 deck.txt')

    if P1_deck_file == nil then
        love.filesystem.write('Player 1 deck.txt',',,,,,,,,,,,,,,,,,,')
    end

    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['home'] = function() return HomeState() end,
        ['game'] = function() return GameState() end,
    }
    gStateMachine:change('home')
end

function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result
end

function P1_deck_edit(position,name)
    P1_deck_file = love.filesystem.read('Player 1 deck.txt')
    P1_deck_cards_original = split(P1_deck_file,',')
    for k, pair in pairs(P1_deck_cards_original) do 
        P1_deck_cards[k-1] = pair
    end
    length = #P1_deck_cards
    P1_deck_cards[position] = tostring(name)
    P1_deck_cards_string = ''
    x = -1
    for k, pair in pairs(P1_deck_cards) do
        x = x + 1
        if x < length then
            P1_deck_cards_string = P1_deck_cards_string .. pair .. ','
        else
            P1_deck_cards_string = P1_deck_cards_string .. pair --stops extra comma being written
        end
    end

    love.filesystem.write('Player 1 deck.txt',P1_deck_cards_string)

    read_P1_deck()
end

function read_P1_deck()
    P1_deck_cards = {}
    P1_deck_file = love.filesystem.read('Player 1 deck.txt')
    P1_deck_cards_original = split(P1_deck_file,',')

    for k, pair in pairs(P1_deck_cards_original) do 
        if pair ~= '' then
            P1_deck_cards[k-1] = pair
        end
    end
end


function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    --F11 toggles between fullscreen and maximised
    if key == 'f11' then
        if love.window.getFullscreen() == false then
            love.window.setFullscreen(true)
        else
            love.window.setFullscreen(false)
            love.window.maximize()
        end
    end

    if key == 'm' then
        if love.audio.getVolume() == 1 then
            love.audio.setVolume(0)
        else
            love.audio.setVolume(1)
        end
    end 

    --Escape on Android is mapped to the back key so can't be used for toggling fullscreen (well it can, but I don't want it to)
    if key == 'escape' and OS ~= Android then
        love.window.setFullscreen(false)
        love.window.maximize()
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key] 
end

function love.mousereleased(x,y,button)
    love.mouse.buttonsPressed[button] = true
    mouseLastX,mouseLastY = push:toGame(love.mouse.getPosition())
    if mouseLastX == nil or mouseLastY == nil then
        mouseLastX = -1
        mouseLastY = -1
    end
end

function love.touchreleased()
    love.mouse.buttonsPressed[1] = true
    mouseLastX,mouseLastY = push:toGame(love.mouse.getPosition())
    if mouseLastX == nil or mouseLastY == nil then
        mouseLastX = -1
        mouseLastY = -1
    end
end

function love.joystickreleased(joystick,button)
    if button == 1 then
        love.mouse.buttonsPressed[1] = true
        mouseLastX,mouseLastY = push:toGame(love.mouse.getPosition())
        if mouseLastX == nil or mouseLastY == nil then
            mouseLastX = -1
            mouseLastY = -1
        end
    end
end

function love.focus(InFocus)
    if InFocus then
        focus = true
    else
        focus = false
    end
end

function love.update(dt)
    --Handle inputs
    if love.mouse.isDown(1,2,3) then
        mouseDown = true
        mouseLastX,mouseLastY = push:toGame(love.mouse.getPosition())
        if mouseLastX == nil or mouseLastY == nil then
            mouseLastX = -1
            mouseLastY = -1
        end
    end

    -- If a joysticks is connected, otherwise don't both running all the joystick-input code
    if joysticks[1] then
        if joysticks[1]:isDown(1) then 
            mouseDown = true
            mouseLastX,mouseLastY = push:toGame(love.mouse.getPosition())
            if mouseLastX == nil or mouseLastY == nil then
                mouseLastX = -1
                mouseLastY = -1
            end
        end
        
        leftx = dt * 1000 * joysticks[1]:getGamepadAxis('leftx')
        lefty = dt * 1000 * joysticks[1]:getGamepadAxis('lefty')
        if focus and (leftx > 1 or leftx < -1 or lefty > 1 or lefty < -1) then --Only if in focus because you don't want joysticks to continue moving mouse when you're not in program and buffer because otherwise joysticks are so sensitive they trap mouse inside game unless you alt-tab
            love.mouse.setPosition(
                love.mouse.getX() + (dt * 1000 * joysticks[1]:getGamepadAxis('leftx')),
                love.mouse.getY() + (dt * 1000 * joysticks[1]:getGamepadAxis('lefty')))
        end

        if joysticks[1]:isGamepadDown('dpleft') then
            love.mouse.setPosition(love.mouse.getX()-(dt*1000),love.mouse.getY())
        end
        if joysticks[1]:isGamepadDown('dpright') then
            love.mouse.setPosition(love.mouse.getX()+(dt*1000),love.mouse.getY())
        end
        if joysticks[1]:isGamepadDown('dpup') then
            love.mouse.setPosition(love.mouse.getX(),love.mouse.getY()-(dt*1000))
        end
        if joysticks[1]:isGamepadDown('dpdown') then
            love.mouse.setPosition(love.mouse.getX(),love.mouse.getY()+(dt*1000))
        end
    end
    
    --Update GUI elements
    for k, pair in pairs(gui) do
        pair:update()
    end

    --Update state machine
    gStateMachine:update(dt)

    --Reset table of clicked keys/mousebuttons so last frame's inputs aren't used next frame
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
    mouseDown = false
end

function love.draw()
    push:start()
    gStateMachine:render()
    for k, pair in pairs(gui) do
        pair:render()
    end
    push:finish()
end