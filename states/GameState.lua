GameState = Class{__includes = BaseState}


function GameState:init()
    P1column = 5
    P2column = 6
    row_correctment = 0
    for i=0,17,1 do
        if i % 6 == 0 and i ~= 0 then
            P1column = 5 - i / 6 
            P2column = 6 + i / 6 
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
    sounds['Imperial March piano only']:pause()
    sounds['cool music']:play()
end

function GameState:update(dt)
    for k, pair in pairs(P1_deck) do
        P1_deck[k]:update()
    end 
    for k, pair in pairs(P2_deck) do
        P2_deck[k]:update()
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
    -- love.graphics.print(_G[P2_deck_cards], 100, 100)
end
