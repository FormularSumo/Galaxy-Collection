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
            for i = 6,17,1 do
                P2_deck_cards[i] = 'B1BattleDroid'
            end
            P2_deck_cards[0] = 'Maul'
            P2_deck_cards[1] = 'CountDooku'
            P2_deck_cards[2] = 'DarthSidiousReborn'
            P2_deck_cards[3] = 'DarthVader'
            P2_deck_cards[4] = 'GeneralGrievous'
            P2_deck_cards[5] = 'KyloRen'
            -- P2_deck_cards[6] = ''
            P2_deck_cards[7] = 'MagnaGuard'
            P2_deck_cards[8] = 'SavageOpress'
            P2_deck_cards[9] = 'PreVizsla'
            -- P2_deck_cards[10] = ''
            -- P2_deck_cards[11] = ''
            P2_deck_cards[12] = 'B2SuperBattleDroid'
            P2_deck_cards[13] = 'CadBane'
            P2_deck_cards[14] = 'JangoFett'
            P2_deck_cards[15] = 'BobaFett'
            P2_deck_cards[16] = 'Greedo'
            -- P2_deck_cards[17] = ''

            gStateMachine:change('game')
        elseif self.name == 'Prebuilt deck' then
            P1_deck_edit(0,'AhsokaS7')
            P1_deck_edit(1,'AnakinF3')
            P1_deck_edit(2,'Yoda')
            P1_deck_edit(3,'MaceWindu')
            P1_deck_edit(4,'ObiWanKenobi')
            P1_deck_edit(5,'Rey')
            P1_deck_edit(6,'Ewok')
            P1_deck_edit(7,'BabyYoda')
            P1_deck_edit(8,'JediKnightLuke')
            P1_deck_edit(9,'BenKenobi')
            P1_deck_edit(10,'R2D2')
            P1_deck_edit(11,'C3P0')
            P1_deck_edit(12,'FarmboyLuke')
            P1_deck_edit(13,'HanSoloOld')
            P1_deck_edit(14,'CaptainRex')
            P1_deck_edit(15,'TheMandalorian')
            P1_deck_edit(16,'Chewbacca')
            P1_deck_edit(17,'Hondo')
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
