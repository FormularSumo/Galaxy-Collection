GameState = Class{__includes = BaseState}


function GameState:init()
    P1_deck[0] = Card('AhsokaS7',4,0)
    P1_deck[1] = Card('AnakinF3',4,1)
    P1_deck[2] = Card('BabyYoda',4,2)
    P1_deck[3] = Card('BenKenobi',4,3)
    P1_deck[4] = Card('C3P0',4,4)
    P1_deck[5] = Card('DarthVader',4,5)
    sounds['Imperial March piano only']:pause()
    sounds['cool music']:play()
end

function GameState:update(dt)
    for k, pair in pairs(P1_deck) do
        P1_deck[k]:update()
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
end
