Card_editor = Class{__includes = BaseState}

function Card_editor:init(name,row,column,number,level,evolution,in_deck)
    self.name = name
    self.row = row
    self.column = column
    self.scaling = 1
    if self.name == 'Blank' then
        self.image = BlankCard
    else
        self.stats = Characters[self.name]
        self.image = love.graphics.newImage('Characters/' .. self.name .. '/' .. self.name .. '.png')
    end
    self.width,self.height = self.image:getDimensions()
    self.x = ((VIRTUAL_WIDTH / 12) * self.column) + 22
    self.y = ((VIRTUAL_HEIGHT / 6) * self.row + (self.height / 48))
    self.number = number
    if not level then self.level = 1 else self.level = level end
    if not evolution then self.evolution = 0 else self.evolution = evolution end
    self.in_deck = in_deck
    if self.name ~= 'Blank' then
        self.health = 1000
        self.modifier = ((self.level + (60 - self.level) / 1.7) / 60) * (1 - ((4 - self.evolution) * 0.1))
        self.melee_offense = self.stats['melee_offense'] * (self.modifier)
        if self.stats['ranged_offense'] then
            self.ranged_offense = self.stats['ranged_offense'] * (self.modifier)
        else
            self.ranged_offense = self.melee_offense
        end
        self.defense = self.stats['defense'] * (self.modifier)
        self.evade = self.stats['evade']
        self.range = self.stats['range']
    end
end

function Card_editor:swap()
    if mouseTrapped2 == self then
        temporary = Card_editor(self.name,mouseTrapped.row,mouseTrapped.column,mouseTrapped.number,self.level,self.evolution,mouseTrapped.in_deck)
        temporary2 = Card_editor(mouseTrapped.name,self.row,self.column,self.number,mouseTrapped.level,mouseTrapped.evolution,self.in_deck)

        if temporary2.in_deck then
            P1_deck[self.number] = temporary2
            if temporary2.name ~= 'Blank' then
                P1_deck_edit(temporary2.number,{temporary2.name,temporary2.level,temporary2.evolution})
            else
                P1_deck_edit(temporary2.number,nil)
            end
        else
            Cards_on_display[self.number-page*18] = temporary2
            if temporary2.name ~= 'Blank' then
                P1_cards_edit(temporary2.number,{temporary2.name,temporary2.level,temporary2.evolution})
            else
                P1_cards_edit(temporary2.number,nil)
            end
        end

        if temporary.in_deck then
            P1_deck[mouseTrapped.number] = temporary
            if temporary.name ~= 'Blank' then
                P1_deck_edit(temporary.number,{temporary.name,temporary.level,temporary.evolution})
            else
                P1_deck_edit(temporary.number,nil)
            end
        else
            Cards_on_display[mouseTrapped.number-page*18] = temporary
            if temporary.name ~= 'Blank' then
                P1_cards_edit(temporary.number,{temporary.name,temporary.level,temporary.evolution})
            else
                P1_cards_edit(temporary.number,nil)
            end
        end

        temporary = nil
        temporary2 = nil
        collectgarbage()
    end
    self.clicked = false
    self.x = ((VIRTUAL_WIDTH / 12) * self.column) + 22
    self.y = ((VIRTUAL_HEIGHT / 6) * self.row + (self.height / 48))
    update_gui()
end

function Card_editor:update()
    --When mouse visible cards are swapped by dragging and dropping, when not (ie using controller or keyboard to navigate) cards are selected by clicking and swapped by clicking on a different card
    if love.mouse.isVisible() then
        if self.clicked == true then
            if mouseDown then
                if mouseTrapped == self then
                    self.scaling = 1.08
                    if self.clicked_positionX and self.clicked_positionY then
                        self.x = mouseLastX - self.clicked_positionX
                        self.y = mouseLastY - self.clicked_positionY
                    end
                end
            else
                self:swap()
            end
        end
        if mouseDown and mouseLastX > self.x and mouseLastX < self.x + self.width and mouseLastY > self.y and mouseLastY < self.y + self.height then
            self.clicked = true
            if mouseTrapped == false then
                mouseTrapped = self
                self.clicked_positionX = mouseLastX - self.x
                self.clicked_positionY = mouseLastY - self.y
            elseif mouseTrapped ~= self then
                mouseTrapped2 = self
            end
        elseif mouseTrapped2 == self then
            mouseTrapped2 = false
        end
    else
        if mouseLastX > self.x and mouseLastX < self.x + self.width and mouseLastY > self.y and mouseLastY < self.y + self.height and love.mouse.buttonsPressed[1] then
            if mouseTrapped == false then
                mouseTrapped = self
                mouseLocked = true
            else
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

    if mouseX > self.x and mouseX < self.x + self.width and mouseY > self.y and mouseY < self.y + self.height then
        self.scaling = 1.04
        if (mouseTrapped == false or mouseTrapped == self) or not love.mouse.isVisible() then
            mouseTouching = self
        end
    elseif (mouseTrapped ~= self) then
        self.scaling = 1
    end

    if mouseTrapped == self then
        self.scaling = 1.08
    end
end

function Card_editor:render()
    love.graphics.draw(self.image,self.x,self.y,0,self.scaling,self.scaling,(-1+self.scaling)/2*self.width,(-1+self.scaling)/2*self.height)
    if self.evolution == 4 then
        love.graphics.draw(EvolutionMax,self.x+self.width-EvolutionMax:getWidth()-3,self.y+3,0,self.scaling,self.scaling,(-1+self.scaling)/2*-self.width*0.6,(-1+self.scaling)/2*self.height)
    elseif self.evolution > 0 then
        love.graphics.draw(Evolution,self.x+5,self.y+2,math.rad(90),self.scaling,self.scaling,(-1+self.scaling)/2*self.width*1.4,(-1+self.scaling)/2*-self.height*0.6)
        if self.evolution > 1 then
            love.graphics.draw(Evolution,self.x+6+Evolution:getHeight(),self.y+2,math.rad(90),self.scaling,self.scaling,(-1+self.scaling)/2*self.width*1.4,(-1+self.scaling)/2*-self.height*0.6)
            if self.evolution > 2 then
                love.graphics.draw(Evolution,self.x+7+Evolution:getHeight()*2,self.y+2,math.rad(90),self.scaling,self.scaling,(-1+self.scaling)/2*self.width*1.4,(-1+self.scaling)/2*-self.height*0.6)
            end
        end
    end
end