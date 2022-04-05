Card = Class{__includes = BaseState}

function Card:init(card,team,number,column)
    self.team = team
    self.number = number

    self.stats = Characters[card[1]]
    self.level = card[2] or 1
    self.evolution = card[3] or 0

    if self.stats['filename'] then
        self.image = 'Characters/' .. self.stats['filename'] .. '/' .. self.stats['filename'] .. '.png'
    else
        self.image = 'Characters/' .. card[1] .. '/' .. card[1] .. '.png'
    end

    if cards[self.image] then
        self.image = cards[self.image]
    else
        cards[self.image] = love.graphics.newImage(self.image)
        self.image = cards[self.image]
    end
    self.width,self.height = self.image:getDimensions()
    self.health = 1000
    self.modifier = ((self.level + (60 - self.level) / 1.7) / 60) * (1 - ((4 - self.evolution) * 0.1))
    self.meleeOffense = self.stats['meleeOffense'] * (self.modifier)
    if self.stats['rangedOffense'] then
        self.rangedOffense = self.stats['rangedOffense'] * (self.modifier)
    else
        self.rangedOffense = self.meleeOffense
    end
    self.defense = self.stats['defense'] * (self.modifier)
    self.evade = self.stats['evade']
    self.range = self.stats['range']
    self.meleeOffenseStat = (self.meleeOffense/800)^4/2
    self.rangedOffenseStat = (self.rangedOffense/800)^4
    if self.stats['projectile1'] then
        self.projectile = Projectile(self.stats, self.team, self.width, self.height)
        self.rangedOffenseStat = self.rangedOffenseStat * self.projectile.projectileCount
    end

    if self.stats['weapon1'] then
        self.weapon = Weapon(self.stats, self.team, self.width, self.height, self)
    end

    self.meleeProjectile = (self.stats['projectile1'] == 'Lightning' or self.stats['projectile1'] == 'Force Blast' or self.stats['projectile1'] == 'Force Drain') and self.weapon == nil

    self.possibleTargets = {}
    self.targets = {}
    if self.team == 1 then
        self.enemyDeck = P2deck
    else
        self.enemyDeck = P1deck
    end

    self.column = column
    self.row = self.number % 6

    if self.team == 1 then
        self.targetX = ((VIRTUALWIDTH / 12) * self.column) + 22 - 20
    else
        self.targetX = ((VIRTUALWIDTH / 12) * self.column) + 22 + 20
    end

    self.x = self.targetX
    self.targetY = ((VIRTUALHEIGHT / 6) * self.row + (self.height / 48))
    self.y = self.targetY
end

function Card:distance(target)
    return math.abs(self.column - target.column) + math.abs(self.row - target.row)
end

function Card:move()
    if self.team == 1 then
        self.targetX = self.targetX + 160
        self.column = self.column + 1
    else
        self.targetX = self.targetX - 160
        self.column = self.column - 1
    end
end

function Card:move2()
    if self.team == 1 then
        if P1deck[self.number-6] == nil and self.number - 6 >= 0 then
            P1deck[self.number-6] = P1deck[self.number]
            P1deck[self.number] = nil
            self.number = self.number - 6
            self.targetX = self.targetX + 160
            self.column = self.column + 1
        end
    elseif P2deck[self.number-6] == nil and self.number - 6 >= 0 then
        P2deck[self.number-6] = P2deck[self.number]
        P2deck[self.number] = nil
        self.number = self.number - 6
        self.targetX = self.targetX - 160
        self.column = self.column - 1
    end
end


function Card:aim()
    self.meleeAttack = false
    if (self.column == 5 or self.column == 6) and self.enemyDeck[self.number] ~= nil and (self.enemyDeck[self.number].column == 6 or self.enemyDeck[self.number].column == 5) then
        self.targets[1] = self.number
        if self.meleeProjectile then
            self.projectile:fireall(self,self.enemyDeck[self.targets[1]])
        end
        self.meleeAttack = true
    elseif (self.column == 5 or self.column == 6) and (self.range == 1 or self.meleeOffenseStat > self.rangedOffenseStat) and (self.enemyDeck[self.number-1] ~= nil and ((self.enemyDeck[self.number-1].column == 6 or self.enemyDeck[self.number-1].column == 5)) or (self.enemyDeck[self.number+1] ~= nil and (self.enemyDeck[self.number+1].column == 6 or self.enemyDeck[self.number+1].column == 6))) then
        if self.enemyDeck[self.number-1] ~= nil then
            self.targets[1] = self.number-1
        elseif self.enemyDeck[self.number+1] ~= nil then 
            self.targets[1] = self.number+1
        end
        if self.meleeProjectile then
            self.projectile:fireall(self,self.enemyDeck[self.targets[1]])
        end
        self.meleeAttack = true
    elseif self.range > 1 then
        self.targets[1] = self:target(self.range)
        if self.projectile then
            if self.targets[1] then
                self.projectile.Projectiles[1]:fire(self,self.enemyDeck[self.targets[1]])
            end
            for k, pair in pairs(self.projectile.Projectiles) do
                if k > 1 then
                    self.targets[k] = self:target(pair.range)
                    if self.targets[k] then
                        pair:fire(self,self.enemyDeck[self.targets[k]])
                    end
                end
            end
        end
    end
    if self.weapon then
        self.weapon.show = self.meleeAttack
    end
end

