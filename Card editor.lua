CardEditor = Class{__includes = BaseState}

function CardEditor:init(name,row,column,number,level,evolution,inDeck)
    self.name = name
    self.row = row
    self.column = column
    self.scaling = 1
    if self.name == 'Blank' then
        self.image = blankCard
    else
        self.stats = Characters[self.name]
        if self.stats['filename'] then
            self.image = 'Characters/' .. self.stats['filename'] .. '/' .. self.stats['filename'] .. '.png'
        else
            self.image = 'Characters/' .. self.name .. '/' .. self.name .. '.png'
        end
        if cards[self.image] then
            self.image = cards[self.image]
        else
            cards[self.image] = love.graphics.newImage(self.image)
            self.image = cards[self.image]
        end
        if not level then self.level = 1 else self.level = level end
        if not evolution then self.evolution = 0 else self.evolution = evolution end
    end
    self.width,self.height = self.image:getDimensions()
    self.x = ((VIRTUALWIDTH / 12) * self.column) + 22
    self.y = ((VIRTUALHEIGHT / 6) * self.row + (self.height / 48))
    self.number = number
    self.inDeck = inDeck
    -- if self.name ~= 'Blank' then
    --     self.health = 1000
    --     self.modifier = ((self.level + (60 - self.level) / 1.7) / 60) * (1 - ((4 - self.evolution) * 0.1))
    --     self.meleeOffense = self.stats['meleeOffense'] * (self.modifier)
    --     if self.stats['rangedOffense'] then
    --         self.rangedOffense = self.stats['rangedOffense'] * (self.modifier)
    --     else
    --         self.rangedOffense = self.meleeOffense
    --     end
    --     self.defense = self.stats['defense'] * (self.modifier)
    --     self.evade = self.stats['evade']
    --     self.range = self.stats['range']
    -- end
end

function CardEditor:swap()
    self.clicked = false
    if mouseTrapped2 == self then
        self.row, self.column, self.number, self.x, self.y, self.inDeck, mouseTrapped.row, mouseTrapped.column, mouseTrapped.number, mouseTrapped.x, mouseTrapped.y, mouseTrapped.inDeck = mouseTrapped.row, mouseTrapped.column, mouseTrapped.number, mouseTrapped.x, mouseTrapped.y, mouseTrapped.inDeck, self.row, self.column, self.number, self.x, self.y, self.inDeck

        if mouseTrapped.inDeck then
            P1deck[mouseTrapped.number] = mouseTrapped
            P1deckEdit(mouseTrapped.number,{mouseTrapped.name,mouseTrapped.level,mouseTrapped.evolution})
        else
            P1cardsEdit(mouseTrapped.number,{mouseTrapped.name,mouseTrapped.level,mouseTrapped.evolution})
        end

        if self.inDeck then
            P1deck[self.number] = self
            P1deckEdit(self.number,{self.name,self.level,self.evolution})
        else
            P1cardsEdit(self.number,{self.name,self.level,self.evolution})
        end

        if not (mouseTrapped.inDeck and self.inDeck) then
            sortInventory()
        end

        mouseTrapped = false
        mouseTrapped2 = false
        self.x = ((VIRTUALWIDTH / 12) * self.column) + 22
        self.y = ((VIRTUALHEIGHT / 6) * self.row + (self.height / 48))
        return
    end
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
        if self.name ~= 'Blank' or not love.mouse.isVisible() then
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
    if self.deleting then
        love.graphics.setColor(1,0,0)
        love.graphics.rectangle('fill',self.x-self.width*(self.scaling-1),self.y-self.height*(self.scaling-1),self.width+self.width*(self.scaling-1)*2,self.height+self.height*(self.scaling-1)*2)
        love.graphics.setColor(1,1,1)
    end
    love.graphics.draw(self.image,self.x,self.y,0,self.scaling,self.scaling,(-1+self.scaling)/2*self.width,(-1+self.scaling)/2*self.height)
    if self.name ~= 'Blank' then
        if self.evolution== 4 then
            love.graphics.draw(evolutionMax,self.x+self.width-evolutionMax:getWidth()-3,self.y+3,0,self.scaling,self.scaling,(-1+self.scaling)/2*-self.width*0.6,(-1+self.scaling)/2*self.height)
        elseif self.evolution> 0 then
            love.graphics.draw(Evolution,self.x+5,self.y+2,math.rad(90),self.scaling,self.scaling,(-1+self.scaling)/2*self.width*1.4,(-1+self.scaling)/2*-self.height*0.6)
            if self.evolution> 1 then
                love.graphics.draw(Evolution,self.x+6+Evolution:getHeight(),self.y+2,math.rad(90),self.scaling,self.scaling,(-1+self.scaling)/2*self.width*1.4,(-1+self.scaling)/2*-self.height*0.6)
                if self.evolution> 2 then
                    love.graphics.draw(Evolution,self.x+7+Evolution:getHeight()*2,self.y+2,math.rad(90),self.scaling,self.scaling,(-1+self.scaling)/2*self.width*1.4,(-1+self.scaling)/2*-self.height*0.6)
                end
            end
        end
    end
end