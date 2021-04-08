Weapon = Class{__includes = BaseState}

function Weapon:init(x,y,weapon,team,xoffset,yoffset)
    self.alive = true
    self.team = team
    self.xoffset = xoffset
    self.yoffset = yoffset
    if self.team == 1 then
        self.x = x + self.xoffset
        self.angle = math.rad(30)
    else
        self.x = x
        self.angle = math.rad(-30)
    end

    self.y = y
    self.image = weapon
end

function Weapon:updateposition(x,y)
    if self.team == 1 then
        self.x = x + self.xoffset
    else
        self.x = x
    end
    self.y = y
end

function Weapon:update(dt)
    if timer > 6 then
        if timer < 6.5 then
            if self.team == 1 then
                self.angle = self.angle + dt * 2
            else
                self.angle = self.angle - dt * 2
            end
        elseif timer < 7 then
            if self.team == 1 then
                self.angle = self.angle - dt * 2
            else
                self.angle = self.angle + dt * 2
            end
        else
            if self.team == 1 then
                self.angle = math.rad(30)
            else
                self.angle = math.rad(-30)
            end
            timer = 6
        end
    end
end

function Weapon:render()
    love.graphics.draw(self.image,self.x,self.y,self.angle)
end