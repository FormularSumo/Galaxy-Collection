Card = Class{}

function Card:init(name,row,column,team,number)
    self.name = name
    self.row = row
    self.column = column
    self.image = love.graphics.newImage('Characters/' .. self.name .. '/' .. self.name .. '.png')
    self.width = self.image:getWidth() / 8.7
    self.height = self.image:getHeight() / 8.7
    self.x = 0
    self.y = 0
    self.team = team 
    self.number = number
    self.health = 1000
    self.attack = _G[self.name]['attack']
    self.defense = _G[self.name]['defense']
    self.evade = _G[self.name]['evade']
    self.range = _G[self.name]['range']
end

function Card:update()
    self.x = ((VIRTUAL_WIDTH / 12) * self.column) + 22 - 10
    self.y = ((VIRTUAL_HEIGHT / 6) * self.row + (self.height / 48))
    if self.column > 5 then
        self.x = self.x + 20
    end
    -- if self.health <= 0 then
    --     if self.team == 1 then
    --         _G.P1_deck_cards[self.number] = nil
    --     else
    --         _G.P2_deck_cards[self.number] = nil
    --     end
    -- end
end

function Card:render()
    love.graphics.draw(self.image,self.x,self.y,0,0.115,sx)
    love.graphics.setFont(font80SW)
    love.graphics.line(VIRTUAL_WIDTH / 2,0,VIRTUAL_WIDTH / 2,VIRTUAL_HEIGHT)
    -- if self.health <= 0 then
    --     love.graphics.print('dead')
    -- end
    -- love.graphics.print(self.attack, self.x, self.y)
    -- love.graphics.print(self.defense, self.x, self.y)
    -- love.graphics.print(self.evade, self.x, self.y)
    -- love.graphics.print(tostring(self.y),100,0)
end