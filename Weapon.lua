Weapon = Class{__includes = BaseState}

function Weapon:init(x,y,column,weapon,team,xoffset,yoffset)
    self.alive = true
    self.team = team
    self.xoffset = xoffset
    self.yoffset = yoffset
    self.column = column
    if self.team == 1 then
        self.x = x + self.xoffset
        self.angle = math.rad(210)
    else
        self.x = x
        self.angle = math.rad(150)
    end

    self.y = y
    self.image = weapon
end

function Weapon:updateposition(x,y,column)
    if self.team == 1 then
        self.x = x + self.xoffset * 0.25
    else
        self.x = x + self.xoffset * 0.75
    end
    self.y = y + self.yoffset * 0.75
    self.column = column
end

function Weapon:updatetarget(target)
    self.target = target
end

function Weapon:update(dt)
    if timer > 6.5 then
        if timer < 7 then
            if self.team == 1 then
                self.angle = self.angle + dt * 2
            else
                self.angle = self.angle - dt * 2
            end
        elseif timer < 7.5 then
            if self.team == 1 then
                self.angle = self.angle - dt * 2
            else
                self.angle = self.angle + dt * 2
            end
        else
            if self.team == 1 then
                self.angle = math.rad(210)
            else
                self.angle = math.rad(-150)
            end
            timer = 6.5
        end
    end
end

function Weapon:render()
    if (self.column == 5 or self.column == 6) and timer > 6.5 and self.target then
        love.graphics.draw(self.image,self.x,self.y,self.angle)
    end
end