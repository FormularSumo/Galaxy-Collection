Card_editor = Class{__includes = BaseState}

function Card_editor:init(name,row,column,number,level,evolution,in_deck)
    self.name = name
    self.row = row
    self.column = column
    self.image = love.graphics.newImage('Characters/' .. self.name .. '/' .. self.name .. '.png')
    self.width,self.height = self.image:getDimensions()
    self.x = ((VIRTUAL_WIDTH / 12) * self.column) + 22
    self.y = ((VIRTUAL_HEIGHT / 6) * self.row + (self.height / 48))
    self.number = number
    if not level then self.level = 1 else self.level = level end
    if not evolution then self.evolution = 0 else self.evolution = evolution end
    self.in_deck = in_deck
    self.health = 1000
    self.modifier = ((self.level + (60 - self.level) / 1.7) / 60) * (1 - ((4 - self.evolution) * 0.1))
    self.offense = _G[self.name]['offense'] * (self.modifier)
    self.defense = _G[self.name]['defense'] * (self.modifier)
    self.evade = _G[self.name]['evade']
    self.range = _G[self.name]['range']
end

function Card_editor:update()
    if self.clicked == true then
        if mouseDown then
            if mouseTrapped == self then
                self.x = mouseLastX - self.clicked_positionX
                self.y = mouseLastY - self.clicked_positionY
            end
        else
            if mouseTrapped2 == self then
                temporary = Card_editor(self.name,mouseTrapped.row,mouseTrapped.column,mouseTrapped.number,self.level,self.evolution,mouseTrapped.in_deck)
                temporary2 = Card_editor(mouseTrapped.name,self.row,self.column,self.number,mouseTrapped.level,mouseTrapped.evolution,self.in_deck)

                if temporary2.in_deck == true then
                    P1_deck[self.number] = temporary2
                    P1_deck_edit(temporary2.number,{temporary2.name,temporary2.level,temporary2.evolution})
                else
                    Cards_on_display[self.number-page*18] = temporary2
                    P1_cards_edit(temporary2.number,{temporary2.name,temporary2.level,temporary2.evolution})
                end

                if temporary.in_deck == true then
                    P1_deck[mouseTrapped.number] = temporary
                    P1_deck_edit(temporary.number,{temporary.name,temporary.level,temporary.evolution})
                else
                    Cards_on_display[mouseTrapped.number-page*18] = temporary
                    P1_cards_edit(temporary.number,{temporary.name,temporary.level,temporary.evolution})
                end

                temporary = nil
                temporary2 = nil
                collectgarbage()
            end
            self.clicked = false
            self.x = ((VIRTUAL_WIDTH / 12) * self.column) + 22
            self.y = ((VIRTUAL_HEIGHT / 6) * self.row + (self.height / 48))
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
end

function Card_editor:render()
    love.graphics.draw(self.image,self.x,self.y)
    if self.evolution == 4 then
        love.graphics.draw(EvolutionMax,self.x+self.width-EvolutionMax:getWidth()-3,self.y+3)
    elseif self.evolution > 0 then
        love.graphics.draw(Evolution,self.x+5,self.y+2,math.rad(90))
        if self.evolution > 1 then
            love.graphics.draw(Evolution,self.x+6+Evolution:getHeight(),self.y+2,math.rad(90))
            if self.evolution > 2 then
                love.graphics.draw(Evolution,self.x+7+Evolution:getHeight()*2,self.y+2,math.rad(90))
            end
        end
    end
end