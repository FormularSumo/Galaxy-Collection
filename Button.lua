Button = Class{}

function Button:init(func,text,font,bg_image,x,y,r,g,b)
    self.func = func
    self.font = font 
    self.scaling = 1
    if bg_image == nil then self.has_picture = false else self.has_picture = true end
    if x == 'centre' then self.centrex = true else self.centrex = false end
    if y == 'centre' then self.centrey = true else self.centrey = false end
    if self.font == nil then 
        self.font = love.graphics.getFont()
    end

    self.text = love.graphics.newText(self.font,text)
    self.textwidth,self.textheight = self.text:getDimensions()
    if self.centrex then
        self.textx = VIRTUAL_WIDTH / 2 - self.textwidth / 2
    else
        self.textx = x
    end
    if self.centrey then
        self.texty = VIRTUAL_HEIGHT / 2 - self.textheight / 2
    else
        self.texty = y
    end

    if self.has_picture == true then
        self.bg_image = love.graphics.newImage('Buttons/' .. bg_image .. '.png')
        self.imagewidth,self.imageheight = self.bg_image:getDimensions()
        if x == 'centre' then
            self.imagex = VIRTUAL_WIDTH / 2 - self.imagewidth / 2
        else 
            self.imagex = x - (self.imagewidth - self.textwidth) / 2
        end
        if y == 'centre' then
            self.imagey = VIRTUAL_WIDTH / 2 - self.imageheight / 2
        else 
            self.imagey = y - (self.imageheight - self.textheight) / 2
        end
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
    if r == nil then self.r = 1 else self.r = r end
    if g == nil then self.g = 1 else self.g = g end
    if b == nil then self.b = 1 else self.b = b end
end

function Button:update_text(text)
    self.text = love.graphics.newText(self.font,text)
    self.textwidth,self.textheight = self.text:getDimensions()
    if self.centrex then
        self.textx = VIRTUAL_WIDTH / 2 - self.textwidth / 2
    end
    if self.centrey then
        self.texty = VIRTUAL_HEIGHT / 2 - self.textheight / 2
    end
    if self.has_picture then
        if self.centrex then
            self.imagex = VIRTUAL_WIDTH / 2 - self.imagewidth / 2
        else 
            self.imagex = self.textx - (self.imagewidth - self.textwidth) / 2
        end
        self.height = math.max(self.imageheight,self.textheight)
        self.width = math.max(self.imagewidth,self.textwidth)
        self.y = math.min(self.imagey,self.y)
        self.x = math.min(self.imagex,self.x)
    else
        self.height = self.textheight
        self.width = self.textwidth
        self.y = self.texty
        self.x = self.textx
    end
end

function Button:update()
    if love.mouse.buttonsPressed[1] and mouseLastX > self.x and mouseLastX < self.x + self.width and mouseLastY > self.y and mouseLastY < self.y + self.height and mouseTrapped == self.func then
        _G[self.func]()
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