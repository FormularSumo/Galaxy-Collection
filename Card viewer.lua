CardViewer = Class{__includes = BaseState}

function CardViewer:init(name,imageName,level,evolution,inDeck,number,parent,mode)
    self.name = name
    self.stats = Characters[name]
    self.statsOnDisplay = {}
    self.name = name
    self.level = level
    self.evolution = evolution
    self.mode = mode or 'stats'
    if self.mode == 'stats' then
        self:createStats()
    else
        self:createBiography()
    end

    if inDeck then
        gStateMachine.current.cardDisplayedNumber = number
        self.parent = parent
    else
        gStateMachine.current.cardDisplayedNumber = number - gStateMachine.current.page * 18
    end
    gStateMachine.current.cardDisplayedInDeck = inDeck

    --Create image which toggles between displaying stats and description
    gui[1] = Button(function() self:swapMode() end,nil,nil,imageName .. '.jpg',390,540)
end

function CardViewer:changeStat(stat, difference)
    if stat == 'Evolution' then
        if self.evolution + difference >= 0 and self.evolution + difference <= 4 then
            self.evolution = self.evolution + difference
            self:updateStats()
        end
    else
        if self.level + difference >= 1 and self.level + difference <= 60 then
            self.level = self.level + difference
            self:updateStats(true)
        end
    end
end

function CardViewer:updateStats(stat)
    self.modifier = ((self.level + (60 - self.level) / 1.7) / 60) * (1 - ((4 - self.evolution) * 0.1))

    if stat then
        self.statsOnDisplay['Level']:updateText('Level: ' .. self.level)
        self.statsOnDisplay['Level'].x = self.statsOnDisplay['Level'].x + 270
    end

    self.statsOnDisplay['Melee Offense']:updateText('Melee Offense: ' .. math.floor(self.stats['meleeOffense'] * self.modifier))
    self.statsOnDisplay['Melee Offense'].x = self.statsOnDisplay['Melee Offense'].x + 270
    if self.stats['rangedOffense'] then
        self.statsOnDisplay['Ranged Offense']:updateText('Ranged Offense: ' .. math.floor(self.stats['rangedOffense'] * self.modifier))
        self.statsOnDisplay['Ranged Offense'].x = self.statsOnDisplay['Ranged Offense'].x + 270
    end
    self.statsOnDisplay['Defense']:updateText('Defense: ' .. math.floor(self.stats['defense'] * self.modifier))
    self.statsOnDisplay['Defense'].x = self.statsOnDisplay['Defense'].x + 270
    self.statsOnDisplay['Overall Strength']:updateText('Overall Strength: ' .. math.floor(characterStrength({self.name,self.level,self.evolution})))
    self.statsOnDisplay['Overall Strength'].x = self.statsOnDisplay['Overall Strength'].x + 270
    
    self.statsUpdated = true
end

function CardViewer:saveStats()
    if gStateMachine.current.cardDisplayedInDeck then
        P1deckEdit(gStateMachine.current.cardDisplayedNumber,{self.name, self.level, self.evolution})
        self.parent.level = self.level
        self.parent.evolution = self.evolution
    else
        P1cardsEdit(gStateMachine.current.cardDisplayedNumber,{self.name, self.level, self.evolution})
        if not gStateMachine.current.sort then
            gStateMachine.current.sort = true
        end
    end
end

function CardViewer:swapMode()
    if self.mode == 'stats' then
        self.mode = 'biography'
        if self.biography == nil then
            self:createBiography()
        end
        if sandbox then
            gui['Evolution'].visible = false
            gui[3].visible = false
            gui[4].visible = false
            gui[5].visible = false
            gui[6].visible = false
            self.hiddenbuttons = {gui[3], gui[4]}
            gui[3] = gui[7]
            gui[4] = gui[8]
            gui[7] = nil
            gui[8] = nil
        end
    else
        self.mode = 'stats'
        if sandbox and gui[7] == nil then
            gui[7] = gui[3]
            gui[8] = gui[4]
        end
        if next(self.statsOnDisplay) == nil then
            self:createStats()
        elseif sandbox then
            gui[3] = self.hiddenbuttons[1]
            gui[4] = self.hiddenbuttons[2]
            gui['Evolution'].visible = true
            gui[3].visible = true
            gui[4].visible = true
            gui[5].visible = true
            gui[6].visible = true
        end
    end
end

function CardViewer:createBiography()
    if self.stats['biography'] then
        self.biography = Text(wrap(self.stats['biography'],40),font40SW,'centre',90)
        self.biography.x = self.biography.x + 270
    else
        self.biography = false
    end
end

