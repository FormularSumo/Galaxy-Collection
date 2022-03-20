Slider = Class{}

function Slider:init(x,y,width,height,func,r1,g1,b1,r2,g2,b2,percentage,trap,func2,default)
    self.width = width
    self.height = height

    if x == 'centre' then
        self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    else
        self.x = x 
    end
    if y == 'centre' then
        self.y = VIRTUAL_HEIGHT / 2 - self.height / 2
    else
        self.y = y 
    end


    self.func = func
    self.r1 = r1
    self.g1 = g1
    self.b1 = b1
    self.r2 = r2
    self.b2 = b2
    self.g2 = g2
    self.percentage = percentage
    self.func2 = func2
    if default == nil then
        self.default = true
    else
        self.default = default
    end
    if trap ~= nil then 
        self.trap3 = trap
        self.trap1 = trap - 0.03
        self.trap2 = trap + 0.03
    else 
        self.trap1 = 0
        self.trap2 = 0
        self.trap3 = 0
    end

    self.trap3 = (self.trap1 + self.trap2) / 2
    self.diameter_to_circle = 3
    self.radius_to_circle = self.diameter_to_circle / 2
    self.clickablex = self.x - self.height * self.radius_to_circle
    self.clickabley = self.y + self.height / 2 - self.height * self.radius_to_circle
    self.held_time = 0.5
end

function Slider:update(dt)
    if mouseX > self.clickablex and mouseX < self.clickablex + self.width + self.height * self.diameter_to_circle and mouseY > self.clickabley and mouseY < self.clickabley + self.height * self.diameter_to_circle then
        mouseTouching = self
        if mouseDown and love.mouse.isVisible() and mouseTrapped == false and mouseLastX > self.clickablex and mouseLastX < self.clickablex + self.width + self.height * self.diameter_to_circle and mouseLastY > self.clickabley and mouseLastY < self.clickabley + self.height * self.diameter_to_circle and not touchLocked then
            self.clicked = true
            mouseTrapped = self
        end
    end
    if self.clicked == true then    
        if mouseDown and love.mouse.isVisible() then
            self:update_percentage((mouseLastX - self.x) / self.width,true)
        else
            self.clicked = false
            if self.func2 ~= nil then
                self.func2()
            end
        end
    end

    if mouseTouching == self or (self.default and mouseTouching == false) then
        self:check_keys_down(dt,'left','right')
    end
    if self.default then
        self:check_keys_down(dt,'dpleft','dpright')
    end
end

function Slider:check_keys_down(dt,left,right)
    if (love.keyboard.wasDown(left) or love.keyboard.wasDown(right)) then
        if not (love.keyboard.wasDown(left) and love.keyboard.wasDown(right)) then
            self.held_time = self.held_time + dt
            if love.keyboard.wasDown(left) then
                self:update_percentage(self.percentage - (dt*self.held_time^3)/4,false)
            end
            if love.keyboard.wasDown(right) then
                self:update_percentage(self.percentage + (dt*self.held_time^3)/4,false)
            end
        else
            self:update_slider()
        end
        if love.mouse.isVisible() == false and left == 'left' then
            repositionMouse(self)
        end
    end
    if love.keyboard.wasReleased(left) or love.keyboard.wasReleased(right) then
        self:update_slider()
    end
end

function Slider:update_slider()
    self.held_time = 0.5
    if self.func2 ~= nil then
        self.func2()
    end
end
function Slider:update_percentage(percentage,trap)
    self.percentage = percentage
    if self.percentage < 0.001 then self.percentage = 0.001 
    elseif self.percentage > 1 then self.percentage = 1
    elseif self.percentage > self.trap1 and self.percentage < self.trap2 and trap == true then self.percentage = self.trap3 end
    self.func(self.percentage)
end

function Slider:render()
    love.graphics.setColor(self.r1,self.g1,self.b1)
    love.graphics.rectangle('fill',self.x,self.y,self.width,self.height,5)
    if (mouseTouching == self and not touchLocked) or mouseTrapped == self then
        love.graphics.setColor(66/255,169/255,229/255)
    else
        love.graphics.setColor(self.r2,self.g2,self.b2)
    end
    love.graphics.rectangle('fill',self.x,self.y,self.width*self.percentage,self.height,5)
    love.graphics.circle('fill',(self.x + (self.width*self.percentage)),(self.y + self.height / 2),self.height*self.radius_to_circle)
    love.graphics.setColor(1,1,1)
end