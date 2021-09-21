function love.load()
    --Libraries and other files that are required
    push = require 'push'
    Class = require 'class'
    bitser = require 'bitser/bitser'
    
    require 'Card'
    require 'Button'
    require 'Slider'
    require 'Text'
    require 'Characters/Character stats'
    require 'StateMachine'
    require 'states/BaseState'
    require 'states/HomeState'
    require 'states/GameState'
    require 'states/SettingsState'
    require 'states/CampaignState'
    require 'states/DeckeditState'
    require 'states/ExitState'
    require 'campaign'
    require 'other functions'
    require 'Projectile'
    require 'Weapon'
    require 'Card editor'

    --Operating System
    OS = love.system.getOS()

    VIRTUAL_WIDTH = 1920
    VIRTUAL_HEIGHT = 1080

    -- initialise virtual resolution
    push.setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, {
        upscale = 'normal',
    })

    -- load fonts
    font50 = love.graphics.newFont(50)
    font60 = love.graphics.newFont(60)
    font80 = love.graphics.newFont(80)
    -- font80SW = love.graphics.newFont('Fonts/Distant Galaxy.ttf',80)
    -- font80SW_runes = love.graphics.newFont('Fonts/Aurebesh Bold.ttf',80)
    font100 = love.graphics.newFont(100)
    love.graphics.setFont(font80)
    
    gui = {}
    songs = {}
    background = {}
    paused = false

    P1_deck_cards = {}
    P2_deck_cards = {}
    P1_cards = {}
    UserData = {}

    love.keyboard.keysPressed = {}
    love.keyboard.keysReleased = {}
    love.keyboard.keysDown = {}
    love.mouse.buttonsPressed = {}
    mouseDown = false
    mouseTouching = false
    mouseTrapped = false
    mouseTrapped2 = false
    mouseLastX = 0
    mouseLastY = 0
    mouseX = 0
    mouseY = 0
    mouseButtonX = 0
    mouseButtonY = 0
    lastClickIsTouch = false
    focus = true
    keyHoldTimer = 0
    keyPressedTimer = love.timer.getTime()
    mouseLocked = false

    if love.filesystem.getInfo('Settings.txt') == nil then
        Settings = {
            ['pause_on_loose_focus'] = true,
            ['volume_level'] = 0.5,
            ['FPS_counter'] = false,
            ['videos'] = true
        }
        bitser.dumpLoveFile('Settings.txt',Settings)
    end

    Settings = bitser.loadLoveFile('Settings.txt')
    love.audio.setVolume(Settings['volume_level'])

    if love.filesystem.getInfo('Player 1 deck.txt') == nil and love.filesystem.getInfo('Player 1 cards.txt') == nil and love.filesystem.getInfo('User Data.txt') == nil then
        tutorial()
    
    else
        if love.filesystem.getInfo('Player 1 deck.txt') == nil then
            bitser.dumpLoveFile('Player 1 deck.txt',P1_deck_cards)
        end

        if love.filesystem.getInfo('Player 1 cards.txt') == nil then
            bitser.dumpLoveFile('Player 1 cards.txt',P1_cards)
        end

        if love.filesystem.getInfo('User Data.txt') == nil then
            UserData['Credits'] = 0
            if Settings['videos'] == nil then Settings['videos'] = true end
            bitser.dumpLoveFile('User Data.txt',UserData)
        end
    end

    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['HomeState'] = function() return HomeState() end,
        ['GameState'] = function() return GameState() end,
        ['SettingsState'] = function() return SettingsState() end,
        ['CampaignState'] = function() return CampaignState() end,
        ['DeckeditState'] = function() return DeckeditState() end,
        ['ExitState'] = function() return ExitState() end,
    }
    gStateMachine:change('HomeState')
end

function P1_deck_edit(position,name)
    P1_deck_cards = bitser.loadLoveFile('Player 1 deck.txt')

    P1_deck_cards[position] = name

    bitser.dumpLoveFile('Player 1 deck.txt',P1_deck_cards)
end

function P1_cards_edit(position,name)
    P1_cards = bitser.loadLoveFile('Player 1 cards.txt')

    P1_cards[position] = name

    bitser.dumpLoveFile('Player 1 cards.txt',P1_cards)
end

