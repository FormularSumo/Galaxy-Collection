Button = Class{}

function Button:init(func,arg,text,font,bg_image,x,y,r,g,b,scroll,visible)
    self.func = func
    self.arg = arg
    self.font = font 
    self.scaling = 1
    self.centrex = x
    self.centrey = y
    if self.font == nil then 
        self.font = love.graphics.getFont()
    end
    self.text = love.graphics.newText(self.font,text)
    self.textwidth,self.textheight = self.text:getDimensions()
    self:update_text(text)

    self.has_picture = not(bg_image == nil)

    if self.has_picture == true then
        self.bg_image = love.graphics.newImage('Buttons/' .. bg_image .. '.png')
        self.imagewidth,self.imageheight = self.bg_image:getDimensions()
        if self.centrex == 'centre' then
            self.imagex = VIRTUAL_WIDTH / 2 - self.imagewidth / 2
        elseif self.centrex == 'centre_right' then
            self.imagex = VIRTUAL_WIDTH / 2 + 10
        elseif self.centrex == 'centre_left' then
            self.imagex = VIRTUAL_WIDTH / 2 - self.imagewidth - 10
        else
            self.imagex = x - (self.imagewidth - self.textwidth) / 2
        end
        if self.centrey == 'centre' then
            self.imagey = VIRTUAL_WIDTH / 2 - self.imageheight / 2
        else 
            self.imagey = y - (self.imageheight - self.textheight) / 2
        end
        self.height = math.max(self.imageheight,self.textheight)
        self.width = math.max(self.imagewidth,self.textwidth)
        self.y = math.min(self.imagey,self.texty)
        self.x = math.min(self.imagex,self.textx)
        self.finalimagey = self.imagey
        self.finaly = self.y
    end

    if r == nil then self.r = 1 else self.r = r end
    if g == nil then self.g = 1 else self.g = g end
    if b == nil then self.b = 1 else self.b = b end
    -- if visible == nil then self.visible = true else self.visible = visible end
    self.scroll = scroll
end

function Button:update_text(text,x,y)
    self.text = love.graphics.newText(self.font,text)
    self.textwidth,self.textheight = self.text:getDimensions()
    if x then self.centrex = x end
    if y then self.centrey = y end

    if self.centrex == 'centre' then
        self.textx = VIRTUAL_WIDTH / 2 - self.textwidth / 2
    elseif self.centrex == 'centre_right' then
        self.textx = VIRTUAL_WIDTH / 2 + 10
    elseif self.centrex == 'centre_left' then
        self.textx = VIRTUAL_WIDTH / 2 - self.textwidth - 10
    else
        self.textx = self.centrex
    end
    if self.centrey == 'centre' then
        self.texty = VIRTUAL_HEIGHT / 2 - self.textheight / 2
    else
        self.texty = self.centrey
    end

    if self.has_picture then
        self.height = math.max(self.imageheight,self.textheight)
        self.width = math.max(self.imagewidth,self.textwidth)
        self.y = math.min(self.imagey,self.texty)
        self.x = math.min(self.imagex,self.textx)
    else
        self.height = self.textheight
        self.width = self.textwidth
        self.y = self.texty
        self.x = self.textx
    end
    self.finaltexty = self.texty
    self.finaly = self.y
end

function Button:update()
    if mouseX > self.x and mouseX < self.x + self.width and mouseY > self.finaly and mouseY < self.finaly + self.height then
        mouseTouching = self
        if mouseLastX > self.x and mouseLastX < self.x + self.width and mouseLastY > self.finaly and mouseLastY < self.finaly + self.height then
            if love.mouse.buttonsPressed[1] and mouseTrapped == self then
                self.func(self.arg)
                mouseLastX = -1
                mouseLasty = -1
                if lastClickIsTouch then
                    mouseX = -1
                    mouseY = -1
                end
            end
            if mouseDown and (mouseTrapped == false or mouseTrapped == self) then
                self.scaling = 1.08
                mouseTrapped = self
            end
        else
            self.scaling = 1.04
            if mouseTrapped == self then
                mouseLastX = -1
                mouseLasty = -1
            end
        end
    else
        self.scaling = 1
    end
    if self.scroll then
        self.finaly = self.y + yscroll
        self.finaltexty = self.texty + yscroll
        if self.imagey then
            self.finalimagey = self.imagey + ycsroll
        end
    end
end

function Button:render()
    -- if self.visible then
        if self.bg_image ~= nil then
            love.graphics.draw(self.bg_image, self.imagex, self.finalimagey,0,self.scaling,self.scaling,(-1+self.scaling)/2*self.imagewidth,(-1+self.scaling)/2*self.imageheight)
        end
        if mouseTouching == self or mouseTrapped == self then
            love.graphics.setColor(66/255,169/255,229/255)
        else
            love.graphics.setColor(self.r,self.g,self.b)
        end
        love.graphics.draw(self.text, self.textx, self.finaltexty,0,self.scaling,self.scaling,(-1+self.scaling)/2*self.textwidth,(-1+self.scaling)/2*self.textheight)
        love.graphics.setColor(1,1,1)
    -- end
end