Button = Class{}

function Button:init(name,x,y)
    self.name = name
    self.image = love.graphics.newImage('Buttons/' .. self.name)
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    if x == nil then
        self.x = VIRTUAL_WIDTH / 2 - self.width / 2 
    else self.x = x
    end
    if y == nil then
        self.y = VIRTUAL_HEIGHT / 2 - self.height / 2 - 450
    else self.y = y
    end
end

function Button:update()
    P1_deck_file = love.filesystem.read('Player 1 deck.txt')
    if love.mouse.buttonsPressed[1] and mouseLastX > self.x and mouseLastX < self.x + self.width and mouseLastY > self.y and mouseLastY < self.y + self.height then
        if self.name == 'Battle 1.png' then
            for i = 0,17,1 do
                P2_deck_cards[i] = 'Ewok'
            end
            P2_deck_cards[3] = 'Yoda'
            gStateMachine:change('game')
        elseif self.name == 'Button2.png' then
            P1_deck_edit(2,'AhsokaS7')
        end
    end
end

function Button:render()
    love.graphics.draw(self.image, self.x, self.y)
end
