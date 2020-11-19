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
    self.alive = true
end

function Card:update(timer2)
    self.x = ((VIRTUAL_WIDTH / 12) * self.column) + 22 - 20
    self.y = ((VIRTUAL_HEIGHT / 6) * self.row + (self.height / 48))
    if self.column > 5 then
        self.x = self.x + 40
    end
    if self.health <= 0 and self.alive == true then
        if self.team == 1 then
            next_round_P1_deck[self.number] = nil
        else
            next_round_P2_deck[self.number] = nil
        end 
        self.alive = false
    end
    if timer2 > 6 then 
        if self.team == 1 then
            self.number = self.row + (math.abs(6 - self.column)) * 6 - 6
        else
            self.number = self.row + (self.column - 5) * 6 - 6
        end
    end
end

function Card:move()
    if self.team == 1 then
        if (self.number < 6 and self.column < 5) or (self.number < 12 and self.column < 4) or (self.number < 18 and self.column < 3) then
            self.column = self.column + 1
        end
        if next_round_P1_deck[self.number-6] == nil and self.number - 6 >= 0 then
            self.column = self.column + 1
            next_round_P1_deck[self.number-6] = next_round_P1_deck[self.number]
            next_round_P1_deck[self.number] = nil
        end
    else
        if (self.number < 6 and self.column > 6) or (self.number < 12 and self.column > 7) or (self.number < 18 and self.column > 8) then
            self.column = self.column - 1
        end
        if next_round_P2_deck[self.number-6] == nil and self.number - 6 >= 0 then
            self.column = self.column - 1
            next_round_P2_deck[self.number-6] = next_round_P2_deck[self.number]
            next_round_P2_deck[self.number] = nil
        end
    end
end

function Card:attack1()
    if self.team == 1 then
        if self.column == 5 then
            if P2_deck[self.number] ~= nil then
                damage = ((self.attack - P2_deck[self.number].defense) / 1000) ^ 3
                if damage < 0 then damage = 0 end
                P2_deck[self.number].health = P2_deck[self.number].health - (damage + 5)
                if P2_deck[self.number].defense > 0 then
                    P2_deck[self.number].defense = P2_deck[self.number].defense - (self.attack ^ (1/3) * 30)
                else
                    P2_deck[self.number].defense = 0
                end
            end
        end
    else
        if self.column == 6 then
            if P1_deck[self.number] ~= nil then
                damage = ((self.attack - P1_deck[self.number].defense) / 1000) ^ 3
                if damage < 0 then damage = 0 end
                P1_deck[self.number].health = P1_deck[self.number].health - (damage + 5)
                if P1_deck[self.number].defense > 0 then
                    P1_deck[self.number].defense = P1_deck[self.number].defense - (self.attack ^ (1/3) * 30)
                else 
                    P1_deck[self.number].defense = 0
                end
            end
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
    -- if self.number == 3 then
    --     if self.team == 1 then
    --         if P2_deck[self.number] ~= nil then
    --             love.graphics.print(((self.attack - P2_deck[self.number].defense) / 1000) ^ 3)
    --         end
    --         love.graphics.print((self.attack ^ (1/3) * 30),0,100)
    --         love.graphics.print(self.defense,0,200)
    --     elseif self.team == 2 then
    --         if P1_deck[self.number] ~= nil then
    --             love.graphics.print(((self.attack - P1_deck[self.number].defense) / 1000)^ 3,1000)
    --         end
    --         love.graphics.print((self.attack ^ (1/3) * 30),1000,100)
    --         love.graphics.print(self.defense,1000,200)
    --     end       
    -- end
    -- love.graphics.line(VIRTUAL_WIDTH / 2,0,VIRTUAL_WIDTH / 2,VIRTUAL_HEIGHT)
    -- love.graphics.print(self.attack, self.x, self.y)
    -- love.graphics.print(self.defense, self.x, self.y)
    -- love.graphics.print(self.evade, self.x, self.y)
    -- love.graphics.print(tostring(self.y),100,0)
end