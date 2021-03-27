GameState = Class{__includes = BaseState}

function GameState:enter(Background)
    background['Type'] = Background[2]
    background['Seek'] = Background[3]
    if background['Type'] == 'video' then
        background['Background'] = love.graphics.newVideo(tostring('Backgrounds/' .. Background[1] .. '.ogv'))
    else
        background['Background'] = love.graphics.newImage(tostring('Backgrounds/' .. Background[1] .. '.jpg'))
    end
    if Background[4] == nil then r = 0 else r = Background[4] end
    if Background[5] == nil then g = 0 else g = Background[5] end
    if Background[6] == nil then b = 0 else b = Background[6] end
    gui['Pause'] = Button('pause','Pause',font100,nil,1591,60,r,g,b) -- 35 pixels from right as font100:getWidth('Pause') = 294
    gui['Gamespeed Slider'] = Slider(1591,35,300,12,'gamespeed_slider',0.3,0.3,0.3,r,g,b,0.25,0.25)

    if background['Seek'] > 1 then --All levels have at least a 1 second delay before spawing characters
        timer = 0 - (background['Seek'] - 1)
    else
        timer = 0
    end
    move_aim_timer = timer
    attack_timer = timer - 0.9
end

function GameState:init()
    songs[0] = love.audio.newSource('Music/Battle music 1.mp3','stream')
    
    BlueLaser = love.graphics.newImage('Graphics/Blue Laser.png')
    GreenLaser = love.graphics.newImage('Graphics/Green Laser.png')
    RedLaser = love.graphics.newImage('Graphics/Red Laser.png')

    songs[0]:play()
    queue_length = 0

    read_P1_deck()
    P1_deck = {}
    P2_deck = {}
    winner = 'none'
    gamespeed = 1
    P1column = -1
    P2column = 12
    row_correctment = 0

    for i=0,17,1 do
        if i % 6 == 0 and i ~= 0 then
            P1column = -1 - i / 6 
            P2column = 12 + i / 6 
            row_correctment = i
        end
        row = i - row_correctment
        if P1_deck_cards[i] ~= none then
            P1_deck[i] = Card(P1_deck_cards[i],row,P1column,1,i)
        end
        if P2_deck_cards[i] ~= none then
            P2_deck[i] = Card(P2_deck_cards[i],row,P2column,2,i)
        end
    end
    
    next_round_P1_deck = P1_deck
    next_round_P2_deck = P2_deck
    -- P1_deck[2].health = 0
    -- P1_deck[8].health = 0 
    -- P1_deck[14].health = 0 
    -- P2_deck[2].health = 0
    -- P2_deck[8].health = 0 
    -- P2_deck[14].health = 0 

    -- P1_deck[0].health = 0 
    -- P2_deck[0].health = 0 
    -- P1_deck[5].health = 0 
    -- P2_deck[5].health = 0 

    -- P1_deck[3].health = 0
    -- P1_deck[9].health = 0 
    -- P1_deck[15].health = 0 
    -- P2_deck[3].health = 0
    -- P2_deck[9].health = 0 
    -- P2_deck[15].health = 0 
end

function CheckRowBelowEmpty(player,x)
    if player == 1 then
        next_round_deck = next_round_P1_deck
    else
        next_round_deck = next_round_P2_deck
    end
    if next_round_deck[x+1] == nil and next_round_deck[x+7] == nil and next_round_deck[x+13] == nil then
        row = x+1
        for i=0,2,1 do
            if next_round_deck[x] ~= nil then
                next_round_deck[x].row = row
                next_round_deck[x+1] = next_round_deck[x]
                next_round_deck[x] = nil
                x = x + 6
            end
        end
    end
end

function CheckRowAboveEmpty(player,x)
    if player == 1 then
        next_round_deck = next_round_P1_deck
    else
        next_round_deck = next_round_P2_deck
    end
    if (not(next_round_deck[x-2] == nil and next_round_deck[x+4] == nil and next_round_deck[x+10]) == nil) or not(
        next_round_deck[x-3] == nil and next_round_deck[x+3] == nil and next_round_deck[x+9] == nil) and x == 3 then return end
    if next_round_deck[x-1] == nil and next_round_deck[x+5] == nil and next_round_deck[x+11] == nil then
        row = x-1
        for i=0,2,1 do
            if next_round_deck[x] ~= nil then
                next_round_deck[x].row = row
                next_round_deck[x-1] = next_round_deck[x]
                next_round_deck[x] = nil
                x = x + 6
            end
        end
    end
end

