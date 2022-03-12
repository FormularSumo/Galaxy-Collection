function love.load()
    --Libraries and other files that are required
    push = require 'push'
    Class = require 'class'
    bitser = require 'bitser'
    
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
    require 'Weapon'
    require 'Weapon2'
    require 'Projectile'
    require 'Projectile2'
    require 'Card editor'
    require 'Remove card'

    --Operating System
    OS = love.system.getOS()

    VIRTUAL_WIDTH = 1920
    VIRTUAL_HEIGHT = 1080

    -- initialise virtual resolution
    push.setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, {
        upscale = 'normal',
    })
    love.window.maximize()

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

    P2_deck_cards = {}
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
    sandbox = true
    yscroll = 0
    rawyscroll = 0

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
        if love.filesystem.getInfo('Player 1 deck.txt') == nil or bitser.loadLoveFile('Player 1 deck.txt') == nil then
            P1_deck_cards = {}
            bitser.dumpLoveFile('Player 1 deck.txt',P1_deck_cards)
        else
            P1_deck_cards = bitser.loadLoveFile('Player 1 deck.txt')
            for k, pair in pairs(P1_deck_cards) do
                if P1_deck_cards[k] ~= nil and not Characters[P1_deck_cards[k][1]] then
                    P1_deck_cards[k] = nil
                end
            end
            bitser.dumpLoveFile('Player 1 deck.txt',P1_deck_cards)
            P1_deck_cards = {}
        end

        if love.filesystem.getInfo('Player 1 cards.txt') == nil or bitser.loadLoveFile('Player 1 cards.txt') == nil then
            bitser.dumpLoveFile('Player 1 cards.txt',P1_cards)
        else
            P1_cards = bitser.loadLoveFile('Player 1 cards.txt')
            for k, pair in pairs(P1_cards) do
                if P1_cards[k] ~= nil and not Characters[P1_cards[k][1]] then
                    P1_cards[k] = nil
                end
            end
            bitser.dumpLoveFile('Player 1 cards.txt',P1_cards)
            P1_cards = nil
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

    if name and name[1] == 'Blank' then name = nil end
    P1_deck_cards[position] = name

    bitser.dumpLoveFile('Player 1 deck.txt',P1_deck_cards)
end

function P1_cards_edit(position,name)
    P1_cards = bitser.loadLoveFile('Player 1 cards.txt')

    if name and name[1] == 'Blank' then name = nil end
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
            love.window.setFullscreen(not love.window.getFullscreen())

        --M mutes/unmutes
        elseif key == 'm' then
            if love.audio.getVolume() == 0 then
                love.audio.setVolume(0.5)
            else
                love.audio.setVolume(0)
            end
            Settings['volume_level'] = love.audio.getVolume()
            bitser.dumpLoveFile('Settings.txt', Settings)
            if gStateMachine.state == 'SettingsState' then
                gui[2].percentage = love.audio.getVolume()
            end

        elseif gStateMachine.state == 'GameState' then
            if key == 'pageup' then 
                gui[3]:update_percentage(gui[3].percentage * 2,false)
            elseif key == 'pagedown' then
                gui[3]:update_percentage(gui[3].percentage / 2,false)
            end
        end
    else
        love.keyboard.keysPressed[key] = 'repeat'
    end
    if key == 'up' or key == 'down' then
        if mouseTouching == false then
            repositionMouse(1)
        else
            for k, v in ipairs(gui) do
                if v == mouseTouching then
                    if key == 'up' then
                        if gui[k-1] then
                            repositionMouse(k-1)
                        end
                    end
                    if key == 'down' then
                        if gui[k+1] then
                            repositionMouse(k+1)
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

    elseif key == 'escape' then
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

function love.gamepadreleased(joystick,button)
    local key = controllerBinds(button)
    love.keyreleased(key)
end

function love.gamepadpressed(joystick,button)
    local key = controllerBinds(button)
    love.keypressed(key)
    lastClickIsTouch = false
end

function love.mousemoved(x,y)
    mouseX,mouseY = push.toGame(x,y)
    if mouseX == false or mouseY == false then
        mouseX = -1
        mouseY = -1
    end
    if math.abs(x - mouseButtonX) < 1 and math.abs(y - mouseButtonY) < 1 then
        return
    end
    love.mouse.setVisible(true)
