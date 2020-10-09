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
                _G.P2_deck_cards[i] = 'Ewok'
            end
            gStateMachine:change('game')
        end
    end

    _G.P1_deck_cards[0] = 'AhsokaS7'
    _G.P1_deck_cards[1] = 'AnakinF3'
    _G.P1_deck_cards[2] = 'BabyYoda'
    _G.P1_deck_cards[3] = 'BenKenobi'
    _G.P1_deck_cards[4] = 'C3P0'
    _G.P1_deck_cards[5] = 'Chewbacca'
    _G.P1_deck_cards[6] = 'DarthSidiousReborn'
    _G.P1_deck_cards[7] = 'DarthVader'
    _G.P1_deck_cards[8] = 'Ewok'
    _G.P1_deck_cards[9] = 'FarmboyLuke'
    _G.P1_deck_cards[10] = 'HanSoloOld'
    _G.P1_deck_cards[11] = 'Hondo'
    for i = 11,17,1 do
        _G.P1_deck_cards[i] = 'Ewok'
    end
end

function Button:render()
    love.graphics.draw(self.image, self.x, self.y)
    -- love.graphics.print(,100,100)
end