function Check2TopRowsEmpty(player)
    if player == 1 then
        next_round_deck = next_round_P1_deck
    else
        next_round_deck = next_round_P2_deck
    end
    if next_round_deck[0] == nil and next_round_deck[6] == nil and next_round_deck[12] == nil and
    next_round_deck[1] == nil and next_round_deck[7] == nil and next_round_deck[13] == nil and
    not(next_round_deck[4] == nil and next_round_deck[10] == nil and next_round_deck[16] == nil) and
    not(next_round_deck[5] == nil and next_round_deck[11] == nil and next_round_deck[17] == nil) then
        y = 2
        for i=0,4,1 do
            x = y
            row = x-1
            for i=0,2,1 do
                if next_round_deck[x] ~= nil then
                    next_round_deck[x].row = row
                    next_round_deck[x-1] = next_round_deck[x]
                    next_round_deck[x] = nil
                    x = x + 6
                end
            end
            y = y + 1
        end
    end
end

function Check2BottomRowsEmpty(player)
    if player == 1 then
        next_round_deck = next_round_P1_deck
    else
        next_round_deck = next_round_P2_deck
    end
    if next_round_deck[4] == nil and next_round_deck[10] == nil and next_round_deck[16] == nil and
    next_round_deck[5] == nil and next_round_deck[10] == nil and next_round_deck[17] == nil and
    not(next_round_deck[0] == nil and next_round_deck[6] == nil and next_round_deck[12] == nil) and
    not(next_round_deck[1] == nil and next_round_deck[7] == nil and next_round_deck[13] == nil) then
        y = 4
        for i=0,4,1 do
            x = y
            row = x+1
            for i=0,2,1 do
                if next_round_deck[x] ~= nil then
                    next_round_deck[x].row = row
                    next_round_deck[x+1] = next_round_deck[x]
                    next_round_deck[x] = nil
                    x = x + 6
                end
            end
            y = y - 1
        end
    end
end

function CheckOnlyRow1and2Remain(player)
    if player == 1 then
        next_round_deck = next_round_P1_deck
    else
        next_round_deck = next_round_P2_deck
    end
    if next_round_deck[0] == nil and next_round_deck[6] == nil and next_round_deck[12] == nil and
    next_round_deck[3] == nil and next_round_deck[9] == nil and next_round_deck[15] == nil and
    next_round_deck[4] == nil and next_round_deck[10] == nil and next_round_deck[16] == nil and
    next_round_deck[5] == nil and next_round_deck[11] == nil and next_round_deck[17] == nil and 
    not(next_round_deck[1] == nil and next_round_deck[7] == nil and next_round_deck[13] == nil) and
    not(next_round_deck[2] == nil and next_round_deck[8] == nil and next_round_deck[14] == nil) then
        y = 2
        for i=0,2,1 do
            x = y
            row = x+1
            for i=0,2,1 do
                if next_round_deck[x] ~= nil then
                    next_round_deck[x].row = row
                    next_round_deck[x+1] = next_round_deck[x]
                    next_round_deck[x] = nil
                    x = x + 6
                end
            end
            y = y - 1
        end
    end
end

function CheckOnlyRow3and4Remain(player)
    if player == 1 then
        next_round_deck = next_round_P1_deck
    else
        next_round_deck = next_round_P2_deck
    end
    if next_round_deck[0] == nil and next_round_deck[6] == nil and next_round_deck[12] == nil and
    next_round_deck[1] == nil and next_round_deck[7] == nil and next_round_deck[13] == nil and
    next_round_deck[2] == nil and next_round_deck[8] == nil and next_round_deck[14] == nil and
    next_round_deck[5] == nil and next_round_deck[11] == nil and next_round_deck[17] == nil and 
    not(next_round_deck[3] == nil and next_round_deck[9] == nil and next_round_deck[15] == nil) and
    not(next_round_deck[4] == nil and next_round_deck[10] == nil and next_round_deck[16] == nil) then
        y = 3
        for i=0,2,1 do
            x = y
            row = x-1
            for i=0,2,1 do
                if next_round_deck[x] ~= nil then
                    next_round_deck[x].row = row
                    next_round_deck[x-1] = next_round_deck[x]
                    next_round_deck[x] = nil
                    x = x + 6
                end
            end
            y = y + 1
        end
    end
end


