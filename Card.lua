Card = Class{}

function Card:init(name,row,column)
    self.name = name
    self.row = row
    self.column = column
    self.image = love.graphics.newImage('Characters/' .. self.name .. '/' .. self.name .. '.png')
    self.width = self.image:getWidth() / 5
    self.height = self.image:getHeight() / 5
    self.health = 1000
    self.attack = _G[self.name]['attack']
    self.defense = _G[self.name]['defense']
    self.evade = _G[self.name]['evade']
end

function Card:update()
    self.x = ((VIRTUAL_WIDTH / 6) * self.column) + (self.width / 5)
    self.y = ((VIRTUAL_HEIGHT / 6) * self.row)
end

function Card:render()
    love.graphics.draw(self.image,self.x,self.y,0,0.2,sx)
    love.graphics.setFont(font80SW)
    love.graphics.print(self.defense, self.x, self.y)
end