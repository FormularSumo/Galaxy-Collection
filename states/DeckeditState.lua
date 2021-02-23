DeckeditState = Class{__includes = BaseState}

function DeckeditState:init()
    read_P1_deck()
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
    background['Background']= love.graphics.newImage('Backgrounds/Death Star Control Room.jpg')
    background['Type'] = 'photo'
    gui['Main Menu'] = Button('return_to_main_menu','Main menu',font80,nil,'centre',110,1,1,1)
end

function DeckeditState:update()
end

function DeckeditState:render()
    if P1_deck ~= nil then
        for k, pair in pairs(P1_deck) do
            P1_deck[k]:render()
        end
    end
end

function DeckeditState:exit()
    exit_state()
end