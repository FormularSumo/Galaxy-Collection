CardEditor = Class{__includes = BaseState}

function CardEditor:init(name,row,column,number,level,evolution,inDeck,graphics,imagesInfo,imagesIndexes)
    self.name = name
    self.row = row
    self.column = column
    self.scaling = 1
    self.width,self.height = 115,173 --Shouldn't really be hardcoded, but no cards have been loaded at this point so there's not much alternative
    self.x = ((VIRTUALWIDTH / 12) * self.column) + 22
    self.y = ((VIRTUALHEIGHT / 6) * self.row + (self.height / 48))
    self.number = number
    self.inDeck = inDeck

    if self.name == 'Blank' then
        self.imagePath = 'Graphics/Blank Card'
    else
        self.stats = Characters[self.name]
        if self.stats['filename'] then
            self.imagePath = 'Characters/' .. self.stats['filename'] .. '/' .. self.stats['filename']
        else
            self.imagePath = 'Characters/' .. self.name .. '/' .. self.name
        end
        self.level = level or 1
        self.evolution = evolution or 0
        self:updateEvolutionSprites()
    end

    if imagesIndexes[self.imagePath] then
        self.image = true
    else
        if imagesInfo[self.imagePath] then
            table.insert(imagesInfo[self.imagePath],self)
        else
            imagesInfo[self.imagePath] = {self}
        end
        self.image = false
    end
end

function CardEditor:deleteEvolutionSprites()
    if self.name ~= 'Blank' then
        local evolutionSpriteBatch = gStateMachine.current.evolutionSpriteBatch
        local evolutionMaxSpriteBatch = gStateMachine.current.evolutionMaxSpriteBatch

        if self.evolutionMaxSprite then
            evolutionMaxSpriteBatch:set(self.evolutionMaxSprite,0,0,0,0,0) --Unfortunately closest thing to deleting Sprites there is
            self.evolutionMaxSprite = nil
        elseif self.evolution > 0 and evolutionImage then
            evolutionSpriteBatch:set(self.evolution1Sprite,0,0,0,0,0)
            self.evolutionMax1Sprite = nil
            if self.evolution > 1 then
                evolutionSpriteBatch:set(self.evolution2Sprite,0,0,0,0,0)
                self.evolutionMax2Sprite = nil
                if self.evolution > 2 then
                    evolutionSpriteBatch:set(self.evolution3Sprite,0,0,0,0,0)
                    self.evolutionMax3Sprite = nil
                end
            end
        end
    end
end

function CardEditor:updateEvolutionSprites()
    if self.name ~= 'Blank' then
        local evolutionSpriteBatch = gStateMachine.current.evolutionSpriteBatch
        local evolutionMaxSpriteBatch = gStateMachine.current.evolutionMaxSpriteBatch

        if self.evolution == 4 then
            self.evolutionMaxSprite = evolutionMaxSpriteBatch:add(0,0,0,0,0)
        elseif self.evolution > 0 then
            self.evolution1Sprite = evolutionSpriteBatch:add(0,0,0,0,0)
            if self.evolution > 1 then
                self.evolution2Sprite = evolutionSpriteBatch:add(0,0,0,0,0)
                if self.evolution > 2 then
                    self.evolution3Sprite = evolutionSpriteBatch:add(0,0,0,0,0)
                end
            end
        end
    end
end

