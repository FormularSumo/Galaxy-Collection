Laser = Class{__includes = BaseState}

function Laser:init(x,y,finalx,finaly,laser,team,xoffset,yoffset)
    self.alive = true
    self.team = team
    if self.team == 1 then
        self.x = x + xoffset / 2
        self.finalx = finalx 
    else
        self.x = x
        self.finalx = finalx + xoffset / 2
    end

    self.y = y + yoffset / 2
    self.finaly = finaly + yoffset / 2

    self.image = laser
    self.x_distance = tonumber(self.finalx-self.x)
    self.y_distance = tonumber(self.finaly-self.y)
    self.angle = math.atan(self.y_distance/self.x_distance)
    if team == 2 then self.angle = self.angle + math.rad(180) end
    -- self.delay = math.random(0,4.5) / 10
    self.timer = 0
end

function Laser:update(dt)
    self.timer = self.timer + dt
    if self.timer > 0 then
        self.x = self.x + (self.x_distance * dt) --/ (1-self.delay)
        self.y = self.y + (self.y_distance * dt) --/ (1-self.delay)
    end
end

function Laser:render()
    if self.timer > 0 then
        love.graphics.draw(self.image,self.x,self.y,self.angle)
    end
end