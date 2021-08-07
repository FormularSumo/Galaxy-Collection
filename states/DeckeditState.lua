DeckeditState = Class{__includes = BaseState}

function DeckeditState:init()
    backstate = {'HomeState','music','music'}
    P1_deck_cards = bitser.loadLoveFile('Player 1 deck.txt')
    P1_deck = {}
    P1_cards = bitser.loadLoveFile('Player 1 cards.txt')
    Cards_on_display = {}
    Evolution = love.graphics.newImage('Graphics/Evolution.png')
    EvolutionMax = love.graphics.newImage('Graphics/EvolutionMax.png')
    BlankCard = love.graphics.newImage('Graphics/BlankCard.png')
    page = 0
    Cards_on_display_are_blank = false

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
                P1_deck[i] = Card_editor(P1_deck_cards[i][1],row,P1column,i,P1_deck_cards[i][2],P1_deck_cards[i][3],true)
            else
                P1_deck[i] = Card_editor(P1_deck_cards[i],row,P1column,i,1,0,true)
            end
        else
            P1_deck[i] = Card_editor('Blank',row,P1column,i,nil,nil,true)
        end
    end
    P1column = nil
    row_correctment = nil

    update_cards_on_display()

    background['Background'] = love.graphics.newImage('Backgrounds/Death Star Control Room.jpg')
    background['Type'] = 'photo'
    gui['Main Menu'] = Button('back',nil,'Main Menu',font80,nil,'centre',100)
    gui['Right Arrow'] = Button('update_cards_on_display','right',nil,nil,'RightArrow','centre_right',1040)
    gui['Left Arrow'] = Button('update_cards_on_display','left',nil,nil,'LeftArrow','centre_left',1040)
end

function update_cards_on_display(direction)
    if not (direction == 'left' and page == -1 and Cards_on_display_are_blank) and not (direction == 'right' and page > 0 and Cards_on_display_are_blank) then
        if direction == 'right' then
            page = page + 1
        elseif direction == 'left' then
            page = page - 1
        end

        Cards_on_display = {}
        collectgarbage()
        column = 9
        row_correctment = 0
        Cards_on_display_are_blank = true

        for i=0,17,1 do
            if i % 6 == 0 and i ~= 0 then
                column = 9 + i / 6
                row_correctment = i
            end
            row = i - row_correctment
            y = i+(page*18)
            if P1_cards[y] ~= nil then
                if P1_cards[y][1] ~= nil then
                    Cards_on_display[i] = Card_editor(P1_cards[y][1],row,column,y,P1_cards[y][2],P1_cards[y][3],false)
                else
                    Cards_on_display[i] = Card_editor(P1_cards[y],row,column,y,1,0,false)
                end
                Cards_on_display_are_blank = false
            else
                Cards_on_display[i] = Card_editor('Blank',row,column,y,nil,nil,false)
            end
        end
        column = nil
        row_correctment = nil
    end
end

function DeckeditState:update()
    for k, pair in pairs(P1_deck) do
        P1_deck[k]:update()
    end
    for k, pair in pairs(Cards_on_display) do
        Cards_on_display[k]:update()
    end
    if love.keyboard.wasPressed('right') then
        update_cards_on_display('right')
    end
    if love.keyboard.wasPressed('left') then
        update_cards_on_display('left')
    end
end

function DeckeditState:render()
    if P1_deck ~= nil then
        for k, pair in pairs(P1_deck) do
            P1_deck[k]:render()
        end
    end
    if Cards_on_display ~= nil then
        for k, pair in pairs(Cards_on_display) do
            Cards_on_display[k]:render()
        end
    end
end

function DeckeditState:exit(partial)
    P1_deck = nil
    Cards_on_display = nil
    Evolution = nil
    EvolutionMax = nil
    BlankCard = nil
    page = nil
    Cards_on_display_are_blank = nil
    exit_state(partial)
end