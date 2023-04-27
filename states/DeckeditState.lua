DeckeditState = Class{__includes = BaseState}

function DeckeditState:init()
    evolution = love.graphics.newImage('Graphics/Evolution.png')
    evolutionBig = love.graphics.newImage('Graphics/Evolution Big.png')
    evolutionMax = love.graphics.newImage('Graphics/Evolution Max.png')
    evolutionMaxBig = love.graphics.newImage('Graphics/Evolution Max Big.png')
    blankCard = love.graphics.newImage('Graphics/Blank Card.png')

    P1deckCards = bitser.loadLoveFile('Player 1 deck.txt')
    P1deck = {}
    cards = {}
    P1strength = 0
    self:sortInventory(false)
    self.cardsOnDisplay = {}
    self.page = 0
    self.cardsOnDisplayAreBlank = false
    self.subState = 'deck'
    self:reloadDeckeditor()

    background['Name'] = 'Death Star Control Room'
    background['Video'] = false
    createBackground()
    gui[1] = Button(function() gStateMachine:change('HomeState','music','music') end,'Main Menu',font80,nil,'centre',20)
    gui[2] = Button(function() self:resetDeck('strongest') end,'Auto',font80,nil,'centre',200)
    gui[3] = Button(function() self:resetDeck('blank') end,'Clear',font80,nil,'centre',380)
    gui['RemoveCard'] = RemoveCard()
    gui[22] = Button(function() self:updateCardsOnDisplay('left') end,nil,nil,'Left Arrow','centre left',1030,nil,nil,nil,nil,nil,true)
    gui[23] = Button(function() self:updateCardsOnDisplay('right') end,nil,nil,'Right Arrow','centre right',1030,nil,nil,nil,nil,nil,true)
end


function DeckeditState:sortInventory(reload)
    P1cards = {}
    count = 0

    if sandbox and reload == false then
        for k, pair in pairs(Characters) do
            if k ~= 'DarthNoscoper' then
                count = count + 1
                P1cards[count] = {k,60,4}
            end
        end

        for k, pair in pairs(P1deckCards) do
            for k2, pair2 in pairs(P1cards) do
                if pair[1] == pair2[1] then
                    for k=k2,#P1cards do
                        P1cards[k] = P1cards[k+1]
                    end
                    break
                end
            end
        end
    else
        for k, pair in pairs(bitser.loadLoveFile('Player 1 cards.txt')) do
            count = count + 1
            P1cards[count] = pair
        end
    end

    table.sort(P1cards,compareCharacterStrength)
    Temporary = {}
    for k, pair in pairs(P1cards) do
        Temporary[k-1] = pair
    end
    P1cards = Temporary
    Temporary = nil
    bitser.dumpLoveFile('Player 1 cards.txt',P1cards)
    if reload ~= false then
        self:updateCardsOnDisplay()
    end
end