function GameState:update(dt)
    dt = dt * gamespeed
    if paused == false and winner == 'none' then
        timer = timer + dt
        move_aim_timer = move_aim_timer + dt
        attack_timer = attack_timer + dt

        if move_aim_timer >= 1 then
            move_aim_timer = move_aim_timer - 1
            
            for k, pair in pairs(P1_deck) do
                P1_deck[k]:move()
            end 
            for k, pair in pairs(P2_deck) do
                P2_deck[k]:move()
            end 
            if timer > 3 then
                CheckRowBelowEmpty(1,1)
                CheckRowBelowEmpty(1,0)
                CheckRowBelowEmpty(2,1)
                CheckRowBelowEmpty(2,0)
                CheckRowAboveEmpty(1,3)
                CheckRowAboveEmpty(1,4)
                CheckRowAboveEmpty(1,5)
                CheckRowAboveEmpty(2,3)
                CheckRowAboveEmpty(2,4)
                CheckRowAboveEmpty(2,5)
                Check2TopRowsEmpty(0)
                Check2TopRowsEmpty(1)
                Check2BottomRowsEmpty(0)
                Check2BottomRowsEmpty(1)
                CheckOnlyRow3and4Remain(0)
                CheckOnlyRow3and4Remain(1)
                CheckOnlyRow1and2Remain(0)
                CheckOnlyRow1and2Remain(1)
            end
            for k, pair in pairs(P1_deck) do
                P1_deck[k]:update(dt,timer)
            end 
            for k, pair in pairs(P2_deck) do
                P2_deck[k]:update(dt,timer)
            end 
            
            P1_deck = next_round_P1_deck
            P2_deck = next_round_P2_deck

            for k, pair in pairs(P1_deck) do
                P1_deck[k]:aim()
            end 
            for k, pair in pairs(P2_deck) do
                P2_deck[k]:aim()
            end
        end

        if attack_timer >= 1 then
            attack_timer = attack_timer - 1

            for k, pair in pairs(P1_deck) do
                P1_deck[k].dodge = 0
                P1_deck[k].attacks_taken = 0
            end 
            for k, pair in pairs(P2_deck) do
                P2_deck[k].dodge = 0
                P2_deck[k].attacks_taken = 0
            end 

            for k, pair in pairs(P1_deck) do
                P1_deck[k]:attack()
            end 
            for k, pair in pairs(P2_deck) do
                P2_deck[k]:attack()
            end 
            P1_deck = next_round_P1_deck
            P2_deck = next_round_P2_deck
        end

        for k, pair in pairs(P1_deck) do
            P1_deck[k]:update(dt,timer)
        end 
        for k, pair in pairs(P2_deck) do
            P2_deck[k]:update(dt,timer)
        end 
        P1_deck = next_round_P1_deck
        P2_deck = next_round_P2_deck
    end  

    if love.keyboard.wasPressed('space') then
        pause()
    end
   
    if winner == 'none' then
        P1_cards_alive = ''
        for k, pair in pairs(P1_deck) do
            P1_cards_alive = P1_cards_alive .. pair.name .. '\n'
        end
        if P1_cards_alive == '' then P1_deck = nil end

        P2_cards_alive = ''
        for k, pair in pairs(P2_deck) do
            P2_cards_alive = P2_cards_alive .. pair.name .. '\n'
        end
        if P2_cards_alive == '' then P2_deck = nil end

        if P1_deck == nil or P2_deck == nil then
            gui['Main Menu'] = Button('return_to_main_menu','Main menu',font80,nil,35,110,r,g,b)
            if P1_deck == nil and P2_deck == nil then 
                winner = 'Draw'
            elseif P1_deck == nil then
                winner = 'P2'
            elseif P2_deck == nil then
                winner = 'P1'
            end
        end
    end
end

function GameState:render()
    if P1_deck ~= nil then
        for k, pair in pairs(P1_deck) do
            P1_deck[k]:render()
        end
    end
    if P2_deck ~= nil then
        for k, pair in pairs(P2_deck) do
            P2_deck[k]:render()
        end
    end

    if P1_deck ~= nil then
        for k, pair in pairs(P1_deck) do
            if P1_deck[k].laser ~= nil then
                P1_deck[k].laser:render()
            end
        end
    end

    if P2_deck ~= nil then
        for k, pair in pairs(P2_deck) do
            if P2_deck[k].laser ~= nil then
                P2_deck[k].laser:render()
            end
        end
    end

    if winner ~= 'none' then 
        love.graphics.print({{r,g,b},'Winner: ' .. winner},35,20)
    end
    -- love.graphics.print({{0,255,0,255}, 'FPS: ' .. tostring(love.timer.getFPS())}, font50, 10, 10)
end

function GameState:exit()
    P1_deck = nil
    P2_deck = nil
    next_round_P1_deck = nil
    next_round_P2_deck = nil
    P2_deck_cards = {}
    BlueLaser = nil
    GreenLaser = nil
    RedLaser = nil
    exit_state()
end