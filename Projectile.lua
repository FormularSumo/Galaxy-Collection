Projectile = Class{__includes = BaseState}

function Projectile:init(team,xoffset,yoffset,range,image,imageName)
    self.team = team
    self.range = range
    self.image = image:add(0,0,0,0,0)
    self.width,self.height = image:getTexture():getDimensions()
    self.imageName = imageName

    if self.team == 1 then
        self.xoffset = xoffset / 2 - self.width / 2
        self.yoffset = yoffset / 2 - self.height / 2
    else
        self.xoffset = xoffset / 2 + self.width / 2
        self.yoffset = yoffset / 2 + self.height / 2
    end
    self.inverse = imageName == 'Force Drain'
end

function Projectile:fire(card,card2)
    self.show = true
    if self.inverse then
        self.x = card2.x + self.xoffset
        self.finalX = card.targetX + self.xoffset
        self.y = card2.y + self.yoffset
        self.finalY = card.targetY + self.yoffset
    else
        self.x = card.x + self.xoffset
        self.finalX = card2.targetX + self.xoffset
        self.y = card.y + self.yoffset
        self.finalY = card2.targetY + self.yoffset
    end

    if (self.team == 1 and not self.inverse) or (self.team == 2 and self.inverse) then
        self.finalX = self.finalX - 20
    else
        self.finalX = self.finalX + 20
    end

    self.xDistance = tonumber(self.finalX-self.x)
    self.yDistance = tonumber(self.finalY-self.y)
    self.angle = math.atan(self.yDistance/self.xDistance)
    if self.team == 2 then self.angle = self.angle + math.rad(180) end
end

function Projectile:update(dt)
    if self.show and self.image then
        self.x = self.x + (self.xDistance * dt) / 0.9
        self.y = self.y + (self.yDistance * dt) / 0.9
    end
end

function Projectile:hideProjectile(graphics)
    self.show = false
    graphics[self.imageName]:set(self.image,0,0,0,0,0)
end

function Projectile:render(graphics)
    if self.show then
        graphics[self.imageName]:set(self.image,self.x,self.y,self.angle)
    end
end