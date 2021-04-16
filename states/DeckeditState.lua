DeckeditState = Class{__includes = BaseState}

function DeckeditState:init()
    P1_deck_cards = bitser.loadLoveFile('Player 1 deck.txt')
    P1_deck = {}
    P1_cards = bitser.loadLoveFile('Player 1 cards.txt')
    Cards_on_display = {}
    Evolution = love.graphics.newImage('Graphics/Evolution.png')
    EvolutionMax = love.graphics.newImage('Graphics/EvolutionMax.png')

    P1column = 2
    row_correctment = 0
    
    for i=0,17,1 do
        if i % 6 == 0 and i ~= 0 then
            P1column = 2 - i / 6 
            row_correctment = i
        end
        row = i - row_correctment
        if P1_deck_cards[i] ~= nil then
            if P1_deck_cards[i][1] ~= nil then
                P1_deck[i] = Card_editor(P1_deck_cards[i][1],row,P1column,i,P1_deck_cards[i][2],P1_deck_cards[i][3])
            else
                P1_deck[i] = Card_editor(P1_deck_cards[i],row,P1column,i)
            end
        end
    end

    -- for i=0,17,1 do
    --     if i % 6 == 0 and i ~= 0 then
    --         P1column = 2 - i / 6 
    --         row_correctment = i
    --     end
    --     row = i - row_correctment
    --     if P1_cards[i] ~= nil then
    --         if P1_cards[i][1] ~= nil then
    --             Cards_on_display[i] = Card_editor(P1_cards[i][1],row,P1column,i,P1_cards[i][2],P1_cards[i][3])
    --         else
    --             Cards_on_display[i] = Card_editor(P1_cards[i],row,P1column,i)
    --         end
    --     end
    -- end


    background['Background'] = love.graphics.newImage('Backgrounds/Death Star Control Room.jpg')
    background['Type'] = 'photo'
    gui['Main Menu'] = Button('switch_state',{'HomeState','music','music'},'Main Menu',font80,nil,'centre',100)
end

function DeckeditState:update()
    for k, pair in pairs(P1_deck) do
        P1_deck[k]:update()
    end
    -- for k, pair in pairs(Cards_on_display) do
    --     Cards_on_display[k]:update()
    -- end
end

function DeckeditState:render()
    if P1_deck ~= nil then
        for k, pair in pairs(P1_deck) do
            P1_deck[k]:render()
        end
    end
    -- if Cards_on_display ~= nil then
    --     for k, pair in pairs(Cards_on_display) do
    --         Cards_on_display[k]:render()
    --     end
    --     for k, pair in pairs(Cards_on_display) do
    --         love.graphics.print(tostring(Cards_on_display[k].y))
    --     end
    -- end
    -- love.graphics.print(P1_cards[0][1])
end

function DeckeditState:exit(partial)
    P1_deck = nil
    Cards_on_display = nil
    Evolution = nil
    EvolutionMax = nil
    exit_state(partial)
end