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
    if love.mouse.buttonsPressed[1] and mouseLastX > self.x and mouseLastX < self.x + self.width and mouseLastY > self.y and mouseLastY < self.y + self.height then
        if self.name == 'Battle 1.png' then
            for i = 0,17,1 do
                P2_deck_cards[i] = 'Ewok'
            end
            P2_deck_cards[3] = 'Yoda'
            gStateMachine:change('game')
        elseif self.name == 'Button2.png' then
            P1_deck_edit(0,'AhsokaS7')
            P1_deck_edit(1,'AnakinF3')
            P1_deck_edit(2,'BabyYoda')
            P1_deck_edit(3,'BenKenobi')
            P1_deck_edit(4,'C3P0')
            P1_deck_edit(5,'Chewbacca')
            P1_deck_edit(6,'DarthSidiousReborn')
            P1_deck_edit(7,'DarthVader')
            P1_deck_edit(8,'Ewok')
            P1_deck_edit(9,'FarmboyLuke')
            P1_deck_edit(10,'HanSoloOld')
            P1_deck_edit(11,'Hondo')
            P1_deck_edit(12,'JediKnightLuke')
            P1_deck_edit(13,'KyloRen')
            P1_deck_edit(14,'MaceWindu')
            P1_deck_edit(15,'ObiWanKenobi')
            P1_deck_edit(16,'R2D2')
            P1_deck_edit(17,'Rey')
        end
    end
end

function Button:render()
    love.graphics.draw(self.image, self.x, self.y)
end
