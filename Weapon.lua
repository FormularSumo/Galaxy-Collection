Weapon = Class{__includes = BaseState}

function Weapon:init(x,y,column,weapon,weapon2,weapon3,weapon4,weapon_count,team,xoffset,yoffset)
    self.team = team
    self.xoffset = xoffset
    self.yoffset = yoffset
    self.column = column
    self.show = false
    if self.team == 1 then
        self.x = x + self.xoffset * 0.35
        self.angle = math.rad(210)
    else
        self.x = x + self.xoffset * 0.65
        self.angle = math.rad(150)
    end
    self.character_range = character_range

    self.y = y + self.yoffset * 0.7
    self.image = weapon
    if not weapon2 then self.image2 = weapon else self.image2 = weapon2 end
    if not weapon3 then self.image3 = weapon else self.image3 = weapon3 end
    if not weapon4 then self.image4 = weapon else self.image4 = weapon4 end

    self.width,self.height = self.image:getDimensions()

    if self.image == Weapons['InquisitorLightsaber'] or self.image == Weapons['DoubleRedLightsaber'] or self.image == Weapons['DoubleBlueLightsaber'] or self.image == Weapons['DoubleGreenLightsaber'] or self.image == Weapons['DoubleYellowLightsaber'] then
        self.double = true
    else
        self.double = false
    end
    if not weapon_count then self.weapon_count = 1 else self.weapon_count = weapon_count end
end

function Weapon:updateposition(x,y,column)
    if self.team == 1 then
        self.x = x + self.xoffset * 0.35
    else
        self.x = x + self.xoffset * 0.65
    end
    self.y = y + self.yoffset * 0.7
    self.column = column
end

function Weapon:update(dt)
    if timer > 6.4 then
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
            end
            if self.weapon_count > 2 then
                love.graphics.draw(self.image3,self.x,self.y-40,self.angle,1,1,self.width/2)
            end
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