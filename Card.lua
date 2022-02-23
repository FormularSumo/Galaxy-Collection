Card = Class{__includes = BaseState}

function Card:init(name,row,column,team,number,level,evolution)
    self.name = Characters[name]
    self.row = row
    self.column = column
    if self.name['filename'] then
        self.image = 'Characters/' .. self.name['filename'] .. '/' .. self.name['filename'] .. '.png'
    else
        self.image = 'Characters/' .. name .. '/' .. name .. '.png'
    end
    if Cards[self.image] then
        self.image = Cards[self.image]
    else
        Cards[self.image] = love.graphics.newImage(self.image)
        self.image = Cards[self.image]
    end
    self.width,self.height = self.image:getDimensions()
    self.x = ((VIRTUAL_WIDTH / 12) * self.column) + 22 - 20
    self.y = ((VIRTUAL_HEIGHT / 6) * self.row + (self.height / 48))
    if self.column > 5 then
        self.x = self.x + 40
    end
    self.targetx = self.x
    self.targety = self.y
    self.team = team
    self.number = number
    if not level then self.level = 1 else self.level = level end
    if not evolution then self.evolution = 0 else self.evolution = evolution end
    self.health = 1000
    self.modifier = ((self.level + (60 - self.level) / 1.7) / 60) * (1 - ((4 - self.evolution) * 0.1))
    self.melee_offense = self.name['melee_offense'] * (self.modifier)
    if self.name['ranged_offense'] then
        self.ranged_offense = self.name['ranged_offense'] * (self.modifier)
    else
        self.ranged_offense = self.melee_offense
    end
    self.defense = self.name['defense'] * (self.modifier)
    self.evade = self.name['evade']
    self.range = self.name['range']
    self.melee_offense_stat = (self.melee_offense/800)^4/2
    self.ranged_offense_stat = (self.ranged_offense/800)^4
    if self.name['projectile1'] then
        self.projectile = Projectile(self.name, self.team, self.width, self.height)
        self.ranged_offense_stat = self.ranged_offense_stat * self.projectile.projectile_count
    end

    if self.name['weapon1'] then
        self.weapon = Weapon(self.name, self.team, self.width, self.height)
    end

    self.melee_projectile = (self.name['projectile1'] == 'Lightning' or self.name['projectile1'] == 'Force Blast' or self.name['projectile1'] == 'Force Drain') and self.weapon == nil

    self.alive = true
    self.attack_roll = 0
    self.ranged_attack_roll = 0
    self.possible_targets = {}
    self.dodge = 0
    self.attacks_taken = 0
    if self.team == 1 then
        self.enemy_deck = P2_deck
    else
        self.enemy_deck = P1_deck
    end
    self.damage = 0
    self.defence_down = 0
    self.targets = {}
end

function Card:distance(target)
    return math.abs(self.column - self.enemy_deck[target].column) + math.abs(self.row - self.enemy_deck[target].row)
end

function Card:check_health()
    if self.health <= 0 and self.alive == true then
        if self.team == 1 then
            P1_deck[self.number] = nil
        else
            P2_deck[self.number] = nil
        end 
        self.alive = false
    end
end

function Card:move()
    if self.team == 1 then
        if (self.number < (5 - self.column) * 6) then
            self.column = self.column + 1
        elseif P1_deck[self.number-6] == nil and self.number - 6 >= 0 then
            self.column = self.column + 1
            P1_deck[self.number-6] = P1_deck[self.number]
            P1_deck[self.number] = nil
        end
    else
        if (self.number < (self.column - 6) * 6) then
            self.column = self.column - 1
        elseif P2_deck[self.number-6] == nil and self.number - 6 >= 0 then
            self.column = self.column - 1
            P2_deck[self.number-6] = P2_deck[self.number]
            P2_deck[self.number] = nil
        end
    end
    self.show = (self.column > -1 and self.column < 12)
end

