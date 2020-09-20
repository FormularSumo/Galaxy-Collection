GameState = Class{__includes = BaseState}


function GameState:init()
    P1_deck[0] = Card('AhsokaS7',4,0)
    P1_deck[1] = Card('AnakinF3',4,1)
    -- P1_deck[2] = Card('BabyYoda',4,2)
end

function GameState:update(dt)
    for k, pair in pairs(P1_deck) do
        P1_deck[k]:update()
    end
end

function GameState:render()
    for k, pair in pairs(P1_deck) do
        P1_deck[k]:render()
    end
end