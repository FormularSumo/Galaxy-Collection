DeckeditState = Class{__includes = BaseState}

function DeckeditState:init()
    P1_deck_cards = bitser.loadLoveFile('Player 1 deck.txt')
    P1_deck = {}
    Cards = {}
    sort_inventory(false)

    Cards_on_display = {}
    Evolution = love.graphics.newImage('Graphics/Evolution.png')
    EvolutionMax = love.graphics.newImage('Graphics/Evolution Max.png')
    BlankCard = love.graphics.newImage('Graphics/Blank Card.png')
    page = 0
    Cards_on_display_are_blank = false

    reload_deckeditor()

    background['Background'] = love.graphics.newImage('Backgrounds/Death Star Control Room.jpg')
    background['Type'] = 'photo'
    gui[1] = Button('switchState',{'HomeState','music','music'},'Main Menu',font80,nil,'centre',20)
    gui[2] = Button('reset_deck','strongest','Auto',font80,nil,'centre',200)
    gui[3] = Button('reset_deck','blank','Clear',font80,nil,'centre',380)
    gui['Remove_card'] = Remove_card()
    gui[22] = Button('update_cards_on_display','left',nil,nil,'Left Arrow','centre_left',1030)
    gui[23] = Button('update_cards_on_display','right',nil,nil,'Right Arrow','centre_right',1030)
end


