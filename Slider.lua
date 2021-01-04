Slider = Class{}

function Slider:init(x,y,width,height,func,r1,g1,b1,r2,g2,b2,percentage)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.func = func
    self.r1 = r1
    self.g1 = g1
    self.b1 = b1
    self.r2 = r2
    self.b2 = b2
    self.g2 = g2
    self.percentage = percentage
    self.diameter_to_circle = 3
    self.radius_to_circle = self.diameter_to_circle / 2
    self.clickablex = self.x - self.height * self.radius_to_circle
    self.clickabley = self.y + self.height / 2 - self.height * self.radius_to_circle
end

function Slider:update()
    if mouseDown and mouseLastX > self.clickablex and mouseLastX < self.clickablex + self.width + self.height * self.diameter_to_circle and mouseLastY > self.clickabley and mouseLastY < self.clickabley + self.height * self.diameter_to_circle then
        clicked = true
    end
    if clicked == true and mouseDown then
        self.percentage = (mouseLastX - self.x) / self.width
        if self.percentage < 0.001 then self.percentage = 0.001 
        elseif self.percentage > 1 then self.percentage = 1
        elseif self.percentage > 0.22 and self.percentage < 0.28 then self.percentage = 0.25 end
        _G[self.func](self.percentage)
    else
        clicked = false
    end
end

function Slider:render()
    love.graphics.setColor(self.r1,self.g1,self.b1)
    love.graphics.rectangle('fill',self.x,self.y,self.width,self.height,5)
    love.graphics.setColor(self.r2,self.g2,self.b2)
    love.graphics.rectangle('fill',self.x,self.y,self.width*self.percentage,self.height,5)
    love.graphics.circle('fill',(self.x + (self.width*self.percentage)),(self.y + self.height / 2),self.height*self.radius_to_circle)
    love.graphics.setColor(1,1,1)
end