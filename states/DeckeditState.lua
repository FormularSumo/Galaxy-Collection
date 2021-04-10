DeckeditState = Class{__includes = BaseState}

function DeckeditState:init()
    P1_deck_cards = bitser.loadLoveFile('Player 1 deck.txt')
    P1_deck = {}

    P1column = 2
    row_correctment = 0
    
    for i=0,17,1 do
        if i % 6 == 0 and i ~= 0 then
            P1column = 2 - i / 6 
            row_correctment = i
        end
        row = i - row_correctment
        if P1_deck_cards[i] ~= none then
            P1_deck[i] = Card_editor(P1_deck_cards[i],row,P1column,i)
        end
    end
    background['Background'] = love.graphics.newImage('Backgrounds/Death Star Control Room.jpg')
    background['Type'] = 'photo'
    gui['Main Menu'] = Button('switch_state',{'HomeState','music','music'},'Main Menu',font80,nil,'centre',100)
end

function DeckeditState:update()
    for k, pair in pairs(P1_deck) do
        P1_deck[k]:update()
    end
end

function DeckeditState:render()
    if P1_deck ~= nil then
        for k, pair in pairs(P1_deck) do
            P1_deck[k]:render()
        end
    end
end

function DeckeditState:exit(partial)
    exit_state(partial)
end