function love.resize(w, h)
    push.resize(w, h)
end

function love.joystickadded(joystick)
    joysticks = love.joystick.getJoysticks()
end

function love.joystickremoved(joystick)
    joysticks = love.joystick.getJoysticks()
end

function love.keypressed(key,scancode,isrepeat)
    --Stop mute/fullscreen being repeatedly toggled if you hold keys
    if not isrepeat then
        love.keyboard.keysPressed[key] = true
        love.keyboard.keysDown[key] = true
        lastPressed = key
        keyHoldTimer = 0
        --F11 toggles between fullscreen and maximised
        if key == 'f11' then
            if love.window.getFullscreen() == false then
                love.window.setFullscreen(true)
            else
                love.window.setFullscreen(false)
                love.window.maximize()
            end
        end

        --M mutes/unmutes
        if key == 'm' then
            if love.audio.getVolume() == 0 then
                love.audio.setVolume(0.5)
            else
                love.audio.setVolume(0)
            end
            Settings['volume_level'] = love.audio.getVolume()
            bitser.dumpLoveFile('Settings.txt', Settings)
            if gui['Volume Slider'] ~= nil then
                gui['Volume Slider'].percentage = love.audio.getVolume()
            end
        end
    else
        love.keyboard.keysPressed[key] = 'repeat'
    end
    if key == 'up' or key == 'down' then
        if mouseTouching == false then
            reposition_mouse(1)
        else
            for k, v in ipairs(gui) do
                if v == mouseTouching then
                    if key == 'up' then
                        if gui[k-1] then
                            reposition_mouse(k-1)
                        end
                    end
                    if key == 'down' then
                        if gui[k+1] then
                            reposition_mouse(k+1)
                        end
                    end
                    break
                end
            end
        end
    end
end

function love.keyreleased(key)
    love.keyboard.keysReleased[key] = true
    love.keyboard.keysDown[key] = false

    if key == 'return' or key == 'kpenter' then
        love.mouse.buttonsPressed[1] = true
    end

    if key == 'escape' then
        gStateMachine:back()
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key] 
end

function love.keyboard.wasReleased(key)
    return love.keyboard.keysReleased[key] 
end

function love.keyboard.wasDown(key)
    return love.keyboard.keysDown[key]
end

function love.mousereleased(x,y,button,istouch)
    love.mouse.buttonsPressed[button] = true
    if button == 4 then love.keypressed('escape') end
    lastClickIsTouch = istouch
end

function love.touchreleased()
    love.mouse.buttonsPressed[1] = true
end

function love.gamepadreleased(joystick,button)
    local key = controller_binds(button)
    love.keyreleased(key)
end

function love.gamepadpressed(joystick,button)
    local key = controller_binds(button)
    love.keypressed(key)
end

function love.mousemoved(x,y)
    mouseX,mouseY = push.toGame(x,y)
    if mouseX == false or mouseY == false then
        mouseX = -1
        mouseY = -1
    end
    if x == math.floor(mouseButtonX) or y == math.floor(mouseButtonY) then
        return
    elseif OS == 'Android' and (x == mouseButtonX or y == mouseButtonY) then 
        return
    end
    love.mouse.setVisible(true)
end

function love.focus(InFocus)
    focus = InFocus
    if Settings['pause_on_loose_focus'] and not (paused and gStateMachine.state == 'GameState') then pause(not focus) end --Pause/play game if pause_on_loose_focus setting is on
end

