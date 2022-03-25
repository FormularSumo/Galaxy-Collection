Button = Class{}

function Button:init(func,arg,text,font,bgImage,x,y,r,g,b,scroll,visible)
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
    self:updateText(text)

    self.hasPicture = not(bgImage == nil)

    if self.hasPicture == true then
        self.bgImage = love.graphics.newImage('Buttons/' .. bgImage .. '.png')
        self.imagewidth,self.imageheight = self.bgImage:getDimensions()
        if self.centrex == 'centre' then
            self.imagex = VIRTUALWIDTH / 2 - self.imagewidth / 2
        elseif self.centrex == 'centre right' then
            self.imagex = VIRTUALWIDTH / 2 + 10
        elseif self.centrex == 'centre left' then
            self.imagex = VIRTUALWIDTH / 2 - self.imagewidth - 10
        else
            self.imagex = x - (self.imagewidth - self.textwidth) / 2
        end
        if self.centrey == 'centre' then
            self.intitalimagey = VIRTUALWIDTH / 2 - self.imageheight / 2
        else 
            self.intitalimagey = y - (self.imageheight - self.textheight) / 2
        end
        self.height = math.max(self.imageheight,self.textheight)
        self.width = math.max(self.imagewidth,self.textwidth)
        self.initialy = math.min(self.intitalimagey,self.initialtexty)
        self.x = math.min(self.imagex,self.textx)
        self.imagey = self.intitalimagey
        self.y = self.initialy
    end

    if r == nil then self.r = 1 else self.r = r end
    if g == nil then self.g = 1 else self.g = g end
    if b == nil then self.b = 1 else self.b = b end
    self.scroll = scroll
    if visible == nil then self.visible = true else self.visible = visible end
end

function Button:updateText(text,x,y,font)
    if font then self.font = font end
    self.text = love.graphics.newText(self.font,text)
    self.textwidth,self.textheight = self.text:getDimensions()
    if x then self.centrex = x end
    if y then self.centrey = y end

    if self.centrex == 'centre' then
        self.textx = VIRTUALWIDTH / 2 - self.textwidth / 2
    elseif self.centrex == 'centre right' then
        self.textx = VIRTUALWIDTH / 2 + 10
    elseif self.centrex == 'centre left' then
        self.textx = VIRTUALWIDTH / 2 - self.textwidth - 10
    else
        self.textx = self.centrex
    end
    if self.centrey == 'centre' then
        self.initialtexty = VIRTUALHEIGHT / 2 - self.textheight / 2
    else
        self.initialtexty = self.centrey
    end

    if self.hasPicture then
        self.height = math.max(self.imageheight,self.textheight)
        self.width = math.max(self.imagewidth,self.textwidth)
        self.initialy = math.min(self.intitalimagey,self.initialtexty)
        self.x = math.min(self.imagex,self.textx)
    else
        self.height = self.textheight
        self.width = self.textwidth
        self.initialy = self.initialtexty
        self.x = self.textx
    end
    self.texty = self.initialtexty
    self.y = self.initialy
end

function Button:update()
    if mouseX > self.x and mouseX < self.x + self.width and mouseY > self.y and mouseY < self.y + self.height then
        mouseTouching = self
        if mouseLastX > self.x and mouseLastX < self.x + self.width and mouseLastY > self.y and mouseLastY < self.y + self.height then
            if love.mouse.buttonsPressed[1] and mouseTrapped == self and not touchLocked then
                self.func(self.arg)
                mouseLastX = -1
                mouseLasty = -1
            end
            if mouseDown and (mouseTrapped == false or mouseTrapped == self) and not touchLocked then
                if not (self.scroll and lastClickIsTouch) then
                    self.scaling = 1.08
                end
                mouseTrapped = self
            end
        else
            if not (self.scroll and lastClickIsTouch) then
                self.scaling = 1.04
            end
            if mouseTrapped == self then
                mouseLastX = -1
                mouseLasty = -1
            end
        end
    else
        self.scaling = 1
    end
    if self.scroll then
        self.y = self.initialy + yscroll
        self.texty = self.initialtexty + yscroll
        if self.intitalimagey then
            self.imagey = self.intitalimagey + ycsroll
        end
    end
end

function Button:render()
    if self.visible then
        if self.bgImage ~= nil then
            love.graphics.draw(self.bgImage, self.imagex, self.imagey,0,self.scaling,self.scaling,(-1+self.scaling)/2*self.imagewidth,(-1+self.scaling)/2*self.imageheight)
        end
        if (mouseTouching == self or mouseTrapped == self) and not touchLocked and not(self.scroll and lastClickIsTouch) then
            love.graphics.setColor(66/255,169/255,229/255)
        else
            love.graphics.setColor(self.r,self.g,self.b)
        end
        love.graphics.draw(self.text, self.textx, self.texty,0,self.scaling,self.scaling,(-1+self.scaling)/2*self.textwidth,(-1+self.scaling)/2*self.textheight)
        love.graphics.setColor(1,1,1)
    end
end