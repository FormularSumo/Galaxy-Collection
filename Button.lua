Button = Class{}

function Button:init(name,x,y,render)
    self.name = name
    self.image = love.graphics.newImage('Buttons/' .. self.name .. '.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.should_render = render
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
        if self.name == 'Battle 1' then
            for i = 0,17,1 do
                P2_deck_cards[i] = 'Ewok'
            end
            -- P2_deck_cards[0] = 'AnakinF3'
            -- P2_deck_cards[1] = 'ObiWanKenobi'
            P2_deck_cards[2] = 'Maul'
            P2_deck_cards[3] = 'Yoda'
            -- P2_deck_cards[4] = 'BabyYoda'
            -- P2_deck_cards[5] = 'DarthSidiousReborn'
            gStateMachine:change('game')
        elseif self.name == 'Prebuilt deck' then
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
        elseif self.name == 'Pause' then
            if pause == false then
                pause = true
            else
                pause = false
            end
        end
    end
end

function Button:render()
    love.graphics.draw(self.image, self.x, self.y)
end