function love.update(dt)
    --Handle joystick inputs
    if joysticks then
        leftx = 0
        lefty = 0
        -- local direction
        for k, v in pairs(joysticks) do
            leftx = leftx + dt * 1000 * v:getGamepadAxis('leftx')
            lefty = lefty + dt * 1000 * v:getGamepadAxis('lefty')
        end
        if math.abs(leftx) > 2 or math.abs(lefty) > 2 then --Only if in focus because you don't want joysticks to continue moving mouse when you're not in program and deadzone because otherwise joysticks are so sensitive they trap mouse inside game unless you alt-tab
            if math.abs(leftx) > math.abs(lefty) then
                if leftx < 0 then
                    direction = 'left'
                else
                    direction = 'right'
                end
            else
                if lefty < 0 then
                    direction = 'up'
                else
                    direction = 'down'
                end
            end
            if direction ~= lastPressed then
                love.keyboard.keysDown['up'] = false
                love.keyboard.keysDown['down'] = false
                love.keyboard.keysDown['right'] = false
                love.keyboard.keysDown['left'] = false

                love.keyboard.keysDown[direction] = true
                if love.timer.getTime() > keyPressedTimer + 0.1 then
                    love.keypressed(direction) 
                    keyPressedTimer = love.timer.getTime()
                end
            end
        elseif direction then
            love.keyboard.keysDown[direction] = false
            direction = nil
            lastPressed = nil
            keyHoldTimer = 0
        end
    end

    --Handle mouse inputs
    if love.mouse.isDown(1) or love.keyboard.wasDown('return') or love.keyboard.wasDown('kpenter') then
        update_mouse_position()
    end

    --Handle holding down keys
    if lastPressed then
        if love.keyboard.wasDown(lastPressed) then
            keyPressedTimer = love.timer.getTime()
            keyHoldTimer = keyHoldTimer + dt
            if keyHoldTimer > 0.5 then
                love.keypressed(lastPressed,nil,true)
                keyHoldTimer = keyHoldTimer - 0.05
            end
        else
            keyHoldTimer = 0
        end
    end

    --Manage song queue
    if songs[0] ~= nil then
        if songs[current_song]:isPlaying() == false and paused == false then
            if next_song <= queue_length then
                songs[next_song]:play()
                current_song = next_song
                next_song = next_song + 1
            else
                next_song = 0
            end
        end
    end

    --Manage background video looping and pausing
    if background['Type'] == 'video' then
        if paused == true then
            background['Background']:pause()
        else
            if background['Background']:isPlaying() == false then
                background['Background']:play()
            end
            testForBackgroundImageLoop(background['Background'],background['Seek'])
        end
    end

    mouseTouching = false

    --Update GUI elements
    for k, pair in pairs(gui) do
        pair:update(dt)
    end

    --Update state machine
    gStateMachine:update(dt)

    --Reset tables of clicked keys/mousebuttons so last frame's inputs aren't used next frame
    love.keyboard.keysPressed = {}
    love.keyboard.keysReleased = {}
    love.mouse.buttonsPressed = {}
    if mouseDown == false and mouseLocked == false then mouseTrapped = false end
    mouseDown = false
end

function love.draw()
    push.start()
    if background['Background'] then
        love.graphics.draw(background['Background'])
    end
    gStateMachine:render()
    for k, pair in pairs(gui) do
        if mouseTouching ~= pair then
            pair:render()
        end
    end
    if mouseTouching then mouseTouching:render() end
    if Settings['FPS_counter'] == true then
        love.graphics.print({{0,255,0,255}, 'FPS: ' .. tostring(love.timer.getFPS())}, font50, 1680, 1020)
    end

    -- for k, v in pairs(joysticks) do
    --     love.graphics.print(tostring(v),0,300+k*100)
    --     love.graphics.print(v:getName(),1880-font80:getWidth(v:getName())-font80:getWidth(tostring(v:isConnected()))-font80:getWidth(tostring(v:isGamepad())),k*100-100)
    --     love.graphics.print(tostring(v:isConnected()),1900-font80:getWidth(tostring(v:isConnected()))-font80:getWidth(tostring(v:isGamepad())),k*100-100)
    --     love.graphics.print(tostring(v:isGamepad()),1920-font80:getWidth(tostring(v:isGamepad())),k*100-100)
    -- end

    -- love.graphics.print(tostring(mouseTouching) .. ' ' .. tostring(gui['Campaign']))

    -- stats = love.graphics.getStats()
    -- y = 0
    -- for k, pair in pairs(stats) do
    --     love.graphics.print(k .. ' ' .. pair,0,y)
    --     y = y + 100
    -- end
    -- love.graphics.print(tostring(mouseTrapped) .. ' ' .. tostring(mouseTrapped2))
    -- if temporary then
    --     love.graphics.print(tostring(temporary.name .. ' ' .. temporary.row),0,400)
    -- end
    -- if temporary2 then
    --     love.graphics.print(tostring(temporary2.name .. ' ' .. temporary2.row),0,500)
    -- end
    push.finish()
end