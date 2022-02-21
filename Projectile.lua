Projectile = Class{__includes = BaseState}

function Projectile:init(projectile,team,xoffset,yoffset)
    self.team = team
    self.image = projectile
    self.width,self.height = self.image:getDimensions()
    self.inverse = self.image == Projectiles['Force Drain']

    if self.team == 1 then
        self.xoffset = xoffset / 2 - self.width / 2
        self.yoffset = yoffset / 2 - self.height / 2
    else
        self.xoffset = xoffset / 2 + self.width / 2
        self.yoffset = yoffset / 2 + self.height / 2
    end
end

function Projectile:fire(card,card2)
    self.show = true

    if self.inverse then
        self.x = card2.x + self.xoffset
        self.finalx = card.targetx + self.xoffset
        self.y = card2.y + self.yoffset
        self.finaly = card.targety + self.yoffset
    else
        self.x = card.x + self.xoffset
        self.finalx = card2.targetx + self.xoffset
        self.y = card.y + self.yoffset
        self.finaly = card2.targety + self.yoffset
    end

    if (self.team == 1 and not self.inverse) or (self.team == 2 and self.inverse) then
        self.finalx = self.finalx - 20
    else
        self.finalx = self.finalx + 20
    end

    self.x_distance = tonumber(self.finalx-self.x)
    self.y_distance = tonumber(self.finaly-self.y)
    self.angle = math.atan(self.y_distance/self.x_distance)
    if self.team == 2 then self.angle = self.angle + math.rad(180) end
end

function Projectile:update(dt)
    if self.show then
        self.x = self.x + (self.x_distance * dt) / 0.9
        self.y = self.y + (self.y_distance * dt) / 0.9
    end
end

function Projectile:render()
    if self.show then
        love.graphics.draw(self.image,self.x,self.y,self.angle)
    end
end