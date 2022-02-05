Projectile = Class{__includes = BaseState}

function Projectile:init(x,y,finalx,finaly,projectile,name,team,xoffset,yoffset)
    self.team = team
    self.image = projectile
    self.width,self.height = self.image:getDimensions()

    if self.team == 1 then
        if name ~= 'Force Drain' then
            self.x = x + xoffset / 2 - self.width / 2
            self.finalx = finalx + xoffset / 2 - self.width / 2
            self.y = y + yoffset / 2 - self.height / 2
            self.finaly = finaly + yoffset / 2 - self.height / 2
        else
            self.x = finalx + xoffset / 2 - self.width / 2
            self.finalx = x + xoffset / 2 - self.width / 2
            self.y = finaly + yoffset / 2 - self.height / 2
            self.finaly = y + yoffset / 2 - self.height / 2
        end
    else
        if name ~= 'Force Drain' then
            self.x = x + xoffset / 2 + self.width / 2
            self.finalx = finalx + xoffset / 2 + self.width / 2
            self.y = y + yoffset / 2 + self.height / 2
            self.finaly = finaly + yoffset / 2 + self.height / 2
        else
            self.x = finalx + xoffset / 2 + self.width / 2
            self.finalx = x + xoffset / 2 + self.width / 2
            self.y = finaly + yoffset / 2 + self.height / 2
            self.finaly = y + yoffset / 2 + self.height / 2
        end
    end

    self.x_distance = tonumber(self.finalx-self.x)
    self.y_distance = tonumber(self.finaly-self.y)
    self.angle = math.atan(self.y_distance/self.x_distance)
    if team == 2 then self.angle = self.angle + math.rad(180) end
end

function Projectile:update(dt)
    self.x = self.x + (self.x_distance * dt)
    self.y = self.y + (self.y_distance * dt)
end

function Projectile:render()
    love.graphics.draw(self.image,self.x,self.y,self.angle)
end