function CardEditor:swap()
    self.clicked = false
    if mouseTrapped2 == self and not (not self.inDeck and not mouseTrapped.inDeck) then --If not touching another card or both cards in are inventory, abort
        if sandbox and not (self.inDeck and mouseTrapped.inDeck) then --If both cards are in deck, below logic suffices. Otherwise, we don't want to move cards out of inventory in sandbox as it doesn't change, and we can avoid reloading it by doing so.
            if mouseTrapped.inDeck then
                P1strength = P1strength - characterStrength({mouseTrapped.name,mouseTrapped.level,mouseTrapped.evolution})
                mouseTrapped:deleteEvolutionSprites()
                -- Copy data from inventory card to deck card
                mouseTrapped.name, mouseTrapped.level, mouseTrapped.evolution, mouseTrapped.imagePath = self.name, self.level, self.evolution, self.imagePath
                if mouseTrapped.name ~= 'Blank' then --If card in inventory being swapped with is not blank, lower overall strength by its strength
                    mouseTrapped:updateEvolutionSprites()
                    P1strength = P1strength + characterStrength({mouseTrapped.name,mouseTrapped.level,mouseTrapped.evolution}) --Increase overall strength by strength of new card added to deck
                end
                P1deck[mouseTrapped.number] = mouseTrapped
                P1deckEdit(mouseTrapped.number,{mouseTrapped.name,mouseTrapped.level,mouseTrapped.evolution})
            else
                if self.name ~= 'Blank' then
                    P1strength = P1strength - characterStrength({self.name,self.level,self.evolution})
                    self:deleteEvolutionSprites()
                end
                self.name, self.level, self.evolution, self.imagePath = mouseTrapped.name, mouseTrapped.level, mouseTrapped.evolution, mouseTrapped.imagePath
                self:updateEvolutionSprites()
                P1strength = P1strength + characterStrength({self.name,self.level,self.evolution})
                P1deck[self.number] = self
                P1deckEdit(self.number,{self.name,self.level,self.evolution})
            end
            gStateMachine.current:createDeckeditorBackground()
            gStateMachine.current:updateGui()
        else
            --Swap stats between the two card being swapped
            self.row, self.column, self.number, self.x, self.y, self.inDeck, mouseTrapped.row, mouseTrapped.column, mouseTrapped.number, mouseTrapped.x, mouseTrapped.y, mouseTrapped.inDeck = mouseTrapped.row, mouseTrapped.column, mouseTrapped.number, mouseTrapped.x, mouseTrapped.y, mouseTrapped.inDeck, self.row, self.column, self.number, self.x, self.y, self.inDeck

            if mouseTrapped.inDeck then
                P1deck[mouseTrapped.number] = mouseTrapped
                P1deckEdit(mouseTrapped.number,{mouseTrapped.name,mouseTrapped.level,mouseTrapped.evolution},true)
            else --Only happens if not in sandbox
                P1cardsEdit(mouseTrapped.number,{mouseTrapped.name,mouseTrapped.level,mouseTrapped.evolution},true)
            end

            if self.inDeck then
                P1deck[self.number] = self
                P1deckEdit(self.number,{self.name,self.level,self.evolution},true)
            else
                P1cardsEdit(self.number,{self.name,self.level,self.evolution},true)
            end

            if mouseTrapped.inDeck or self.inDeck then
                bitser.dumpLoveFile(Settings['active_deck'],P1deckCards)
            end
            if not sandbox and (not mouseTrapped.inDeck or not self.inDeck) then
                bitser.dumpLoveFile('Player 1 cards.txt',P1cards)
            end

            if not (mouseTrapped.inDeck and self.inDeck) then
                gStateMachine.current:loadCards()
                gStateMachine.current:updateCardsOnDisplay()
                if self.inDeck then
                    if self.level ~= nil then P1strength = P1strength + characterStrength({self.name,self.level,self.evolution}) end
                    if mouseTrapped.level ~= nil then P1strength = P1strength - characterStrength({mouseTrapped.name,mouseTrapped.level,mouseTrapped.evolution}) end
                else
                    if mouseTrapped.level ~= nil then P1strength = P1strength + characterStrength({mouseTrapped.name,mouseTrapped.level,mouseTrapped.evolution}) end
                    if self.level ~= nil then P1strength = P1strength - characterStrength({self.name,self.level,self.evolution}) end
                end
                gStateMachine.current:createDeckeditorBackground()
            else
                gStateMachine.current:updateGui()
            end
        end
        mouseTrapped = false
        mouseTrapped2 = false
    end
    self.x = ((VIRTUALWIDTH / 12) * self.column) + 22
    self.y = ((VIRTUALHEIGHT / 6) * self.row + (self.height / 48))
end

function CardEditor:CardViewer()
    if gui['CardViewer'] then
        self.mode = gui['CardViewer'].mode
        gui['CardViewer'] = nil
        collectgarbage()
    end
    gui['CardViewer'] = CardViewer(self.name,self.imagePath,self.level,self.evolution,self.inDeck,self.number,self,self.mode)
end

