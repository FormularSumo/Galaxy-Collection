GameState = Class{__includes = BaseState}

timer = -1
timer2 = -1
timer3 = -1.9

function GameState:init()
    sounds['Battle music 1']:play()
    sand_dunes:play()

    read_P1_deck()

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
    gui['Pause'] = Button('pause','Pause',font100,nil,'centre',920)
    gui['Gamespeed Slider'] = Slider(1591,20,300,12,'gamespeed_slider',0.3,0.3,0.3,0,0,0,0.25)
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
        timer2 = timer2 + dt
        timer3 = timer3 + dt

        if timer >= 1 then
            timer = timer - 1
            
            for k, pair in pairs(P1_deck) do
                P1_deck[k]:move()
            end 
            for k, pair in pairs(P2_deck) do
                P2_deck[k]:move()
            end 
            if timer2 > 3 then
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
                P1_deck[k]:update(timer2)
            end 
            for k, pair in pairs(P2_deck) do
                P2_deck[k]:update(timer2)
            end 
            
            P1_deck = next_round_P1_deck
            P2_deck = next_round_P2_deck
        end

        if timer3 >= 1 then
            timer3 = timer3 - 1

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
            P1_deck[k]:update(timer2)
        end 
        for k, pair in pairs(P2_deck) do
            P2_deck[k]:update(timer2)
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

        if P1_deck == nil then
            winner = 'P2'
        elseif P2_deck == nil then
            winner = 'P1'
        end
    end

    if paused == true then
        sounds['Battle music 1']:pause()
        sand_dunes:pause()
    else
        if sounds['Battle music 1']:isPlaying() == false then
            sounds['Battle music 1']:play()
        end
        if sand_dunes:isPlaying() == false then
            sand_dunes:play()
        end
    end
end

function GameState:render()
    love.graphics.draw(sand_dunes,0,0)
    -- love.graphics.draw(desert_background)
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
    if winner ~= 'none' then 
        love.graphics.print('Winner: ' .. winner)
    end
    -- love.graphics.setFont(font50)
    -- love.graphics.setColor(0, 255, 0, 255)
    -- love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
    -- love.graphics.setColor(255, 255, 255, 255)
    -- love.graphics.setFont(font80SW)
end

function GameState:exit()
    love.audio.stop()
    sand_dunes:pause()
    sand_dunes:rewind()
    gui = {}
end