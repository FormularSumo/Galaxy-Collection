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
        if  self.name == 'Battle 1.png' then
            for i = 0,17,1 do
                P2_deck_cards[i] = 'Ewok'
            end
            P2_deck_cards[3] = 'Yoda'
            gStateMachine:change('game')
        end
    end
end

function Button:render()
    love.graphics.draw(self.image, self.x, self.y)
    -- love.graphics.print(,100,100)
end
