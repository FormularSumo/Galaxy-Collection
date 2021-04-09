Card_editor = Class{__includes = BaseState}

function Card_editor:init(name,row,column,number)
    self.name = name
    self.row = row
    self.column = column
    self.image = love.graphics.newImage('Characters/' .. self.name .. '/' .. self.name .. '.png')
    self.width,self.height = self.image:getDimensions()
    self.x = ((VIRTUAL_WIDTH / 12) * self.column) + 22
    self.y = ((VIRTUAL_HEIGHT / 6) * self.row + (self.height / 48))
    self.number = number
    self.health = 1000
    self.offense = _G[self.name]['offense']
    self.defense = _G[self.name]['defense']
    self.evade = _G[self.name]['evade']
    self.range = _G[self.name]['range']
end

function Card_editor:update_position(number,column,row)
    self.number = number
    self.column = column
    self.row = row
    self.x = ((VIRTUAL_WIDTH / 12) * self.column) + 22
    self.y = ((VIRTUAL_HEIGHT / 6) * self.row + (self.height / 48))
end

function Card_editor:update()
    if mouseDown and mouseLastX > self.x and mouseLastX < self.x + self.width and mouseLastY > self.y and mouseLastY < self.y + self.height then
        self.clicked = true
        if mouseTrapped == false then
            mouseTrapped = self.number
            self.clicked_positionX = mouseLastX - self.x
            self.clicked_positionY = mouseLastY - self.y
        elseif mouseTrapped ~= self.number then
            mouseTrapped2 = self.number
        end
    end
    if self.clicked == true then
        if mouseDown then
            if mouseTrapped == self.number then
                self.x = mouseLastX - self.clicked_positionX
                self.y = mouseLastY - self.clicked_positionY
            end
        else
            if mouseTrapped2 == self.number then
                temporary = Card_editor(self.name,self.row,self.column,self.number)
                temporary2 = Card_editor(P1_deck[mouseTrapped].name,P1_deck[mouseTrapped].row,P1_deck[mouseTrapped].column,P1_deck[mouseTrapped].number)

                P1_deck[self.number]:update_position(temporary2.number,temporary2.column,temporary2.row)
                P1_deck_edit(temporary.number,temporary2.name)

                P1_deck[mouseTrapped]:update_position(temporary.number,temporary.column,temporary.row)
                P1_deck_edit(temporary2.number,temporary.name)

                temporary = nil
                temporary2 = nil
            end
            self.clicked = false
        end
    end
end

function Card_editor:render()
    love.graphics.draw(self.image,self.x,self.y)
    if self.number == 0 and self.clicked_positionX and self.clicked_positionY then
        love.graphics.print(self.clicked_positionX .. ' ' .. self.clicked_positionY,1500,100)
    end
end