function Card:position()
    self.targetx = ((VIRTUAL_WIDTH / 12) * self.column) + 22 - 20
    self.targety = ((VIRTUAL_HEIGHT / 6) * self.row + (self.height / 48))
    if self.column > 5 then
        self.targetx = self.targetx + 40
    end
    if timer > 6 then
        if self.team == 1 then
            self.number = self.row + (math.abs(6 - self.column)) * 6 - 6
        else
            self.number = self.row + (self.column - 5) * 6 - 6
        end
    else
        if self.team == 1 then
            self.number = self.row + (math.abs(6 - self.column - math.ceil(6 - timer))) * 6 - 6
        else
            self.number = self.row + (self.column - 5 - math.ceil(6 - timer)) * 6 - 6
        end
    end
    if not self.show then
        self.x = self.targetx
        self.y = self.targety
    end
end

function Card:aim()
    if self.show then
        self.melee_attack = false
        if (self.column == 5 or self.column == 6) and self.enemy_deck[self.number] ~= nil and (self.enemy_deck[self.number].column == 6 or self.enemy_deck[self.number].column == 5) then
            self.targets[1] = self.number
            if self.melee_projectile then
                self.projectile:fireall(self,self.enemy_deck[self.targets[1]])
            end
            self.melee_attack = true
        elseif (self.column == 5 or self.column == 6) and (self.range == 1 or self.melee_offense_stat > self.ranged_offense_stat) and (self.enemy_deck[self.number-1] ~= nil and ((self.enemy_deck[self.number-1].column == 6 or self.enemy_deck[self.number-1].column == 5)) or (self.enemy_deck[self.number+1] ~= nil and (self.enemy_deck[self.number+1].column == 6 or self.enemy_deck[self.number+1].column == 6))) then
            if self.enemy_deck[self.number-1] ~= nil then
                self.targets[1] = self.number-1
            elseif self.enemy_deck[self.number+1] ~= nil then 
                self.targets[1] = self.number+1
            end
            if self.melee_projectile then
                self.projectile:fireall(self,self.enemy_deck[self.targets[1]])
            end
            self.melee_attack = true
        elseif self.range > 1 then
            self.targets[1] = self:target(self.range)
            if self.projectile then
                if self.targets[1] then
                    self.projectile.Projectiles[1]:fire(self,self.enemy_deck[self.targets[1]])
                end
                for k, pair in pairs(self.projectile.Projectiles) do
                    if k > 1 then
                        self.targets[k] = self:target(pair.range)
                        if self.targets[k] then
                            pair:fire(self,self.enemy_deck[self.targets[k]])
                        end
                    end
                end
            end
        end
        if self.weapon then
            self.weapon.show = self.melee_attack
        end
    end
end

function Card:target(range)
    self.possible_targets = {}
    self.total_probability = 0
    for k, pair in pairs(self.enemy_deck) do
        distance = self:distance(k)
        if distance <= range then
            self.possible_targets[k] = self.total_probability + range/distance
            self.total_probability = self.total_probability + range/distance
        end
    end

    if self.total_probability > 0 then
        self.ranged_attack_roll = love.math.random() * self.total_probability
        for k, pair in pairs(self.possible_targets) do
            if self.ranged_attack_roll < self.possible_targets[k] then
                return k
            end
        end
    end
end

function Card:attack()
    if self.targets ~= {} then
        for k, pair in pairs(self.targets) do
            self:attack2(pair)
        end
        self.targets = {}
        if self.projectile then self.projectile:hide() end
    end
end

function Card:attack2(target)
    self.attack_roll = love.math.random(100) / 100
    self.enemy_deck[target].attacks_taken = self.enemy_deck[target].attacks_taken + 1
    if self.attack_roll > self.enemy_deck[target].evade then
        if self.melee_attack then self.offense = self.melee_offense else self.offense = self.ranged_offense end
        self.damage = ((self.offense - self.enemy_deck[target].defense) / 800)
        if self.damage < 0 then self.damage = 0 end
        self.damage = (self.damage ^ 3)
        self.defence_down = (self.offense / 100) * (self.offense / self.enemy_deck[target].defense) ^ 3
        if target ~= self.number and self.range == 1 then 
            self.damage = self.damage / 2 
            self.defence_down = self.defence_down / 2 
        end
        self.enemy_deck[target].health = self.enemy_deck[target].health - (self.damage + 1)
        if self.enemy_deck[target].defense > 0 then
            self.enemy_deck[target].defense = self.enemy_deck[target].defense - self.defence_down
            if self.enemy_deck[target].defense < 0 then self.enemy_deck[target].defense = 0 end
        else
            self.enemy_deck[target].defense = 0
        end
    else
        self.enemy_deck[target].dodge = self.enemy_deck[target].dodge + 1
    end