function Card:target(range)
    for k, pair in pairs(self.possibleTargets) do
        self.possibleTargets[k] = nil
    end
    self.totalProbability = 0
    for k, pair in pairs(self.enemyDeck) do
        distance = self:distance(pair)
        if distance <= range then
            self.possibleTargets[k] = self.totalProbability + range/distance
            self.totalProbability = self.totalProbability + range/distance
        end
    end

    if self.totalProbability > 0 then
        self.rangedAttackRoll = love.math.random() * self.totalProbability
        for k, pair in pairs(self.possibleTargets) do
            if self.rangedAttackRoll < self.possibleTargets[k] then
                return k
            end
        end
    end
end

function Card:attack()
    for k, pair in pairs(self.targets) do
        self:attack2(pair)
        self.targets[k] = nil
    end
    if self.projectile then self.projectile:hide() end
end

function Card:attack2(target)
    self.attackRoll = love.math.random(100) / 100
    self.enemyDeck[target].attacksTaken = self.enemyDeck[target].attacksTaken + 1
    if self.attackRoll > self.enemyDeck[target].evade then
        if self.meleeAttack then self.offense = self.meleeOffense else self.offense = self.rangedOffense end
        self.damage = ((self.offense - self.enemyDeck[target].defense) / 800)
        if self.damage < 0 then self.damage = 0 end
        self.damage = (self.damage ^ 3)
        self.defenceDown = (self.offense / 100) * (self.offense / self.enemyDeck[target].defense) ^ 3
        if target ~= self.number and self.range == 1 then 
            self.damage = self.damage / 2 
            self.defenceDown = self.defenceDown / 2 
        end
        self.enemyDeck[target].health = self.enemyDeck[target].health - (self.damage + 1)
        if self.enemyDeck[target].defense > 0 then
            self.enemyDeck[target].defense = self.enemyDeck[target].defense - self.defenceDown
            if self.enemyDeck[target].defense < 0 then self.enemyDeck[target].defense = 0 end
        else
            self.enemyDeck[target].defense = 0
        end
    else
        self.enemyDeck[target].dodge = self.enemyDeck[target].dodge + 1
    end
end

function Card:update(dt)
    if self.projectile then
        self.projectile:update(dt)
    end

    if self.targetX > self.x then
        self.x = self.x + dt * 500
        if self.x > self.targetX then self.x = self.targetX end
    elseif self.targetX < self.x then
        self.x = self.x - dt * 500
        if self.x < self.targetX then self.x = self.targetX end
    end

    if self.targetY > self.y then
        self.y = self.y + dt * 500
        if self.y > self.targetY then self.y = self.targetY end
    elseif self.targetY < self.y then
        self.y = self.y - dt * 500
        if self.y < self.targetY then self.y = self.targetY end
    end
end

function Card:render()
    love.graphics.draw(self.image,self.x,self.y,0,1,sx)
    if self.evolution== 4 then
        love.graphics.draw(evolutionMax,self.x+self.width-evolutionMax:getWidth()-3,self.y+3)
    elseif self.evolution> 0 then
        love.graphics.draw(Evolution,self.x+5,self.y+2,math.rad(90))
        if self.evolution> 1 then
            love.graphics.draw(Evolution,self.x+6+Evolution:getHeight(),self.y+2,math.rad(90))
            if self.evolution> 2 then
                love.graphics.draw(Evolution,self.x+7+Evolution:getHeight()*2,self.y+2,math.rad(90))
            end
        end
    end
            
    if self.health < 1000 then
        love.graphics.setColor(0.3,0.3,0.3)
        love.graphics.rectangle('fill',self.x-2,self.y-4,self.width+4,10,5,5)
        if self.dodge == 0 then
            love.graphics.setColor(1,0.82,0)
        else
            self.colour = self.dodge / self.attacksTaken
            self.colour = self.colour + (1-self.colour) / 2 --Proportionally increases brightness of self.colour so it's between 0.5 and 1 rather than 0 and 1 
            love.graphics.setColor(self.colour,self.colour,self.colour)
        end
        love.graphics.rectangle('fill',self.x-2,self.y-4,(self.width+4)/(1000/self.health),10,5,5)
        love.graphics.setColor(1,1,1)
    end

    -- if self.number == 15 and self.team == 2 then
    --     if self.possibleTargets ~= nil then
    --         y = 100
    --         for k, pair in pairs(self.possibleTargets) do
    --             y = y + 100
    --             love.graphics.print(tostring(k) .. ' ' .. tostring(pair),0,y)
    --             love.graphics.print(self.rangedAttackRoll,800,100)
    --             love.graphics.print(self.totalProbability,0,100)
    --         end
    --     end
    --     love.graphics.print(self.stats,0,0)
    -- end

    -- if self.number == 2 and if self.team == 2 then
    --     love.graphics.print(self.attacksTaken)
    --     love.graphics.print(self.defense,0,100)
    -- end
    --     love.graphics.print(self.damage)
    --     love.graphics.print(self.defenceDown,0,100)
    --     love.graphics.print(self.defense,0,200)
    -- elseif self.team == 2 then
    --     love.graphics.print(self.damage,1600)
    --     love.graphics.print(self.defenceDown,1600,100)
    --     love.graphics.print(self.defense,1600,200)
    -- end       
    -- end
    
    -- love.graphics.line(VIRTUALWIDTH / 2,0,VIRTUALWIDTH / 2,VIRTUALHEIGHT)
    -- love.graphics.print(self.offense, self.x, self.y)
    -- love.graphics.print(self.defense, self.x, self.y)
    -- love.graphics.print(self.evade, self.x, self.y)
    -- love.graphics.print(tostring(self.y),100,0)
end