function sort_inventory(reload)
    P1_cards = {}
    count = 0

    if sandbox then
        for k, pair in pairs(Characters) do
            if k ~= 'DarthNoscoper' then
                count = count + 1
                P1_cards[count] = {k,60,4}
            end
        end

        for k, pair in pairs(P1_deck_cards) do
            for k2, pair2 in pairs(P1_cards) do
                if pair[1] == pair2[1] then
                    P1_cards[k2] = nil
                    count = 0
                    for k, pair in pairs(P1_cards) do
                        count = count + 1
                        P1_cards[count] = pair
                    end
                    P1_cards[#P1_cards] = nil
                    break
                end
            end
        end
    else
        Unsorted = bitser.loadLoveFile('Player 1 cards.txt')
    
        for k, pair in pairs(Unsorted) do
            count = count + 1
            P1_cards[count] = pair
        end
        Unsorted = nil
    end

    table.sort(P1_cards,compareCharacterStrength)
    for k, pair in pairs(P1_cards) do
        P1_cards[k-1] = pair
    end
    P1_cards[#P1_cards] = nil
    bitser.dumpLoveFile('Player 1 cards.txt',P1_cards)
    if reload ~= false then
        update_cards_on_display()
    end
end

function update_cards_on_display(direction)
    if not (direction == 'left' and page == 0) and not (direction == 'right' and page > math.ceil((#P1_cards+1)/18) - 2) then
        if direction == 'right' then
            page = page + 1
        elseif direction == 'left' then
            page = page - 1
        end

        Cards_on_display = {}
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
                Cards_on_display[i] = Card_editor(P1_cards[y][1],row,column,y,P1_cards[y][2],P1_cards[y][3],false)
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

function reload_deckeditor()
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
end

function reset_deck(deck)
    count = 0
    Sorted_characters = {}
 
    for k, pair in pairs(P1_deck_cards) do
        if pair ~= 'Blank' then
            count = count + 1
            Sorted_characters[count] = pair
        end
    end
    for k, pair in pairs(P1_cards) do
        count = count + 1
        Sorted_characters[count] = pair
    end

    P1_deck_cards = {}
    P1_cards = {}

    table.sort(Sorted_characters,compareCharacterStrength)
    count = -1

    if deck == 'strongest' then
        for k, pair in ipairs(Sorted_characters) do
            count = count + 1
            if count < 18 then
                P1_deck_edit(count,pair)
            else
                P1_cards[count-18] = pair
            end
        end
    elseif deck == 'blank' then
        for i = 0,18 do
            P1_deck_edit(i,nil)
        end
        for k, pair in ipairs(Sorted_characters) do
            count = count + 1
            P1_cards[count] = pair
        end
    end

    bitser.dumpLoveFile('Player 1 cards.txt',P1_cards)
    reload_deckeditor()
end

function update_gui()
    for k, v in pairs(P1_deck) do
        if k < 6 then
            gui[k+16] = v
        elseif k < 12 then
            gui[k+4] = v
        else
            gui[k-8] = v
        end
    end
    for k, v in pairs(Cards_on_display) do
        gui[k+24] = v
    end
    collectgarbage()
end

function DeckeditState:back()
    gStateMachine:change('HomeState','music','music')
end

function DeckeditState:update()
    if love.mouse.isVisible() then mouseLocked = false end
    if love.keyboard.wasPressed('right') or love.keyboard.wasPressed('left') or love.keyboard.wasPressed('dpright') or love.keyboard.wasPressed('dpleft') then
        if love.mouse.isVisible() or love.keyboard.wasPressed('dpright') or love.keyboard.wasPressed('dpleft') then
            if love.keyboard.wasPressed('right') or love.keyboard.wasPressed('dpright') then
                update_cards_on_display('right')
            else
                update_cards_on_display('left')
            end
        elseif love.keyboard.wasPressed('right') or love.keyboard.wasPressed('left') then
            for k, v in ipairs(gui) do
                if v == mouseTouching then
                    if love.keyboard.wasPressed('right') then
                        if k == 1 then
                            repositionMouse(24)
                        elseif k == 2 then
                            repositionMouse(25)
                        elseif k == 3 then
                            repositionMouse(26)   
                        elseif k == 16 then
                            repositionMouse(1)
                        elseif k == 17 then
                            repositionMouse(2)
                        elseif k == 18 then
                            repositionMouse(3)
                        elseif (k < 20 and k > 16) or (k == 20 and gui['Remove_card'].visible == false) then
                            repositionMouse(k+8)
                        elseif k == 20 then
                            repositionMouse(gui['Remove_card'])
                        elseif k == 21 then
                            repositionMouse(22)
                        elseif k == 22 then
                            repositionMouse(23)
                        elseif k == 23 then
                            repositionMouse(29)
                        elseif gui[k+6] then
                            repositionMouse(k+6)
                        else
                            repositionMouse(mouseTouching.row+4)
                        end
                    end
                    if love.keyboard.wasPressed('left') then
                        if k == 1 then
                            repositionMouse(16)
                        elseif k == 2 then
                            repositionMouse(17)
                        elseif k == 3 then
                            repositionMouse(18)
                        elseif k == 24 then
                            repositionMouse(1)
                        elseif k == 25 then
                            repositionMouse(2)
                        elseif k == 26 then
                            repositionMouse(3)
                        elseif (k < 28 and k > 24) or (k == 28 and gui['Remove_card'].visible == false) then
                            repositionMouse(k-8) 
                        elseif k == 28 then
                            repositionMouse(gui['Remove_card'])
                        elseif k == 29 then
                            repositionMouse(22)
                        elseif k == 23 then
                            repositionMouse(22)
                        elseif k == 22 then
                            repositionMouse(21)
                        elseif gui[k-6] and k - 6 ~= 1 then
                            repositionMouse(k-6)
                        else
                            repositionMouse(mouseTouching.row+24+12)
                        end
                    end
                    return
                end
            end
            if mouseTouching == gui['Remove_card'] then
                if love.keyboard.wasPressed('left') then
                    repositionMouse(20)
                elseif love.keyboard.wasPressed('right') then
                    repositionMouse(28)
                end
            end
        end
    end
end

function DeckeditState:exit(partial)
    P1_deck = nil
    P1_cards = nil
    Cards = nil
    Cards_on_display = nil
    Evolution = nil
    EvolutionMax = nil
    BlankCard = nil
    page = nil
    Cards_on_display_are_blank = nil
    exitState(partial)
end