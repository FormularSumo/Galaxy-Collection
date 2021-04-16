Button = Class{}

function Button:init(func,arg,text,font,bg_image,x,y,r,g,b)
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

    if bg_image == nil then self.has_picture = false else self.has_picture = true end

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
    end

    if r == nil then self.r = 1 else self.r = r end
    if g == nil then self.g = 1 else self.g = g end
    if b == nil then self.b = 1 else self.b = b end
end

function Button:update_text(text)
    self.text = love.graphics.newText(self.font,text)
    self.textwidth,self.textheight = self.text:getDimensions()

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
end

function Button:update()
    if love.mouse.buttonsPressed[1] and mouseLastX > self.x and mouseLastX < self.x + self.width and mouseLastY > self.y and mouseLastY < self.y + self.height and mouseTrapped == self.func then
        _G[self.func](self.arg)
    end
    if mouseDown and mouseLastX > self.x and mouseLastX < self.x + self.width and mouseLastY > self.y and mouseLastY < self.y + self.height and (mouseTrapped == false or mouseTrapped == self.func) then
        self.scaling = 1.08
        mouseTrapped = self.func
    else
        self.scaling = 1
    end
end

function Button:render()
    if self.bg_image ~= nil then
        love.graphics.draw(self.bg_image, self.imagex, self.imagey,0,self.scaling,self.scaling,(-1+self.scaling)/2*self.imagewidth,(-1+self.scaling)/2*self.imageheight)
    end
    love.graphics.setColor(self.r,self.g,self.b)
    love.graphics.draw(self.text, self.textx, self.texty,0,self.scaling,self.scaling,(-1+self.scaling)/2*self.textwidth,(-1+self.scaling)/2*self.textheight)
    love.graphics.setColor(1,1,1)
end