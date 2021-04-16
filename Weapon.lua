Weapon = Class{__includes = BaseState}

function Weapon:init(x,y,column,row,weapon,team,xoffset,yoffset,character_range)
    self.alive = true
    self.team = team
    self.xoffset = xoffset
    self.yoffset = yoffset
    self.column = column
    self.row = row
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
    self.width,self.height = self.image:getDimensions()

    if self.image == Weapons['InquisitorLightsaber'] or self.image == Weapons['DoubleRedLightsaber'] or self.image == Weapons['DoubleBlueLightsaber'] or self.image == Weapons['DoubleGreenLightsaber'] or self.image == Weapons['DoubleYellowLightsaber'] then
        self.double = true
    else
        self.double = false
    end
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

function Weapon:updatetarget(target)
    self.target = target
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
    if (self.column == 5 or self.column == 6) and timer > 6.4 and self.target and (self.target.row == self.row or self.character_range == 1) then
        if self.double then
            if self.team == 1 then
                love.graphics.draw(self.image,self.x+self.height/4,self.y-self.height/5,self.angle,1,1,self.width/2,self.height/2)
            else
                love.graphics.draw(self.image,self.x-self.height/4,self.y-self.height/5,self.angle,1,1,self.width/2,self.height/2)
            end
        else
            love.graphics.draw(self.image,self.x,self.y,self.angle,1,1,self.width/2)
        end
    end
end