function DeckeditState:updateCardsOnDisplay(direction,visible)
    if not (direction == 'left' and self.page == 0) and not (direction == 'right' and self.page > math.ceil((#P1cards+1)/18) - 2) then
        if direction == 'right' then
            self.page = self.page + 1
        elseif direction == 'left' then
            self.page = self.page - 1
        elseif type(direction) == "number" then
            self.page = direction
        end

        self.cardsOnDisplay = {}
        column = 9
        rowCorrectment = 0
        self.cardsOnDisplayAreBlank = true

        for i=0,17,1 do
            if i % 6 == 0 and i ~= 0 then
                column = 9 + i / 6
                rowCorrectment = i
            end
            row = i - rowCorrectment
            y = i+(self.page*18)
            if P1cards[y] ~= nil then
                self.cardsOnDisplay[i] = CardEditor(P1cards[y][1],row,column,y,P1cards[y][2],P1cards[y][3],false)
                self.cardsOnDisplayAreBlank = false
            else
                self.cardsOnDisplay[i] = CardEditor('Blank',row,column,y,nil,nil,false)
            end
        end
        column = nil
        rowCorrectment = nil
        if not visible then
            self:updateGui()
        end
    else
        return false
    end
end

function DeckeditState:reloadDeckeditor()
    P1column = 2
    rowCorrectment = 0
    P1strength = 0
    
    for i=0,17,1 do
        if i % 6 == 0 and i ~= 0 then
            P1column = 2 - i / 6 
            rowCorrectment = i
        end
        row = i - rowCorrectment
        if P1deckCards[i] ~= nil then
            if P1deckCards[i][1] ~= nil then
                P1deck[i] = CardEditor(P1deckCards[i][1],row,P1column,i,P1deckCards[i][2],P1deckCards[i][3],true)
                P1strength = P1strength + characterStrength({P1deckCards[i][1],P1deckCards[i][2],P1deckCards[i][3]})
            else
                P1deck[i] = CardEditor(P1deckCards[i],row,P1column,i,1,0,true)
                P1strength = P1strength + characterStrength(P1deckCards[i])
            end
        else
            P1deck[i] = CardEditor('Blank',row,P1column,i,nil,nil,true)
        end
    end
    P1column = nil
    rowCorrectment = nil
    self:updateCardsOnDisplay()
end

function DeckeditState:resetDeck(deck)
    count = 0
    sortedCharacters = {}
 
    for k, pair in pairs(P1deckCards) do
        if pair ~= 'Blank' then
            count = count + 1
            sortedCharacters[count] = pair
        end
    end
    for k, pair in pairs(P1cards) do
        count = count + 1
        sortedCharacters[count] = pair
    end

    P1deckCards = {}
    P1cards = {}

    table.sort(sortedCharacters,compareCharacterStrength)

    if deck == 'strongest' then
        for k, pair in ipairs(sortedCharacters) do
            if k-1 < 18 then
                P1deckEdit(k-1,pair)
            else
                P1cards[k-19] = pair
            end
        end
    elseif deck == 'blank' then
        for i = 0,18 do
            P1deckEdit(i,nil)
        end
        for k, pair in ipairs(sortedCharacters) do
            P1cards[k-1] = pair
        end
    end

    bitser.dumpLoveFile('Player 1 cards.txt',P1cards)
    self:reloadDeckeditor()
end

function DeckeditState:updateGui()
    for k, v in pairs(P1deck) do
        if k < 6 then
            gui[k+16] = v
        elseif k < 12 then
            gui[k+4] = v
        else
            gui[k-8] = v
        end
    end
    for k, v in pairs(self.cardsOnDisplay) do
        gui[k+24] = v
    end
    collectgarbage()
end

function DeckeditState:updateCardViewer(direction)
    if gui['CardViewer'].statsUpdated then
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
        if P1deck[self.cardDisplayedNumber].imageName == nil then
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
                if self.cardsOnDisplay[self.cardDisplayedNumber+1].imageName ~= nil then
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

function DeckeditState:enterStats(name,imageName,level,evolution,inDeck,number)
    self.subState = 'info'
    self.gui = gui
    gui = {}
    gui[2] = Button(function() gStateMachine:back() end,nil,font80,'X',1800,120)
    if sandbox then
        gui[7] = Button(function() self:updateCardViewer('left') end,nil,nil,'Left Arrow',58,1029,nil,nil,nil,nil,nil,true)
        gui[8] = Button(function() self:updateCardViewer('right') end,nil,nil,'Right Arrow',1920-58,1029,nil,nil,nil,nil,nil,true)
    else
        gui[3] = Button(function() self:updateCardViewer('left') end,nil,nil,'Left Arrow',58,1029,nil,nil,nil,nil,nil,true)
        gui[4] = Button(function() self:updateCardViewer('right') end,nil,nil,'Right Arrow',1920-58,1029,nil,nil,nil,nil,nil,true)
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
    if self.sort == true then
        self:sortInventory()
        self.sort = nil
    else
        self:updateGui()
    end
end

function DeckeditState:back()
    if self.subState == 'deck' then
        gStateMachine:change('HomeState','music','music')
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
                            elseif (k < 20 and k > 16) or (k == 20 and gui['RemoveCard'].visible == false) then
                                repositionMouse(k+8)
                            elseif k == 20 then
                                repositionMouse(gui['RemoveCard'])
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
                        if key == 'left' then
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
                            elseif (k < 28 and k > 24) or (k == 28 and gui['RemoveCard'].visible == false) then
                                repositionMouse(k-8) 
                            elseif k == 28 then
                                repositionMouse(gui['RemoveCard'])
                            elseif k == 29 then
                                repositionMouse(23)
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
                if mouseTouching == gui['RemoveCard'] then
                    if key == 'left' then
                        repositionMouse(20)
                    elseif key == 'right' then
                        repositionMouse(28)
                    end
                end
            else    
                for k, v in ipairs(gui) do
                    if v == mouseTouching then
                        if key == 'right' and k == 2 then
                            repositionMouse(3)
                        elseif key == 'left' and k == 3 then
                            repositionMouse(2)
                        end
                    end
                end
            end
        end
    end
end

function DeckeditState:update()
    if self.subState == 'deck' then
        self.left = 22
        self.right = 23
    elseif gui['CardViewer'].mode == 'stats' then
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
        love.graphics.setColor(1,1,1,1)
        love.graphics.setColor(1,1,1,1)
        love.graphics.print('Formation strength: ' .. tostring(math.floor(P1strength+0.5)),font50SW,VIRTUALWIDTH/2-font50SW:getWidth('Formation strength: ' .. math.floor(P1strength+0.5))/2,900)
    end
end

function DeckeditState:exit()
    P1deck = nil
    P1cards = nil
    cards = nil
    P1strength = nil
    evolution = nil
    evolutionBig = nil
    evolutionMax = nil
    evolutionBigMax = nil
    blankCard = nil
end