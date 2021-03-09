Laser = Class{__includes = BaseState}

function Laser:init(x,y,finalx,finaly,laser)
    self.alive = true
    self.x = x
    self.y = y
    self.finalx = x
    self.finaly = y
    self.laser = laser
    self.x_distance = math.abs(self.finalx-self.x)
    self.y_distance = math.abs(self.finaly-self.y)
    self.timer = 0
end

function Laser:update(dt)
    self.x = self.x + (self.x_distance * dt) / 100
    self.y = self.y + (self.y_distance * dt) / 100
    self.timer = self.timer + dt
end

function Laser:render()
    love.graphics.draw(self.laser,self.x,self.y)
end