end

function Card:update(dt)
    if self.show then
        if self.projectile then
            self.projectile:update(dt)
        end
        if self.weapon then
            self.weapon:update(dt)
        end

        if self.targetx > self.x then
            self.x = self.x + dt * 500
            if self.x > self.targetx then self.x = self.targetx end
        elseif self.targetx < self.x then
            self.x = self.x - dt * 500
            if self.x < self.targetx then self.x = self.targetx end
        end

        if self.targety > self.y then
            self.y = self.y + dt * 500
            if self.y > self.targety then self.y = self.targety end
        elseif self.targety < self.y then
            self.y = self.y - dt * 500
            if self.y < self.targety then self.y = self.targety end
        end

        if self.weapon then
            self.weapon:updateposition(self.x,self.y)
        end
    end
end

function Card:render()
    if self.show then
        love.graphics.draw(self.image,self.x,self.y,0,1,sx)
        if self.evolution == 4 then
            love.graphics.draw(EvolutionMax,self.x+self.width-EvolutionMax:getWidth()-3,self.y+3)
        elseif self.evolution > 0 then
            love.graphics.draw(Evolution,self.x+5,self.y+2,math.rad(90))
            if self.evolution > 1 then
                love.graphics.draw(Evolution,self.x+6+Evolution:getHeight(),self.y+2,math.rad(90))
                if self.evolution > 2 then
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
                self.colour = self.dodge / self.attacks_taken
                self.colour = self.colour + (1-self.colour) / 2 --Proportionally increases brightness of self.colour so it's between 0.5 and 1 rather than 0 and 1 
                love.graphics.setColor(self.colour,self.colour,self.colour)
            end
            love.graphics.rectangle('fill',self.x-2,self.y-4,(self.width+4)/(1000/self.health),10,5,5)
            love.graphics.setColor(1,1,1)
        end
    end

    -- if self.number == 3 and self.team == 2 then
    --     love.graphics.print(self.modifier)
    --     love.graphics.print(self.offense,0,100)
    --     love.graphics.print(self.defense,0,200)
    -- end

    -- if self.number == 15 then
    --     if self.team == 1 then
    --         if self.possible_targets ~= nil then
    --             y = 100
    --             for k, pair in pairs(self.possible_targets) do
    --                 y = y + 100
    --                 love.graphics.print(tostring(k) .. ' ' .. tostring(pair),0,y)
    --                 love.graphics.print(self.ranged_attack_roll,800,100)
    --                 love.graphics.print(self.total_probability,0,100)
    --             end
    --         end
    --         love.graphics.print(self.name,0,0)
    --     end
    -- end

    -- if self.number == 2 then
    --     if self.team == 2 then
    --         love.graphics.print(self.attacks_taken)
    --         love.graphics.print(self.defense,0,100)
    --     end
    -- end
    --         love.graphics.print(self.damage)
    --         love.graphics.print(self.defence_down,0,100)
    --         love.graphics.print(self.defense,0,200)
    --     elseif self.team == 2 then
    --         love.graphics.print(self.damage,1600)
    --         love.graphics.print(self.defence_down,1600,100)
    --         love.graphics.print(self.defense,1600,200)
    --     end       
    -- end
    
    -- love.graphics.line(VIRTUAL_WIDTH / 2,0,VIRTUAL_WIDTH / 2,VIRTUAL_HEIGHT)
    -- love.graphics.print(self.offense, self.x, self.y)
    -- love.graphics.print(self.defense, self.x, self.y)
    -- love.graphics.print(self.evade, self.x, self.y)
    -- love.graphics.print(tostring(self.y),100,0)
end