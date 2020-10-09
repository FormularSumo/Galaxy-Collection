Card = Class{}

function Card:init(name,row,column)
    self.name = name
    self.row = row
    self.column = column
    self.image = love.graphics.newImage('Characters/' .. self.name .. '/' .. self.name .. '.png')
    self.width = self.image:getWidth() / 8.7
    self.height = self.image:getHeight() / 8.7
    self.health = 1000
    self.attack = _G[self.name]['attack']
    self.defense = _G[self.name]['defense']
    self.evade = _G[self.name]['evade']
    self.range = _G[self.name]['range']
end

function Card:update()
    self.x = ((VIRTUAL_WIDTH / 12) * self.column) + (self.width / 12)
    self.y = ((VIRTUAL_HEIGHT / 6) * self.row + (self.height / 6 / 4))
    if self.column > 5 then
        self.x = self.x + 20
    end
end

function Card:render()
    love.graphics.draw(self.image,self.x,self.y,0,0.115,sx)
    love.graphics.setFont(font80SW)
    -- love.graphics.line(VIRTUAL_WIDTH / 2,0,VIRTUAL_WIDTH / 2,VIRTUAL_HEIGHT)
    -- love.graphics.print(self.attack, self.x, self.y)
    -- love.graphics.print(self.defense, self.x, self.y)
    -- love.graphics.print(self.evade, self.x, self.y)
    -- love.graphics.print(tostring(self.y),100,0)
end