end

function love.touchmoved(id,x,y,dx,dy)
    if (yscroll > -1080 or dy > 0) and (yscroll < 1080 or dy < 0) then
        rawyscroll = rawyscroll + dy
        lastScrollIsTouch = true
    end
end

function love.wheelmoved(x,y)
    if (yscroll > -1080 or y > 0) and (yscroll < 1080 or y < 0) then
        rawyscroll = rawyscroll + y * 50
        lastScrollIsTouch = false
    end
end

function love.focus(InFocus)
    focus = InFocus
    if Settings['pause_on_loose_focus'] and not (paused and gStateMachine.state == 'GameState') then pause(not focus) end --Pause/play game if pause_on_loose_focus setting is on
end

function love.update(dt)
    --Handle joystick inputs
    if joysticks and focus then
        local leftx = 0
        local lefty = 0
        for k, v in pairs(joysticks) do
            leftx = leftx + v:getGamepadAxis('leftx')
            lefty = lefty + v:getGamepadAxis('lefty')
        end
        if math.abs(leftx) > 0.2 or math.abs(lefty) > 0.2 then --Deadzone because otherwise joysticks are so sensitive they trap mouse inside game unless you alt-tab
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
                
                if love.keyboard.wasDown('up') and direction ~= 'up' then
                    love.keyreleased('up')
                end
                if love.keyboard.wasDown('down') and direction ~= 'down' then
                    love.keyreleased('down')
                end
                if love.keyboard.wasDown('left') and direction ~= 'left' then
                    love.keyreleased('left')
                end
                if love.keyboard.wasDown('right') and direction ~= 'right' then
                    love.keyreleased('right')
                end

                if love.timer.getTime() > keyPressedTimer + 0.1 then
                    love.keypressed(direction)
                    keyPressedTimer = love.timer.getTime()
                end
            end
        elseif direction then
            love.keyreleased(direction)
            direction = nil
            lastPressed = nil
            keyHoldTimer = 0
        end
    end

    --Handle mouse inputs
    if love.mouse.isDown(1) or love.keyboard.wasDown('return') or love.keyboard.wasDown('kpenter') then
        updateMousePosition()
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

    --Smooth scrolling
    if (yscroll > -1080 or rawyscroll > 0) and (yscroll < 1080 or rawyscroll < 0) then
        yscroll = yscroll + rawyscroll * dt * 12
        if lastScrollIsTouch then
            rawyscroll = rawyscroll - rawyscroll * math.min(dt*3,0.1)
        else
            rawyscroll = rawyscroll - rawyscroll * math.min(dt*10,1)
        end
    else
        if yscroll > 1080 then yscroll = 1080 rawyscroll = 0 end
        if yscroll < -1080 then yscroll = -1080 rawyscroll = 0 end
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
    if mouseDown == false and mouseLocked == false then mouseTrapped = false mouseLastX = -1 mouseLastY = -1 end
    mouseDown = false
end

function love.draw()
    push.start()
    if background['Background'] then
        love.graphics.draw(background['Background'])
    end
    gStateMachine:render()
    for k, pair in pairs(gui) do
        if mouseTouching ~= pair and mouseTrapped ~= pair then
            pair:render()
        end
    end
    if mouseTrapped then mouseTrapped:render() end
    if mouseTouching ~= mouseTrapped then mouseTouching:render() end
    if Settings['FPS_counter'] == true then
        love.graphics.print({{0,255,0,255}, 'FPS: ' .. tostring(love.timer.getFPS())}, font50, 1680, 1020)
    end

    -- for k, v in pairs(joysticks) do
    --     love.graphics.print(tostring(v),0,300+k*100)
    --     love.graphics.print(v:getName(),1880-font80:getWidth(v:getName())-font80:getWidth(tostring(v:isConnected()))-font80:getWidth(tostring(v:isGamepad())),k*100-100)
    --     love.graphics.print(tostring(v:isConnected()),1900-font80:getWidth(tostring(v:isConnected()))-font80:getWidth(tostring(v:isGamepad())),k*100-100)
    --     love.graphics.print(tostring(v:isGamepad()),1920-font80:getWidth(tostring(v:isGamepad())),k*100-100)
    -- end

    -- stats = love.graphics.getStats()
    -- stats = {love.graphics.getRendererInfo()}
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