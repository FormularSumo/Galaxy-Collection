DeckeditState = Class{__includes = BaseState}

function DeckeditState:enter()
    P1deck = {}
    self.images = {
        evolutionBig = love.graphics.newImage('Graphics/Evolution Big.png'), 
        evolutionMaxBig = love.graphics.newImage('Graphics/Evolution Max Big.png'),
        blankCard = love.graphics.newImage('Graphics/Blank Card.png')
    }
    self:loadCards()
    self.cardsOnDisplay = {}
    self.page = 0
    self.cardsOnDisplayAreBlank = false
    self.subState = 'deck'
    self:reloadDeck(true)
    self:updateCardsOnDisplay()

    background = backgroundInfo('Death Star Control Room')
    background = love.graphics.newImage(background)
    gui[1] = Button(function() gStateMachine:change('HomeState','music','music') end,'Main Menu',font70,nil,'centre',50)
    gui[2] = Button(function() self:resetDeck('strongest') end,'Auto',font80,nil,960-love.graphics.newText(font80,'Auto'):getWidth()/2-160,203)
    gui[3] = Button(function() self:resetDeck('blank') end,'Clear',font80,nil,960-love.graphics.newText(font80,'Clear'):getWidth()/2+160,203)
    gui[4] = Button(function() self:changeDeck('Player 1 deck.txt') end,'1',font80SWrunes,nil,960-love.graphics.newText(font80SWrunes,'1'):getWidth()/2-90,760)
    gui[5] = Button(function() self:changeDeck('Player 1 deck 2.txt') end,'2',font80SWrunes,nil,'centre',760)
    gui[6] = Button(function() self:changeDeck('Player 1 deck 3.txt') end,'3',font80SWrunes,nil,960-love.graphics.newText(font80SWrunes,'3'):getWidth()/2+90,760)
    gui['Deck'] = Text('Deck',font90SW,'centre',670)
    gui['RemoveCard'] = RemoveCard()
    gui[25] = Button(function() self:updateCardsOnDisplay('left') end,nil,nil,'Left Arrow','centre left',1030,nil,nil,nil,true)
    gui[26] = Button(function() self:updateCardsOnDisplay('right') end,nil,nil,'Right Arrow','centre right',1030,nil,nil,nil,true)
end


function DeckeditState:loadCards() --Initial card loading and sorting
    P1cards = {}
    local count = 0

    self.P1deckList = {}
    for k, pair in pairs(P1deckCards) do --Create list of cards already in deck
        self.P1deckList[pair[1]] = true
    end

    if sandbox then
        for k, pair in pairs(Characters) do
            count = count + 1
            P1cards[count] = {k,60,4}
        end
    else
        for k, pair in pairs(binser.readFile(Settings['active_deck'])) do
            count = count + 1
            P1cards[count] = pair
        end
    end

    local compare = compareCharacterStrength
    local cards = P1cards
    table.sort(cards,compare)
    local Temporary = {}
    for k, pair in pairs(cards) do
        Temporary[k-1] = pair
    end
    P1cards = Temporary
end

function DeckeditState:reloadDeck(partial) --Using the deck layout that's already been defined, create and store each of these cards in the relevant tables
    local P1column = 2
    local rowCorrectment = 0
    P1strength = 0
    
    for i=0,17,1 do
        if i % 6 == 0 and i ~= 0 then
            P1column = 2 - i / 6 
            rowCorrectment = i
        end
        row = i - rowCorrectment
        if P1deckCards[i] ~= nil then
            if P1deckCards[i][1] ~= nil then
                P1deck[i] = CardEditor(P1deckCards[i][1],row,P1column,i,P1deckCards[i][2],P1deckCards[i][3],true,self.images)
                P1strength = P1strength + characterStrength({P1deckCards[i][1],P1deckCards[i][2],P1deckCards[i][3]})
            else
                P1deck[i] = CardEditor(P1deckCards[i],row,P1column,i,1,0,true,self.images)
                P1strength = P1strength + characterStrength(P1deckCards[i])
            end
        else
            P1deck[i] = CardEditor('Blank',row,P1column,i,nil,nil,true,self.images)
        end
    end
    if not partial then
        self:updateGui()
    end
end