function CardEditor:update()
    --When mouse visible cards are swapped by dragging and dropping, when not (ie using controller or keyboard to navigate) cards are selected by clicking and swapped by clicking on a different card
    if love.mouse.isVisible() then
        if self.clicked == true then
            if mouseDown then
                if mouseTrapped == self then
                    self.scaling = 1.08
                    if self.clickedPositionX and self.clickedPositionY then
                        self.x = mouseLastX - self.clickedPositionX
                        self.y = mouseLastY - self.clickedPositionY
                    end
                end
            elseif math.abs(mouseLastX - mousePressedX) < 10 and math.abs(mouseLastY - mousePressedY) < 10 and love.timer.getTime() - mousePressedTime < 0.15 and self.name ~= 'Blank'then
                gStateMachine.current:enterStats()
                self:CardViewer()
                gStateMachine.current:createCardViewerBackground()
            else
                self:swap()
            end
        end
        if mouseDown and mouseLastX > self.x and mouseLastX < self.x + self.width and mouseLastY > self.y and mouseLastY < self.y + self.height then
            self.clicked = true
            if mouseTrapped == false and self.name ~= 'Blank' then
                mouseTrapped = self
                self.clickedPositionX = mouseLastX - self.x
                self.clickedPositionY = mouseLastY - self.y
            elseif (mouseTrapped ~= self and self.name ~= 'Blank') or (mouseTrapped ~= false and self.name == 'Blank') then
                mouseTrapped2 = self
            end
        elseif mouseTrapped2 == self then
            mouseTrapped2 = false
        end
    else
        if mouseDown and mousePressedX > self.x and mousePressedX < self.x + self.width and mousePressedY > self.y and mousePressedY < self.y + self.height and love.timer.getTime() - mousePressedTime > 0.3 and self.name ~= 'Blank' then
            gStateMachine.current:enterStats()
            self:CardViewer()
            gStateMachine.current:createCardViewerBackground()
            mouseDown = false
            mouseLocked = false
        end
        if mouseLastX > self.x and mouseLastX < self.x + self.width and mouseLastY > self.y and mouseLastY < self.y + self.height and love.mouse.buttonsReleased[1] then
            if mouseTrapped == false and self.name ~= 'Blank' then
                mouseTrapped = self
                mouseLocked = true
            elseif self.name ~= 'Blank' or (self.name == 'Blank' and mouseTrapped ~= false) then
                mouseTrapped2 = self
                if mouseTrapped ~= mouseTrapped2 then
                    self:swap()
                end
                self.scaling = 1
                mouseLocked = false
                mouseTrapped2 = false
            end
        end
    end

    if mouseTrapped == self then
        self.scaling = 1.08
        if mouseX > self.x and mouseX < self.x + self.width and mouseY > self.y and mouseY < self.y + self.height then
            mouseTouching = self
        end
    elseif mouseX > self.x and mouseX < self.x + self.width and mouseY > self.y and mouseY < self.y + self.height then
        if self.name ~= 'Blank' or (mouseTrapped and self.inDeck) or not love.mouse.isVisible() then
            self.scaling = 1.04
        else
            self.scaling = 1
        end
        if mouseTrapped == false or not love.mouse.isVisible() then
            mouseTouching = self
        end
    else
        self.scaling = 1
    end
end

function CardEditor:render()
    if self.image then
        if self.deleting then
            love.graphics.setColor(1,0,0)
            love.graphics.rectangle('fill',self.x-self.width*(self.scaling-1),self.y-self.height*(self.scaling-1),self.width+self.width*(self.scaling-1)*2,self.height+self.height*(self.scaling-1)*2)
            love.graphics.setColor(1,1,1)
        end
        love.graphics.drawLayer(gStateMachine.current.imagesArrayLayer,gStateMachine.current.imagesIndexes[self.imagePath],self.x,self.y,0,self.scaling,self.scaling,(-1+self.scaling)/2*self.width,(-1+self.scaling)/2*self.height)

        if self.name ~= 'Blank' then
            if self.evolution == 4 then
                gStateMachine.current.evolutionMaxSpriteBatch:set(self.evolutionMaxSprite,self.x+self.width-evolutionMaxImage:getWidth()-4,self.y+4)
            elseif self.evolution > 0 then
                gStateMachine.current.evolutionSpriteBatch:set(self.evolution1Sprite,self.x+115-5,self.y+3,math.rad(90))
                if self.evolution > 1 then
                    gStateMachine.current.evolutionSpriteBatch:set(self.evolution2Sprite,self.x+115-6-evolutionImage:getHeight(),self.y+3,math.rad(90))
                    if self.evolution > 2 then
                        gStateMachine.current.evolutionSpriteBatch:set(self.evolution3Sprite,self.x+115-7-evolutionImage:getHeight()*2,self.y+3,math.rad(90))
                    end
                end
            end
        end
    end
end

function CardEditor:renderInFront() --This is needed to ensure that the selected/hovered card's evolution is drawn on top of the card
    if self.name ~= 'Blank' and mouseTouching == self then
        if self.evolution == 4 and evolutionMaxImage then --In theory on a very slow system/very quickly changing state this might not have loaded yet
            love.graphics.draw(evolutionMaxImage,self.x+self.width-evolutionMaxImage:getWidth()-4,self.y+4,0,self.scaling,self.scaling,(-1+self.scaling)/2*-self.width*0.6,(-1+self.scaling)/2*self.height)
        elseif self.evolution > 0 and evolutionImage then
            love.graphics.draw(evolutionImage,self.x+115-5,self.y+3,math.rad(90),self.scaling,self.scaling,(-1+self.scaling)/2*self.width*1.4,(1-self.scaling)/2*-self.height*0.6)
            if self.evolution > 1 then
                love.graphics.draw(evolutionImage,self.x+115-6-evolutionImage:getHeight(),self.y+3,math.rad(90),self.scaling,self.scaling,(-1+self.scaling)/2*self.width*1.4,(1-self.scaling)/2*-self.height*0.6)
                if self.evolution > 2 then
                    love.graphics.draw(evolutionImage,self.x+115-7-evolutionImage:getHeight()*2,self.y+3,math.rad(90),self.scaling,self.scaling,(-1+self.scaling)/2*self.width*1.4,(1-self.scaling)/2*-self.height*0.6)
                end
            end
        end
    end
end