function CardViewer:createStats()
    self.modifier = ((self.level + (60 - self.level) / 1.7) / 60) * (1 - ((4 - self.evolution) * 0.1))
    self.y = 0

    self:createStat(math.floor(characterStrength({self.name,self.level,self.evolution})),'Overall Strength')
    self.y = self.y + 30

    self:createStat(self.level,'Level')
    self:createStat(math.floor(self.stats['meleeOffense'] * self.modifier),'Melee Offense')
    if self.stats['rangedOffense'] then
        self:createStat(math.floor(self.stats['rangedOffense'] * self.modifier),'Ranged Offense')
    end
    self:createStat(math.floor(self.stats['defense'] * self.modifier),'Defense')
    self:createStat(self.stats['evade'],'Evade')
    self:createStat(self.stats['range'],'Range')

    self.y = self.y + 45

    if self.stats.weaponCount then
        self.weapons = {}
        self.weapons[self.stats['weapon1']] = 1
        for i=2,self.stats['weaponCount'] do
            if self.stats['weapon'..tostring(i)] then
                if self.weapons[self.stats['weapon'..tostring(i)]] then
                    self.weapons[self.stats['weapon'..tostring(i)]] = self.weapons[self.stats['weapon'..tostring(i)]] + 1
                else
                    self.weapons[self.stats['weapon'..tostring(i)]] = 1
                end
            else
                self.weapons[self.stats['weapon1']] = self.weapons[self.stats['weapon1']] + 1
            end
        end
        self:createStat(nil,'weapons:',nil,font50SW)
        for k, pair in pairs(self.weapons) do
            self:createStat(k,pair .. 'x','weapon' .. k,font50SW)
        end
        self.y = self.y + 15
    elseif self.stats['weapon1'] then
        self:createStat(self.stats['weapon1'],'weapon',nil,font50SW)
        self.y = self.y + 15
    end

    if self.stats.projectileCount then
        self.projectiles = {}
        self.projectiles[self.stats['projectile1']] = 1
        for i=2,self.stats['projectileCount'] do
            if self.stats['projectile'..tostring(i)] then
                if self.projectiles[self.stats['projectile'..tostring(i)]] then
                    self.projectiles[self.stats['projectile'..tostring(i)]] = self.projectiles[self.stats['projectile'..tostring(i)]] + 1
                else
                    self.projectiles[self.stats['projectile'..tostring(i)]] = 1
                end
            else
                self.projectiles[self.stats['projectile1']] = self.projectiles[self.stats['projectile1']] + 1
            end
        end
        self:createStat(nil,'Projectiles:',nil,font50SW)
        for k, pair in pairs(self.projectiles) do
            self:createStat(k,pair .. 'x','projectile' .. k,font50SW)
        end
    elseif self.stats['projectile1'] then
        self:createStat(self.stats['projectile1'],'Projectile',nil,font50SW)
    end

    if sandbox then
        gui['Evolution'] = Text('Evolution',font60SW,'centre',950)
        gui['Evolution'].x = gui['Evolution'].x + 270
        gui[3] = Button(function() self:changeStat('Level',-1) end,nil,nil,'Minus',1920/2+40,self.statsOnDisplay['Level'].y+self.statsOnDisplay['Level'].height/2,nil,nil,nil,nil,nil,true)
        gui[4] = Button(function() self:changeStat('Level',1) end,nil,nil,'Plus',1920/2+500,self.statsOnDisplay['Level'].y+self.statsOnDisplay['Level'].height/2,nil,nil,nil,nil,nil,true)
        gui[5] = Button(function() self:changeStat('Evolution',-1) end,nil,nil,'Minus',1920/2+20,950+gui['Evolution'].height/2,nil,nil,nil,nil,nil,true)
        gui[6] = Button(function() self:changeStat('Evolution',1) end,nil,nil,'Plus',1920/2+520,950+gui['Evolution'].height/2,nil,nil,nil,nil,nil,true)
    end
end

function CardViewer:createStat(stat, displayName, name, font)
    if name == nil then
        name = displayName
    end
    if font == nil then
        font = font60SW
        self.y = self.y + 70
    else
        self.y = self.y + 60
    end
    
    if stat then
        self.statsOnDisplay[name] = Text(displayName .. ': ' .. stat,font,'centre',self.y)
    else
        self.statsOnDisplay[name] = Text(displayName,font,'centre',self.y)
    end
    self.statsOnDisplay[name].x = self.statsOnDisplay[name].x + 270
end

function CardViewer:update()
end

function CardViewer:render()
    if self.mode == 'stats' then
        for k, pair in pairs(self.statsOnDisplay) do
            pair:render()
        end
    elseif self.biography then
        self.biography:render()
    end
end

function CardViewer:renderInFront()
    if self.evolution == 4 then
        love.graphics.draw(evolutionMaxBig,690+((600*(gui[1].scaling-1))/2)-evolutionMaxBig:getWidth()-12,(90+12)-((900*(gui[1].scaling-1))/2),0,gui[1].scaling,gui[1].scaling,(gui[1].scaling-1)/2*evolutionMaxBig:getWidth(),(gui[1].scaling-1)/2*evolutionMaxBig:getWidth())
    elseif self.evolution > 0 then
        love.graphics.draw(evolutionBig,690+((600*(gui[1].scaling-1))/2)-evolutionBig:getHeight()-4,(90+12)-((900*(gui[1].scaling-1))/2),math.rad(90),gui[1].scaling,gui[1].scaling,(gui[1].scaling-1)/2*evolutionBig:getWidth(),(gui[1].scaling-1)/2*evolutionBig:getWidth())
        if self.evolution > 1 then
            love.graphics.draw(evolutionBig,690+((600*(gui[1].scaling-1))/2)-evolutionBig:getHeight()*2-7,(90+12)-((900*(gui[1].scaling-1))/2),math.rad(90),gui[1].scaling,gui[1].scaling,(gui[1].scaling-1)/2*evolutionBig:getWidth(),(gui[1].scaling-1)/2*evolutionBig:getWidth())
            if self.evolution > 2 then
                love.graphics.draw(evolutionBig,690+((600*(gui[1].scaling-1))/2)-evolutionBig:getHeight()*3-10,(90+12)-((900*(gui[1].scaling-1))/2),math.rad(90),gui[1].scaling,gui[1].scaling,(gui[1].scaling-1)/2*evolutionBig:getWidth(),(gui[1].scaling-1)/2*evolutionBig:getWidth())
            end
        end
    end
end