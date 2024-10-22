Button = Class{}

function Button:init(func,text,font,bgImage,x,y,rgb,scroll,visible,held,flip)
    self.func = func
    self.font = font or love.graphics.getFont()
    self.scaling = 1
    self.centreX = x
    self.centreY = y
    if pcall(text) then
        self.textConstructor = text
        text = text()
    end
    self.text = love.graphics.newText(self.font,text)
    self.textWidth,self.textHeight = self.text:getDimensions()
    self:updateText(text)

    self.hasPicture = not(bgImage == nil)

    if self.hasPicture == true then
        if type(bgImage) == "string" then
            if love.filesystem.getInfo(bgImage) then
                self.bgImage = love.graphics.newImage(bgImage)
            else
                self.bgImage = love.graphics.newImage('Buttons/' .. bgImage .. '.png')
            end
        else
            self.bgImage = bgImage
        end
        self.imageWidth,self.imageHeight = self.bgImage:getDimensions()
        if self.centreX == 'centre' then
            self.imageX = VIRTUALWIDTH / 2 - self.imageWidth / 2
        elseif self.centreX == 'centre right' then
            self.imageX = VIRTUALWIDTH / 2 + 10
        elseif self.centreX == 'centre left' then
            self.imageX = VIRTUALWIDTH / 2 - self.imageWidth - 10
        else
            self.imageX = x - (self.imageWidth - self.textWidth) / 2
        end
        if self.centreY == 'centre' then
            self.intitalImageY = VIRTUALWIDTH / 2 - self.imageHeight / 2
        else 
            self.intitalImageY = y - (self.imageHeight - self.textHeight) / 2
        end
        self.height = math.max(self.imageHeight,self.textHeight)
        self.width = math.max(self.imageWidth,self.textWidth)
        self.initialY = math.min(self.intitalImageY,self.initialTextY)
        self.x = math.min(self.imageX,self.textX)
        self.imageY = self.intitalImageY
        self.y = self.initialY
    end

    self.rgb = rgb or {1,1,1}
    self.scroll = scroll
    if visible == nil then self.visible = true else self.visible = visible end
    if held == true then self.timer = 0 end
    self.flip = flip
    if flip then
        self.imageX = self.imageX + self.imageWidth
        self.imageY = self.imageY + self.imageHeight
        self.imageRotation = math.rad(180)
    else
        self.imageRotation = 0
    end
end

function Button:updateText(text,x,y,font)
    self.font = font or self.font
    self.text = love.graphics.newText(self.font,text)
    self.textWidth,self.textHeight = self.text:getDimensions()
    self.centreX = x or self.centreX
    self.centreY = y or self.centreY

    if self.centreX == 'centre' then
        self.textX = VIRTUALWIDTH / 2 - self.textWidth / 2
    elseif self.centreX == 'centre right' then
        self.textX = VIRTUALWIDTH / 2 + 10
    elseif self.centreX == 'centre left' then
        self.textX = VIRTUALWIDTH / 2 - self.textWidth - 10
    else
        self.textX = self.centreX
    end
    if self.centreY == 'centre' then
        self.initialTextY = VIRTUALHEIGHT / 2 - self.textHeight / 2
    else
        self.initialTextY = self.centreY
    end

    if self.hasPicture then
        self.height = math.max(self.imageHeight,self.textHeight)
        self.width = math.max(self.imageWidth,self.textWidth)
        self.initialY = math.min(self.intitalImageY,self.initialTextY)
        self.x = math.min(self.imageX,self.textX)
    else
        self.height = self.textHeight
        self.width = self.textWidth
        self.initialY = self.initialTextY
        self.x = self.textX
    end
    self.textY = self.initialTextY
    self.y = self.initialY
    if mouseTouching == self and not love.mouse.isVisible() then
        repositionMouse(self)
    end
end

function Button:toggle()
    if self.textConstructor then self:updateText(self.textConstructor()) end
end

function Button:update(dt)
    if self.visible and self.func then
        if mouseX > self.x and mouseX < self.x + self.width and mouseY > self.y and mouseY < self.y + self.height then
            mouseTouching = self
            if mouseLastX > self.x and mouseLastX < self.x + self.width and mouseLastY > self.y and mouseLastY < self.y + self.height then
                if love.mouse.buttonsReleased[1] and mouseTrapped == self and not touchLocked and not self.timer then
                    self.func()
                    mouseLastX = -1
                    mouseLasty = -1
                end
                if mouseDown and (mouseTrapped == false or mouseTrapped == self) and not touchLocked then
                    if not (self.scroll and lastClickIsTouch) then
                        self.scaling = 1.08
                    end
                    mouseTrapped = self
                    if self.timer then
                        if self.timer == 0 then self.func(self.arg) end
                        self.timer = self.timer + dt
                        if self.timer > 0.5 then
                            self.func()
                            self.timer = self.timer - 0.08
                        end
                    end
                else
                    if self.timer then self.timer = 0 end
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
            if self.timer then self.timer = 0 end
        end
        if self.scroll then
            self.y = self.initialY + yscroll
            self.textY = self.initialTextY + yscroll
            if self.intitalImageY then
                self.imageY = self.intitalImageY + yscroll
            end
        end
    end
end

function Button:render()
    if self.visible then
        if self.bgImage ~= nil then
            love.graphics.draw(self.bgImage, self.imageX, self.imageY,self.imageRotation,self.scaling,self.scaling,(-1+self.scaling)/2*self.imageWidth,(-1+self.scaling)/2*self.imageHeight)
        end
        if (mouseTouching == self or mouseTrapped == self) and not touchLocked and not(self.scroll and lastClickIsTouch) then
            love.graphics.setColor(66/255,169/255,229/255)
        else
            love.graphics.setColor(self.rgb)
        end
        love.graphics.draw(self.text, self.textX, self.textY,0,self.scaling,self.scaling,(-1+self.scaling)/2*self.textWidth,(-1+self.scaling)/2*self.textHeight)
        love.graphics.setColor(1,1,1)
    end
end