GameState = Class{__includes = BaseState}
timer = -1

function GameState:init()
    sounds['Imperial March piano only']:pause()
    sounds['Imperial March duet']:pause()
    sounds['cool music']:play()
    P1column = 0
    P2column = 11
    row_correctment = 0
    for i=0,17,1 do
        if i % 6 == 0 and i ~= 0 then
            P1column = 0 - i / 6 
            P2column = 11 + i / 6 
            row_correctment = i
        end
        row = i - row_correctment
        if P1_deck_cards[i] ~= none then
            P1_deck[i] = Card(P1_deck_cards[i],row,P1column,1,i)
        end
        if P2_deck_cards[i] ~= none then
            P2_deck[i] = Card(P2_deck_cards[i],row,P2column,2,i)
        end
    next_round_P1_deck = P1_deck
    end
    P1_deck[4].health = 0
end

function GameState:update(dt)
    timer = timer + dt 
    if timer >= 1 then
        timer = timer - 1
        move = true
        P1_deck = next_round_P1_deck
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
    love.graphics.draw(desert_background)
    for k, pair in pairs(P1_deck) do
        P1_deck[k]:render()
    end
    for k, pair in pairs(P2_deck) do
        P2_deck[k]:render()
    end
end
