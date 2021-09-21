DeckeditState = Class{__includes = BaseState}

function DeckeditState:init()
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
    gui[1] = Button('switch_state',{'HomeState','music','music'},'Main Menu',font80,nil,'centre',100)
    gui[20] = Button('update_cards_on_display','left',nil,nil,'LeftArrow','centre_left',1040)
    gui[21] = Button('update_cards_on_display','right',nil,nil,'RightArrow','centre_right',1040)
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
        update_gui()
    end
end

function update_gui()
    for k, v in pairs(P1_deck) do
        if k < 6 then
            gui[k+14] = v
        elseif k < 12 then
            gui[k+2] = v
        else
            gui[k-10] = v
        end
    end
    for k, v in pairs(Cards_on_display) do
        gui[k+22] = v
    end
end

function DeckeditState:back()
    gStateMachine:change('HomeState','music','music')
end

function DeckeditState:update()
    if love.keyboard.wasPressed('right') or love.keyboard.wasPressed('left') then
        if mouseTouching == false then
            if love.keyboard.wasPressed('right') then
                update_cards_on_display('right')
            else
                update_cards_on_display('left')
            end
        else
            for k, v in ipairs(gui) do
                if v == mouseTouching then
                    if love.keyboard.wasPressed('right') then
                        if k == 1 then
                            reposition_mouse(22)
                        elseif k == 14 then
                            reposition_mouse(1)
                        elseif k < 19 and k > 14 then
                            reposition_mouse(k+8) 
                        elseif k == 19 then
                            reposition_mouse(20)
                        elseif k == 20 then
                            reposition_mouse(21)
                        elseif k == 21 then
                            reposition_mouse(27)
                        elseif gui[k+6] then
                            reposition_mouse(k+6)
                        else
                            reposition_mouse(mouseTouching.row+2)
                        end
                    end
                    if love.keyboard.wasPressed('left') then
                        if k == 1 then
                            reposition_mouse(14)
                        elseif k == 22 then
                            reposition_mouse(1)
                        elseif k < 27 and k > 22 then
                            reposition_mouse(k-8) 
                        elseif k == 27 then
                            reposition_mouse(21)
                        elseif k == 21 then
                            reposition_mouse(20)
                        elseif k == 20 then
                            reposition_mouse(19)
                        elseif gui[k-6] and k - 6 ~= 1 then
                            reposition_mouse(k-6)
                        else
                            reposition_mouse(mouseTouching.row+22+12)
                        end
                    end
                    break
                end
            end
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