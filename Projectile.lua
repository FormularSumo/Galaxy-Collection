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

function Projectile:fire(x,y,finalx,finaly)
    self.show = true

    if self.inverse then
        self.x = finalx + self.xoffset
        self.finalx = x + self.xoffset
        self.y = finaly + self.yoffset
        self.finaly = y + self.yoffset
    else
        self.x = x + self.xoffset
        self.finalx = finalx + self.xoffset
        self.y = y + self.yoffset
        self.finaly = finaly + self.yoffset
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