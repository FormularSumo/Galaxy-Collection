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

    if sandbox then
        for k, pair in pairs(Characters) do
            if k ~= 'DarthNoscoper' then
                count = count + 1
                P1cards[count] = {k,60,4}
            end
        end

        for k, pair in pairs(P1deckCards) do
            for k2, pair2 in pairs(P1cards) do
                if pair[1] == pair2[1] then
                    P1cards[k2] = nil
                    count = 0
                    for k, pair in pairs(P1cards) do
                        count = count + 1
                        P1cards[count] = pair
                    end
                    P1cards[#P1cards] = nil
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
    for k, pair in pairs(P1cards) do
        P1cards[k-1] = pair
    end
    P1cards[#P1cards] = nil
    bitser.dumpLoveFile('Player 1 cards.txt',P1cards)
    if reload ~= false then
        self:updateCardsOnDisplay()
    end
end

function DeckeditState:updateCardsOnDisplay(direction)
    if not (direction == 'left' and self.page == 0) and not (direction == 'right' and self.page > math.ceil((#P1cards+1)/18) - 2) then
        if direction == 'right' then
            self.page = self.page + 1
        elseif direction == 'left' then
            self.page = self.page - 1
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
        self:updateGui()
    end
end

function DeckeditState:reloadDeckeditor()
    P1column = 2
    rowCorrectment = 0
    
    for i=0,17,1 do
        if i % 6 == 0 and i ~= 0 then
            P1column = 2 - i / 6 
            rowCorrectment = i
        end
        row = i - rowCorrectment
        if P1deckCards[i] ~= nil then
            if P1deckCards[i][1] ~= nil then
                P1deck[i] = CardEditor(P1deckCards[i][1],row,P1column,i,P1deckCards[i][2],P1deckCards[i][3],true)
            else
                P1deck[i] = CardEditor(P1deckCards[i],row,P1column,i,1,0,true)
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
    count = -1

    if deck == 'strongest' then
        for k, pair in ipairs(sortedCharacters) do
            count = count + 1
            if count < 18 then
                P1deckEdit(count,pair)
            else
                P1cards[count-18] = pair
            end
        end
    elseif deck == 'blank' then
        for i = 0,18 do
            P1deckEdit(i,nil)
        end
        for k, pair in ipairs(sortedCharacters) do
            count = count + 1
            P1cards[count] = pair
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

function DeckeditState:stats(name,imageName,level,evolution,inDeck)
    self.subState = 'info'
    self.gui = gui
    gui = {}
    gui[1] = Button(function() gStateMachine:back() end,nil,font80,'X',1800,120)

    self.cardDisplayed = love.graphics.newImage(imageName .. '.jpg')
    self.evolution = evolution
    self.modifier = ((level + (60 - level) / 1.7) / 60) * (1 - ((4 - evolution) * 0.1))
    self.y = 30

    self:createStat(level,'Level')
    self:createStat(math.floor(Characters[name]['meleeOffense'] * self.modifier),'Melee Offense')
    if Characters[name].range > 1 then
        self:createStat(math.floor(Characters[name]['rangedOffense'] * self.modifier),'Ranged Offense')
    end
    self:createStat(math.floor(Characters[name]['defense'] * self.modifier),'Defense')
    self:createStat(Characters[name]['evade'],'Evade')
    self:createStat(Characters[name]['range'],'Range')

    if Characters[name].weaponCount then
        self.weapons = {}
        self.weapons[Characters[name]['weapon1']] = 1
        for i=2,Characters[name]['weaponCount'] do
            if Characters[name]['weapon'..tostring(i)] then
                if self.weapons[Characters[name]['weapon'..tostring(i)]] then
                    self.weapons[Characters[name]['weapon'..tostring(i)]] = self.weapons[Characters[name]['weapon'..tostring(i)]] + 1
                else
                    self.weapons[Characters[name]['weapon'..tostring(i)]] = 1
                end
            else
                self.weapons[Characters[name]['weapon1']] = self.weapons[Characters[name]['weapon1']] + 1
            end
        end
        self:createStat(nil,'weapons:')
        for k, pair in pairs(self.weapons) do
            self:createStat(k,pair .. 'x','weapon' .. k)
        end
    elseif Characters[name]['weapon1'] then
        self:createStat(Characters[name]['weapon1'],'weapon')
    end

    if Characters[name].projectileCount then
        self.projectiles = {}
        self.projectiles[Characters[name]['projectile1']] = 1
        for i=2,Characters[name]['projectileCount'] do
            if Characters[name]['projectile'..tostring(i)] then
                if self.projectiles[Characters[name]['projectile'..tostring(i)]] then
                    self.projectiles[Characters[name]['projectile'..tostring(i)]] = self.projectiles[Characters[name]['projectile'..tostring(i)]] + 1
                else
                    self.projectiles[Characters[name]['projectile'..tostring(i)]] = 1
                end
            else
                self.projectiles[Characters[name]['projectile1']] = self.projectiles[Characters[name]['projectile1']] + 1
            end
        end
        self:createStat(nil,'Projectiles:')
        for k, pair in pairs(self.projectiles) do
            self:createStat(k,pair .. 'x','projectile' .. k)
        end
    elseif Characters[name]['projectile1'] then
        self:createStat(Characters[name]['projectile1'],'Projectile')
    end
end

function DeckeditState:createStat(stat, displayName, name)
    if name == nil then name = displayName end
    self.y = self.y + 80
    if stat then
        gui[name] = Text(displayName .. ': ' .. stat,font60SW,'centre',self.y)
    else
        gui[name] = Text(displayName,font60SW,'centre',self.y)
    end
    gui[name].x = gui[name].x + 350
end

function DeckeditState:exitStats()
    self.subState = 'deck'
    for k, pair in pairs(gui) do
        gui[k] = nil
    end
    gui = self.gui
    collectgarbage()
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
                self:updateCardsOnDisplay('right')
            else
                self:updateCardsOnDisplay('left')
            end
        elseif key == 'right' or key == 'left' then
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
        end
    end
end

function DeckeditState:update()
    if love.mouse.isVisible() then
        mouseLocked = false
        if keyHoldtimer ~= 0 then
            if love.keyboard.wasDown('right') and lastPressed == 'right' then
                gui[23].scaling = 1.05
            end
            if love.keyboard.wasDown('left') and lastPressed == 'left' then
                gui[22].scaling = 1.05
            end
        end
    end
    if keyHoldTimer ~= 0 then
        if love.keyboard.wasDown('dpright') and lastPressed == 'dpright' then
            gui[23].scaling = 1.05
        end
        if love.keyboard.wasDown('dpleft') and lastPressed == 'dpleft' then
            gui[22].scaling = 1.05
        end
    end
end

function DeckeditState:renderBackground()
    if self.subState == 'info' then
        love.graphics.setColor(0,0,0,0.4)
        love.graphics.rectangle('fill',50,50,1820,980,20)
        love.graphics.setColor(1,1,1,0.3)
        love.graphics.rectangle('line',50,50,1820,980,20)
        love.graphics.rectangle('line',51,51,1819,979,20)
        love.graphics.rectangle('line',52,52,1818,978,20)
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(self.cardDisplayed,90,90)
        if self.evolution == 4 then
            love.graphics.draw(evolutionMaxBig,690-evolutionMaxBig:getWidth()-12,90+12)
        elseif self.evolution > 0 then
            love.graphics.draw(evolutionBig,690-evolutionBig:getHeight()-4,90+12,math.rad(90))
            if self.evolution > 1 then
                love.graphics.draw(evolutionBig,690-evolutionBig:getHeight()*2-7,90+12,math.rad(90))
                if self.evolution > 2 then
                    love.graphics.draw(evolutionBig,690-evolutionBig:getHeight()*3-10,90+12,math.rad(90))
                end
            end
        end
    end
end

function DeckeditState:exit()
    P1deck = nil
    P1cards = nil
    cards = nil
    evolution = nil
    evolutionBig = nil
    evolutionMax = nil
    evolutionBigMax = nil
    blankCard = nil
end