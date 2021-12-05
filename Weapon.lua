Weapon = Class{__includes = BaseState}

function Weapon:init(x,y,weapon,weapon2,weapon3,weapon4,weapon_count,team,xoffset,yoffset)
    self.team = team
    self.xoffset = xoffset
    self.yoffset = yoffset
    self.show = false
    if not weapon_count then self.weapon_count = 1 else self.weapon_count = weapon_count end
    self.image = weapon
    self.double = self.image == Weapons['Inquisitor Lightsaber'] or self.image == Weapons['Double Red Lightsaber'] or self.image == Weapons['Double Blue Lightsaber'] or self.image == Weapons['Double Green Lightsaber'] or self.image == Weapons['Double Yellow Lightsaber'] or self.image == Weapons['Double Purple Lightsaber'] or self.image == Weapons['Electrostaff']
    self.short = self.image == Weapons['Dagger of Mortis'] or Weapons['Lightning'] or Weapons['Knife']
    self.static = self.image == Weapons['Lightning']

    if self.team == 1 then
        if self.static then
            self.angle = 0
        else
            self.angle = math.rad(210)
        end
    else
        if self.static then
            self.angle = math.rad(180)
        else
            self.angle = math.rad(150)
        end
    end

    if self.weapon_count > 1 then
        if not weapon2 then self.image2 = weapon else self.image2 = weapon2 end
        if self.weapon_count > 2 then
            if not weapon3 then self.image3 = weapon else self.image3 = weapon3 end
            if self.weapon_count > 3 then
                if not weapon4 then self.image4 = weapon else self.image4 = weapon4 end
            end
        end
    end

    self.width,self.height = self.image:getDimensions()
end

function Weapon:updateposition(x,y)
    if self.team == 1 and not self.short or self.team == 2 and self.short then
        self.x = x + self.xoffset * 0.35
    else
        self.x = x + self.xoffset * 0.65
    end
    if not self.short then
        self.y = y + self.yoffset * 0.7
    else
        if not self.static then
            self.y = y + self.yoffset * 0.6
        else
            self.y = y + self.yoffset * 0.5 - self.height / 2
        end
    end
    if self.static and self.team == 2 then
        self.y = self.y + self.height
    end
end

function Weapon:update(dt)
    if timer > 6.4 and not self.static then
        if timer < 6.9 then
            if self.team == 1 and self.angle < math.rad(270) then
                self.angle = self.angle + dt * 2
            elseif self.angle > math.rad(90) then
                self.angle = self.angle - dt * 2
            end
        elseif timer < 7.4 then
            if self.team == 1 and self.angle > math.rad(210) then
                self.angle = self.angle - dt * 2
            elseif self.angle < math.rad(150) then
                self.angle = self.angle + dt * 2
            end
        end
    end
end

function Weapon:render()
    if timer > 6.4 and self.show then
        if self.double then
            if self.team == 1 then
                love.graphics.draw(self.image,self.x+self.height/4,self.y-self.height/5,self.angle,1,1,self.width/2,self.height/2)
                if self.weapon_count > 1 then
                    love.graphics.draw(self.image2,self.x+self.height/4+30,self.y-self.height/5-20,self.angle,1,1,self.width/2,self.height/2)
                end
            else
                love.graphics.draw(self.image,self.x-self.height/4,self.y-self.height/5,self.angle,1,1,self.width/2,self.height/2)
                if self.weapon_count > 1 then
                    love.graphics.draw(self.image2,self.x-self.height/4-30,self.y-self.height/5-20,self.angle,1,1,self.width/2,self.height/2)
                end
            end
        else
            love.graphics.draw(self.image,self.x,self.y,self.angle,1,1,self.width/2)

            if self.weapon_count > 1 then
                if self.team == 1 then
                    love.graphics.draw(self.image2,self.x+40,self.y-20,self.angle,1,1,self.width/2)
                else
                    love.graphics.draw(self.image2,self.x-40,self.y-20,self.angle,1,1,self.width/2)
                end

                if self.weapon_count > 2 then
                    love.graphics.draw(self.image3,self.x,self.y-40,self.angle,1,1,self.width/2)

                    if self.weapon_count > 3 then
                        if self.team == 1 then
                            love.graphics.draw(self.image4,self.x+40,self.y-60,self.angle,1,1,self.width/2)
                        else
                            love.graphics.draw(self.image4,self.x-40,self.y-60,self.angle,1,1,self.width/2)
                        end
                    end
                end
            end
        end
    end
end