function DeckeditState:updateCardsOnDisplay(direction,visible) --Replace the cards which are currently displayed in the inventory with new ones
    if not (direction == 'left' and self.page == 0) and not (direction == 'right' and self.page > math.ceil((#P1cards+1)/18) - 2) then
        if direction == 'right' then
            self.page = self.page + 1
        elseif direction == 'left' then
            self.page = self.page - 1
        elseif type(direction) == "number" then
            self.page = direction
        end

        self.cardsOnDisplay = {}
        local column = 9
        local rowCorrectment = 0
        self.cardsOnDisplayAreBlank = true

        for i=0,17,1 do
            if i % 6 == 0 and i ~= 0 then
                column = 9 + i / 6
                rowCorrectment = i
            end
            row = i - rowCorrectment
            y = i+(self.page*18)
            if P1cards[y] ~= nil then
                self.cardsOnDisplay[i] = CardEditor(P1cards[y][1],row,column,y,P1cards[y][2],P1cards[y][3],false,self.images)
                self.cardsOnDisplayAreBlank = false
            else
                self.cardsOnDisplay[i] = CardEditor('Blank',row,column,y,nil,nil,false,self.images)
            end
        end

        if not visible then
            self:updateGui()
        end
    else
        return false
    end
end

function DeckeditState:resetDeck(deck) --Resets deck editor using one of the pre-defined buttons
    local count = 0
    local sortedCharacters = {}
 
    if not sandbox then
        for k, pair in pairs(P1deckCards) do
            if pair ~= 'Blank' then
                count = count + 1
                sortedCharacters[count] = pair
            end
        end
    end
    for k, pair in pairs(P1cards) do
        count = count + 1
        sortedCharacters[count] = pair
    end

    P1deckCards = {}
    if not sandbox then
        P1cards = {}
    end

    table.sort(sortedCharacters,compareCharacterStrength)

    if deck == 'strongest' then
        for k, pair in ipairs(sortedCharacters) do
            if k-1 < 18 then
                P1deckEdit(k-1,pair, true)
            elseif not sandbox then
                P1cards[k-19] = pair
            else
                break
            end
        end
    elseif deck == 'blank' then
        for i = 0,18 do
            P1deckEdit(i,nil,true)
        end
        if not sandbox then
            for k, pair in ipairs(sortedCharacters) do
                P1cards[k-1] = pair
            end
        end
    end
    love.filesystem.write(Settings['active_deck'],binser.s(P1deckCards))

    if not sandbox then
        love.filesystem.write('Player 1 cards.txt',binser.s(P1cards))
    end
    self:reloadDeck(partial)
    self:updateCardsOnDisplay()
end

function DeckeditState:changeDeck(deck) --Changes active deck to be 1, 2 or 3
    if Settings['active_deck'] ~= deck then --Don't change if this is the already active one
        Settings['active_deck'] = deck
        love.filesystem.write('Settings.txt',binser.s(Settings))
        P1deckCards = binser.d(love.filesystem.read(Settings['active_deck']))
        self:reloadDeck()
    end
end

function DeckeditState:updateGui() --Update GUI with cards so that they display+update correctly
    for k, v in pairs(P1deck) do
        if k < 6 then
            gui[k+19] = v
        elseif k < 12 then
            gui[k+7] = v
        else
            gui[k-5] = v
        end
    end
    for k, v in pairs(self.cardsOnDisplay) do
        gui[k+27] = v
    end
    collectgarbage()
end

function DeckeditState:updateCardViewer(direction) --Updates which card is selected in the Card Viewer, and changes the inventory page if necessary
    if gui['CardViewer'].statsUpdated then --If stats have been updated while the viewer is open, save them
        gui['CardViewer']:saveStats()
        gui['CardViewer'].statsUpdated = false
    end
    if self.cardDisplayedInDeck then
        if direction == 'right' then
            if self.cardDisplayedNumber == 17 then
                self.cardDisplayedNumber = 6
            elseif self.cardDisplayedNumber == 11 then
                self.cardDisplayedNumber = 0
            elseif self.cardDisplayedNumber == 5 then
                self.cardDisplayedNumber = 12
            else
                self.cardDisplayedNumber = self.cardDisplayedNumber + 1
            end
        elseif direction == 'left' then
            if self.cardDisplayedNumber == 6 then
                self.cardDisplayedNumber = 17
            elseif self.cardDisplayedNumber == 0 then
                self.cardDisplayedNumber = 11
            elseif self.cardDisplayedNumber == 12 then
                self.cardDisplayedNumber = 5
            else
                self.cardDisplayedNumber = self.cardDisplayedNumber -1
            end
        end
        if P1deck[self.cardDisplayedNumber].name == 'Blank' then
            self:updateCardViewer(direction)
        else
            P1deck[self.cardDisplayedNumber]:CardViewer()
        end
    else
        if direction == 'right' then
            if self.cardDisplayedNumber == 17 then
                if self:updateCardsOnDisplay('right',true) == false then
                    self:updateCardsOnDisplay(0,true)
                end
                self.cardsOnDisplay[0]:CardViewer()
            else
                if self.cardsOnDisplay[self.cardDisplayedNumber+1].name ~= 'Blank' then
                    self.cardsOnDisplay[self.cardDisplayedNumber+1]:CardViewer()
                else
                    self:updateCardsOnDisplay(0,true)
                    self.cardsOnDisplay[0]:CardViewer()
                end
            end
        else
            if self.cardDisplayedNumber == 0 then
                if self:updateCardsOnDisplay('left',true) == false then
                    self:updateCardsOnDisplay(math.ceil((#P1cards+1)/18) - 1,true)
                    self.cardsOnDisplay[#P1cards-self.page*18]:CardViewer()
                else
                    self.cardsOnDisplay[17]:CardViewer()
                end
            else
                self.cardsOnDisplay[self.cardDisplayedNumber-1]:CardViewer()
            end
        end
    end
end

function DeckeditState:enterStats()
    self.subState = 'info'
    self.gui = gui
    gui = {}
    gui[2] = Button(function() gStateMachine:back() end,nil,font80,'X',1800,120)
    if sandbox then
        gui[7] = Button(function() self:updateCardViewer('left') end,nil,nil,'Left Arrow',58,1029,nil,nil,nil,true)
        gui[8] = Button(function() self:updateCardViewer('right') end,nil,nil,'Right Arrow',1920-58,1029,nil,nil,nil,true)
    else
        gui[3] = Button(function() self:updateCardViewer('left') end,nil,nil,'Left Arrow',58,1029,nil,nil,nil,true)
        gui[4] = Button(function() self:updateCardViewer('right') end,nil,nil,'Right Arrow',1920-58,1029,nil,nil,nil,true)
    end
end

function DeckeditState:exitStats()
    if gui['CardViewer'].statsUpdated then
        gui['CardViewer']:saveStats()
    end
    self.subState = 'deck'
    for k, pair in pairs(gui) do
        gui[k] = nil
    end
    gui = self.gui
    self.gui = nil
    self:updateGui()
end

function DeckeditState:back()
    if self.subState == 'deck' then
        if mouseTrapped then
            mouseTrapped = false
        else
            gStateMachine:change('HomeState','music','music')
        end
    else
        self:exitStats()
    end
end

function DeckeditState:keypressed(key)
    if key == 'right' or key == 'left' or key == 'dpright' or key == 'dpleft' then
        if love.mouse.isVisible() or key == 'dpright' or key == 'dpleft' then
            if key == 'right' or key == 'dpright' then
                if self.subState == 'deck' then
                    self:updateCardsOnDisplay('right')
                else
                    self:updateCardViewer('right')
                end
            else
                if self.subState == 'deck' then
                    self:updateCardsOnDisplay('left')
                else
                    self:updateCardViewer('left')
                end
            end
        elseif key == 'right' or key == 'left' then
            if self.subState == 'deck' then
                for k, v in ipairs(gui) do
                    if v == mouseTouching then
                        if key == 'right' then
                            if k == 1 then
                                repositionMouse(27)
                            elseif k == 2 then
                                repositionMouse(3)
                            elseif k == 3 then
                                repositionMouse(28)
                            elseif k == 4 then
                                repositionMouse(5)
                            elseif k == 5 then
                                repositionMouse(6)
                            elseif k == 6 then
                                repositionMouse(31)
                            elseif k < 25 and k > 18 then
                                if not mouseTrapped then
                                    if k == 19 then
                                        repositionMouse(1)
                                    elseif k == 20 then
                                        repositionMouse(2)
                                    elseif k == 21 or k == 22 then
                                        repositionMouse(k+8)
                                    elseif k == 23 then
                                        repositionMouse(4)
                                    elseif k == 24 then
                                        repositionMouse(25)
                                    end
                                else
                                    if k == 22 and gui['RemoveCard'].visible == true then
                                        repositionMouse(gui['RemoveCard'])
                                    else
                                        repositionMouse(k+8)
                                    end
                                end
                            elseif k == 25 then
                                repositionMouse(26)
                            elseif k == 26 then
                                repositionMouse(32)
                            elseif gui[k+6] then
                                repositionMouse(k+6)
                            else
                                repositionMouse(mouseTouching.row+7)
                            end
                        end
                        if key == 'left' then
                            if k == 1 then
                                repositionMouse(19)
                            elseif k == 2 then
                                repositionMouse(20)
                            elseif k == 3 then
                                repositionMouse(2)
                            elseif k == 4 then
                                repositionMouse(23)
                            elseif k == 5 then
                                repositionMouse(4)
                            elseif k == 6 then
                                repositionMouse(5)
                            elseif (k < 33 and k > 26) then
                                if not mouseTrapped then
                                    if k == 27 then
                                        repositionMouse(1)
                                    elseif k == 28 then
                                        repositionMouse(3)
                                    elseif k == 29 or k == 30 then
                                        repositionMouse(k-8)
                                    elseif k == 31 then
                                        repositionMouse(6)
                                    elseif k == 32 then
                                        repositionMouse(26)
                                    end
                                else
                                    if k == 30 and gui['RemoveCard'].visible == true then
                                        repositionMouse(gui['RemoveCard'])
                                    else
                                        repositionMouse(k-8)
                                    end
                                end
                            elseif k == 26 then
                                repositionMouse(25)
                            elseif k == 25 then
                                repositionMouse(24)
                            elseif gui[k-6] and k - 6 > 6 then
                                repositionMouse(k-6)
                            else
                                repositionMouse(mouseTouching.row+27+12)
                            end
                        end
                        return
                    end
                end
                if mouseTouching == gui['RemoveCard'] then
                    if key == 'left' then
                        repositionMouse(22)
                    elseif key == 'right' then
                        repositionMouse(30)
                    end
                end
            else    
                for k, v in ipairs(gui) do
                    if v == mouseTouching then
                        if key == 'right' and k == 5 then
                            repositionMouse(6)
                        elseif key == 'left' and k == 6 then
                            repositionMouse(5)
                        end
                    end
                end
            end
        end
    end
end

function DeckeditState:update()
    if self.subState == 'deck' then
        self.left = 25
        self.right = 26
    elseif gui['CardViewer'].mode == 'stats' and sandbox then
        self.left = 7
        self.right = 8
    else
        self.left = 3
        self.right = 4
    end
    if love.mouse.isVisible() then
        mouseLocked = false
        if keyHoldtimer ~= 0 then
            if love.keyboard.wasDown('right') and lastPressed == 'right' then
                gui[self.right].scaling = 1.05
            end
            if love.keyboard.wasDown('left') and lastPressed == 'left' then
                gui[self.left].scaling = 1.05
            end
        end
    end
    if keyHoldTimer ~= 0 then
        if love.keyboard.wasDown('dpright') and lastPressed == 'dpright' then
            gui[self.right].scaling = 1.05
        end
        if love.keyboard.wasDown('dpleft') and lastPressed == 'dpleft' then
            gui[self.left].scaling = 1.05
        end
    end
end

function DeckeditState:renderBackground()
    if self.subState == 'info' then
        love.graphics.setColor(0,0,0,0.5)
        love.graphics.rectangle('fill',50,50,1820,980,20)
        love.graphics.setColor(1,1,1,1)
        love.graphics.rectangle('line',50,50,1820,980,20)
        love.graphics.rectangle('line',51,51,1818,978,20)
        love.graphics.rectangle('line',52,52,1816,976,20)
        love.graphics.setColor(1,1,1,1)
    end
end

function DeckeditState:renderForeground()
    if self.subState == 'deck' then
        love.graphics.setColor(0,0,0,0.4)
        love.graphics.rectangle('fill',VIRTUALWIDTH/2-font50SW:getWidth('Formation strength: ' .. math.floor(P1strength+0.5))/2-20,890,font50SW:getWidth('Formation strength: ' .. math.floor(P1strength+0.5))+40,69,20)
        love.graphics.setColor(0,0,0,0.6)
        love.graphics.rectangle('fill',VIRTUALWIDTH/2-font80SWrunes:getWidth('123')/2-52,660,font80SWrunes:getWidth('123')+93,190,35,25)
        love.graphics.setColor(1,1,1,0.2)
        love.graphics.rectangle('line',VIRTUALWIDTH/2-font80SWrunes:getWidth('123')/2-52,660,font80SWrunes:getWidth('123')+93,190,35,25)
        love.graphics.setColor(1,1,1,1)
        love.graphics.print('Formation strength: ' .. tostring(math.floor(P1strength+0.5)),font50SW,VIRTUALWIDTH/2-font50SW:getWidth('Formation strength: ' .. math.floor(P1strength+0.5))/2,900)
    end
end

function DeckeditState:exit()
    P1deck = nil
    P1cards = nil
    P1strength = nil
end