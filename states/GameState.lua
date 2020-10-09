GameState = Class{__includes = BaseState}


function GameState:init()
    P1_deck[0] = Card('AhsokaS7',0,2)
    P1_deck[1] = Card('AnakinF3',1,2)
    P1_deck[2] = Card('BabyYoda',2,2)
    P1_deck[3] = Card('BenKenobi',3,2)
    P1_deck[4] = Card('C3P0',4,2)
    P1_deck[5] = Card('Chewbacca',5,2)
    P1_deck[6] = Card('DarthSidiousReborn',0,1)
    P1_deck[7] = Card('DarthVader',1,1)
    P1_deck[8] = Card('Ewok',2,1)
    P1_deck[9] = Card('FarmboyLuke',3,1)
    P1_deck[10] = Card('HanSoloOld',4,1)
    P1_deck[11] = Card('Hondo',5,1)
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
