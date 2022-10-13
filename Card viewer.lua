CardViewer = Class{__includes = BaseState}

function CardViewer:init(name,imageName,level,evolution,inDeck,number,mode)
    self.stats = Characters[name]
    self.statsOnDisplay = {}
    self.mode = mode or 'stats'

    if inDeck then
        gStateMachine.current.cardDisplayedNumber = number
    else
        gStateMachine.current.cardDisplayedNumber = number - gStateMachine.current.page * 18
    end
    gStateMachine.current.cardDisplayedInDeck = inDeck

    --Create image which toggles between displaying stats and description
    gui[1] = Button(function() if gui['CardViewer'].mode == 'stats' then gui['CardViewer'].mode = 'biography' else gui['CardViewer'].mode = 'stats' end end,nil,nil,imageName .. '.jpg',390,540)
    
    --Create biography
    if self.stats['biography'] then
        self.biography = Text(wrap(self.stats['biography'],40),font40SW,'centre',90)
        self.biography.x = self.biography.x + 270
    end

    --Create stats
    self.evolution = evolution
    self.modifier = ((level + (60 - level) / 1.7) / 60) * (1 - ((4 - evolution) * 0.1))
    self.y = 0

    self:createStat(math.floor(characterStrength({name,level,evolution})),'Overall strength')
    self.y = self.y + 30

    self:createStat(level,'Level')
    self:createStat(math.floor(Characters[name]['meleeOffense'] * self.modifier),'Melee Offense')
    if Characters[name]['rangedOffense'] then
        self:createStat(math.floor(Characters[name]['rangedOffense'] * self.modifier),'Ranged Offense')
    end
    self:createStat(math.floor(Characters[name]['defense'] * self.modifier),'Defense')
    self:createStat(Characters[name]['evade'],'Evade')
    self:createStat(Characters[name]['range'],'Range')

    self.y = self.y + 45

    if Characters[name].weaponCount then
        self.weapons = {}
        self.weapons[Characters[name]['weapon1']] = 1
        for i=2,Characters[name]['weaponCount'] do
            if Characters[name]['weapon'..tostring(i)] then
                if self.weapons[Characters[name]['weapon'..tostring(i)]] then
                    self.weapons[Characters[name]['weapon'..tostring(i)]] = self.weapons[Characters[name]['weapon'..tostring(i)]] + 1
                else
                    self.weapons[Characters[name]['weapon'..tostring(i)]] = 1
                end
            else
                self.weapons[Characters[name]['weapon1']] = self.weapons[Characters[name]['weapon1']] + 1
            end
        end
        self:createStat(nil,'weapons:',nil,font50SW)
        for k, pair in pairs(self.weapons) do
            self:createStat(k,pair .. 'x','weapon' .. k,font50SW)
        end
        self.y = self.y + 10
    elseif Characters[name]['weapon1'] then
        self:createStat(Characters[name]['weapon1'],'weapon',nil,font50SW)
        self.y = self.y + 10
    end

    if Characters[name].projectileCount then
        self.projectiles = {}
        self.projectiles[Characters[name]['projectile1']] = 1
        for i=2,Characters[name]['projectileCount'] do
            if Characters[name]['projectile'..tostring(i)] then
                if self.projectiles[Characters[name]['projectile'..tostring(i)]] then
                    self.projectiles[Characters[name]['projectile'..tostring(i)]] = self.projectiles[Characters[name]['projectile'..tostring(i)]] + 1
                else
                    self.projectiles[Characters[name]['projectile'..tostring(i)]] = 1
                end
            else
                self.projectiles[Characters[name]['projectile1']] = self.projectiles[Characters[name]['projectile1']] + 1
            end
        end
        self:createStat(nil,'Projectiles:',nil,font50SW)
        for k, pair in pairs(self.projectiles) do
            self:createStat(k,pair .. 'x','projectile' .. k,font50SW)
        end
    elseif Characters[name]['projectile1'] then
        self:createStat(Characters[name]['projectile1'],'Projectile',nil,font50SW)
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
        self.y = self.y + 65
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