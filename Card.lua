Card = Class{}

function Card:init(name,row,column,team,number)
    self.name = name
    self.row = row
    self.column = column
    self.image = love.graphics.newImage('Characters/' .. self.name .. '/' .. self.name .. '.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.x = -self.width
    self.y = -self.height
    self.team = team 
    self.number = number
    self.health = 1000
    self.attack = _G[self.name]['attack']
    self.defense = _G[self.name]['defense']
    self.evade = _G[self.name]['evade']
    self.range = _G[self.name]['range']
end

function Card:update(dt,turn)
    self.x = ((VIRTUAL_WIDTH / 12) * self.column) + 22 - 20
    self.y = ((VIRTUAL_HEIGHT / 6) * self.row + (self.height / 48))
    if self.column > 5 then
        self.x = self.x + 40
    end
    if turn == true then
        if self.team == 1 then
            if (self.number < 6 and self.column < 5) or (self.number < 12 and self.column < 4) or (self.number < 18 and self.column < 3) then
                self.column = self.column + 1
            end
            if P1_deck[self.number-6] == nil and self.number - 6 >= 0 then
                next_round_P1_deck[self.number - 6] = P1_deck[self.number]
                next_round_P1_deck[self.number] = nil
                self.number = self.number - 6
            end
        else
            if (self.number < 6 and self.column > 6) or (self.number < 12 and self.column > 7) or (self.number < 18 and self.column > 8) then
                self.column = self.column - 1
            end
            if P2_deck[self.number-6] == nil and self.number - 6 >= 0 then
                next_round_P2_deck[self.number - 6] = P2_deck[self.number]
                next_round_P2_deck[self.number] = nil
                self.number = self.number - 6
            end
        end
    end
    if self.health <= 0 then
        if self.team == 1 then
            next_round_P1_deck[self.number] = next_round_P1_deck[self.number-6]
            next_round_P1_deck[self.number-6] = nil 
        else
            next_round_P2_deck[self.number] = next_round_P2_deck[self.number-6]
            next_round_P2_deck[self.number-6] = nil 
        end
    end    
end

function Card:render()
    love.graphics.draw(self.image,self.x,self.y,0,1,sx)
    love.graphics.setColor(0.3,0.3,0.3)
    love.graphics.rectangle('fill',self.x-2,self.y-4,self.width+4,10,5,5)
    love.graphics.setColor(1,0.820,0)
    love.graphics.rectangle('fill',self.x-2,self.y-4,(self.width+4)/(1000/self.health),10,5,5)
    love.graphics.setColor(1,1,1)
    -- love.graphics.line(VIRTUAL_WIDTH / 2,0,VIRTUAL_WIDTH / 2,VIRTUAL_HEIGHT)
    -- love.graphics.print(self.attack, self.x, self.y)
    -- love.graphics.print(self.defense, self.x, self.y)
    -- love.graphics.print(self.evade, self.x, self.y)
    -- love.graphics.print(tostring(self.y),100,0)
end
