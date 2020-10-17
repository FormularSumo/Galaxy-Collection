GameState = Class{__includes = BaseState}
timer = -1
timer2 = -1

function GameState:init()
    sounds['Imperial March piano only']:pause()
    sounds['Imperial March duet']:pause()
    sounds['cool music']:play()
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
    P1_deck[2].health = 0
    P1_deck[8].health = 0 
    P1_deck[14].health = 0 
    P2_deck[2].health = 0
    P2_deck[8].health = 0 
    P2_deck[14].health = 0 

    P1_deck[0].health = 0 
    P2_deck[0].health = 0 
    P1_deck[5].health = 0 
    P2_deck[5].health = 0 

    P1_deck[3].health = 0
    P1_deck[9].health = 0 
    P1_deck[15].health = 0 
    P2_deck[3].health = 0
    P2_deck[9].health = 0 
    P2_deck[15].health = 0 
end

function CheckP1RowUpEmpty(x)
    if P1_deck[x+1] == nil and P1_deck[x+7] == nil and P1_deck[x+13] == nil then
    row = x+1
        for i=0,2,1 do
            if P1_deck[x] ~= nil then
                P1_deck[x].row = row
                P1_deck[x+1] = P1_deck[x]
                P1_deck[x+1].number = x+1
                P1_deck[x] = nil
                x = x + 6
            end
        end
    end
end

function CheckP2RowUpEmpty(x)
    if P2_deck[x+1] == nil and P2_deck[x+7] == nil and P2_deck[x+13] == nil then
    row = x+1
        for i=0,2,1 do
            if P2_deck[x] ~= nil then
                P2_deck[x].row = row
                P2_deck[x+1] = P2_deck[x]
                P2_deck[x+1].number = x+1
                P2_deck[x] = nil
                x = x + 6
            end
        end
    end
end

function CheckP1RowDownEmpty(x)
    if P1_deck[x+5] == nil and P1_deck[x+11] == nil and P1_deck[x+17] == nil then
    row = x-1
        for i=0,2,1 do
            if P1_deck[x] ~= nil then
                P1_deck[x].row = row
                P1_deck[x-1] = P1_deck[x]
                P1_deck[x-1].number = x-1
                P1_deck[x] = nil
                x = x + 6
            end
        end
    end
end

function CheckP2RowDownEmpty(x)
    if P2_deck[x+5] == nil and P2_deck[x+11] == nil and P2_deck[x+17] == nil then
    row = x-1
        for i=0,2,1 do
            if P2_deck[x] ~= nil then
                P2_deck[x].row = row
                P2_deck[x-1] = P2_deck[x]
                P2_deck[x-1].number = x-1
                P2_deck[x] = nil
                x = x + 6
            end
        end
    end
end

function GameState:update(dt)
    timer = timer + dt 
    timer2 = timer2 + dt
    if timer >= 1 then
        timer = timer - 1
        move = true
        P1_deck = next_round_P1_deck
        P2_deck = next_round_P2_deck
        if timer2 > 3 then
            CheckP1RowUpEmpty(1)
            CheckP1RowUpEmpty(0)
            CheckP2RowUpEmpty(1)
            CheckP2RowUpEmpty(0)
            CheckP1RowDownEmpty(4)
            CheckP1RowDownEmpty(5)
            CheckP2RowDownEmpty(4)
            CheckP2RowDownEmpty(5)
        end
    else
        move = false
    end
    for k, pair in pairs(P1_deck) do
        P1_deck[k]:update(dt,move)
    end 
    for k, pair in pairs(P2_deck) do
        P2_deck[k]:update(dt,move)
    end 
    if love.keyboard.wasPressed('m') then 
        if sounds['cool music']:isPlaying() then
            sounds['cool music']:pause()
        else
            sounds['cool music']:play()
        end
    end                   
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
end
