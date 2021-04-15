Card_editor = Class{__includes = BaseState}

function Card_editor:init(name,row,column,number,level,evolution)
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
            if mouseTrapped == self.number then
                self.x = mouseLastX - self.clicked_positionX
                self.y = mouseLastY - self.clicked_positionY
            end
        else
            if mouseTrapped2 == self.number then
                temporary = Card_editor(self.name,P1_deck[mouseTrapped].row,P1_deck[mouseTrapped].column,P1_deck[mouseTrapped].number)
                temporary2 = Card_editor(P1_deck[mouseTrapped].name,self.row,self.column,self.number)

                P1_deck[self.number] = temporary2
                P1_deck_edit(temporary2.number,temporary2.name)

                P1_deck[mouseTrapped] = temporary
                P1_deck_edit(temporary.number,temporary.name)

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
            mouseTrapped = self.number
            self.clicked_positionX = mouseLastX - self.x
            self.clicked_positionY = mouseLastY - self.y
        elseif mouseTrapped ~= self.number then
            mouseTrapped2 = self.number
        end
    elseif mouseTrapped2 == self.number then
        mouseTrapped2 = false
    end
end

function Card_editor:render()
    love.graphics.draw(self.image,self.x,self.y)
end