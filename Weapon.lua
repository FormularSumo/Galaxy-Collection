Weapon = Class{__includes = BaseState}

function Weapon:init(x,y,weapon,team,xoffset,yoffset)
    self.alive = true
    self.team = team
    if self.team == 1 then
        self.x = x
        self.angle = math.deg(30)
    else
        self.x = x
        self.angle = math.deg(-30)
    end

    self.y = y + yoffset
    self.image = weapon
    self.timer = 0
end

function Weapon:update(dt)
    self.timer = self.timer + dt
    if self.timer < 0.5 then
        if self.team == 1 then
            self.angle = self.angle + dt * 2
        else
            self.angle = self.angle - dt * 2
        end
    elseif self.timer < 1 then
        if self.team == 1 then
            self.angle = self.angle - dt * 2
        else
            self.angle = self.angle + dt * 2
        end
    else
        if self.team == 1 then
            self.angle = math.deg(30)
        else
            self.angle = math.deg(-30)
        end
        self.timer = 0
    end
end

function Weapon:render()
    love.graphics.draw(self.image,self.x,self.y,self.angle)
end