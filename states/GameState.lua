GameState = Class{__includes = BaseState}
timer = -1
timer2 = -1

function GameState:init()
    sounds['Imperial March piano only']:pause()
    sounds['Imperial March duet']:pause()
    sounds['Battle music 1']:play()
    sand_dunes:play()

    read_P1_deck()

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
                next_round_deck[x+1].number = x+1
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
    if next_round_deck[x+5] == nil and next_round_deck[x+11] == nil and next_round_deck[x+17] == nil then
    row = x-1
        for i=0,2,1 do
            if next_round_deck[x] ~= nil then
                next_round_deck[x].row = row
                next_round_deck[x-1] = next_round_deck[x]
                next_round_deck[x-1].number = x-1
                next_round_deck[x] = nil
                x = x + 6
            end
        end
    end
end

function GameState:update(dt)
    for k, pair in pairs(buttons) do
        if pair.should_render == 'gamestate' then
            pair:update()
        end
    end
    if pause == false then
        timer = timer + dt 
        timer2 = timer2 + dt
        if timer >= 1 then
            timer = timer - 1
            for k, pair in pairs(P1_deck) do
                P1_deck[k]:move()
            end 
            for k, pair in pairs(P2_deck) do
                P2_deck[k]:move()
            end 
            for k, pair in pairs(P1_deck) do
                P1_deck[k]:attack1()
            end 
            for k, pair in pairs(P2_deck) do
                P2_deck[k]:attack1()
            end 
            if timer2 > 3 then
                CheckRowBelowEmpty(1,1)
                CheckRowBelowEmpty(1,0)
                CheckRowBelowEmpty(2,1)
                CheckRowBelowEmpty(2,0)
                CheckRowAboveEmpty(1,4)
                CheckRowAboveEmpty(1,5)
                CheckRowAboveEmpty(2,4)
                CheckRowAboveEmpty(2,5)
            end
            if timer2 > 5.9 and timer2 < 6.1 then
                P1_deck[2].health = 0
                P1_deck[8].health = 0 
                P1_deck[14].health = 0 
                P2_deck[2].health = 0
                P2_deck[8].health = 0 
                P2_deck[14].health = 0 
    
                P1_deck[1].health = 0 
                P2_deck[1].health = 0 
                P1_deck[4].health = 0 
                P2_deck[4].health = 0 

                -- P1_deck[7].health = 0 
                -- P2_deck[7].health = 0 
                -- P1_deck[10].health = 0 
                -- P2_deck[10].health = 0 

                -- P1_deck[13].health = 0 
                -- P2_deck[13].health = 0 
                -- P1_deck[16].health = 0 
                -- P2_deck[16].health = 0 
    
                P1_deck[3].health = 0
                P1_deck[9].health = 0 
                P1_deck[15].health = 0 
                P2_deck[3].health = 0
                P2_deck[9].health = 0 
                P2_deck[15].health = 0 
            end
        end

        -- P1_deck = next_round_P1_deck
        -- P2_deck = next_round_P2_deck

        for k, pair in pairs(P1_deck) do
            P1_deck[k]:update()
        end 
        for k, pair in pairs(P2_deck) do
            P2_deck[k]:update()
        end 
    end

    if love.keyboard.wasPressed('m') then 
        if sounds['Battle music 1']:isPlaying() then
            sounds['Battle music 1']:pause()
        else
            sounds['Battle music 1']:play()
        end
    end   
    
    -- P1_cards_alive = ''
    -- for k, pair in pairs(next_round_P1_deck) do
    --     P1_cards_alive = P1_cards_alive .. pair.name .. '\n'
    -- end
    -- love.filesystem.write('Player 1 alive units',P1_cards_alive)

    -- P2_cards_alive = ''
    -- for k, pair in pairs(next_round_P2_deck) do
    --     P2_cards_alive = P2_cards_alive .. pair.name .. '\n'
    -- end
    -- love.filesystem.write('Player 2 alive units',P2_cards_alive)
end

function GameState:render()
    love.graphics.draw(sand_dunes,0,0)
    -- love.graphics.draw(desert_background)
    for k, pair in pairs(P1_deck) do
        P1_deck[k]:render()
    end
    for k, pair in pairs(P2_deck) do
        P2_deck[k]:render()
    end
    -- love.graphics.setFont(font50)
    -- love.graphics.setColor(0, 255, 0, 255)
    -- love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
    -- love.graphics.setColor(255, 255, 255, 255)
    -- love.graphics.setFont(font80SW)
    for k, pair in pairs(buttons) do
        if pair.should_render == 'gamestate' then
            pair:render()
        end
    end
    if pause == true then
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