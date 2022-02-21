Projectile = Class{__includes = BaseState}

function Projectile:init(projectile,team,xoffset,yoffset)
    self.team = team
    self.image = projectile
    self.xoffset = xoffset
    self.yoffset = yoffset
    self.width,self.height = self.image:getDimensions()
    self.inverse = self.image == Projectiles['Force Drain']
end

function Projectile:fire(x,y,finalx,finaly)
    self.show = true

    if self.inverse then
        tempx = x
        tempy = y
        x = finalx
        y = finaly
        finalx = tempx
        finaly = tempy
    end

    if self.team == 1 then
        self.x = x + self.xoffset / 2 - self.width / 2
        self.finalx = finalx + self.xoffset / 2 - self.width / 2
        self.y = y + self.yoffset / 2 - self.height / 2
        self.finaly = finaly + self.yoffset / 2 - self.height / 2
    else
        self.x = x + self.xoffset / 2 + self.width / 2
        self.finalx = finalx + self.xoffset / 2 + self.width / 2
        self.y = y + self.yoffset / 2 + self.height / 2
        self.finaly = finaly + self.yoffset / 2 + self.height / 2
    end

    self.x_distance = tonumber(self.finalx-self.x)
    self.y_distance = tonumber(self.finaly-self.y)
    self.angle = math.atan(self.y_distance/self.x_distance)
    if self.team == 2 then self.angle = self.angle + math.rad(180) end
end

function Projectile:update(dt)
    if self.show then
        self.x = self.x + (self.x_distance * dt)
        self.y = self.y + (self.y_distance * dt)
    end
end

function Projectile:render()
    if self.show then
        love.graphics.draw(self.image,self.x,self.y,self.angle)
    end
end