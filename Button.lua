Button = Class{}

function Button:init(name,x,y)
    self.name = name
    self.image = love.graphics.newImage('Buttons/' .. self.name)
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.x = VIRTUAL_WIDTH / 2 - self.width / 2 
    self.y = VIRTUAL_HEIGHT / 2 - self.height / 2 - 450
end

function Button:update()
    if love.mouse.buttonsPressed[1] and mouseLastX > self.x and mouseLastX < self.x + self.width and mouseLastY > self.y and mouseLastY < self.y + self.height then
        gStateMachine:change('game')
    end
end

function Button:render()
    love.graphics.draw(self.image, self.x, self.y)
end
