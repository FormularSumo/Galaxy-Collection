Button = Class{}

function Button:init(name,x,y,render_gamestate)
    self.name = name
    self.image = love.graphics.newImage('Buttons/' .. self.name .. '.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.render_gamestate = render_gamestate --Which gamestate should draw the button
    if x == nil then
        self.x = 0
    elseif x == 'centre' then
        self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    else self.x = x
    end
    if y == nil then
        self.y = 0
    elseif y == 'centre' then
        self.y = VIRTUAL_HEIGHT / 2 - self.height / 2
    else self.y = y
    end
end

function Button:update()
    if love.mouse.buttonsPressed[1] and mouseLastX > self.x and mouseLastX < self.x + self.width and mouseLastY > self.y and mouseLastY < self.y + self.height then
        _G[self.name]()
    end
end

function Button:render()
    love.graphics.draw(self.image, self.x, self.y)
end
