Button = Class{}

function Button:init(func,text,font,bg_image,x,y,render_gamestate)
    self.func = func
    self.textstring = text
    self.font = font 
    if self.font == nil then 
        self.font = love.graphics.getFont()
    end
    self.text = love.graphics.newText(self.font,self.textstring)
    self.render_gamestate = render_gamestate --Which gamestate should draw the button
    self.width,self.height = self.text:getDimensions()
    if x == 'centre' then
        self.textx = VIRTUAL_WIDTH / 2 - self.width / 2
    else 
        self.textx = x 
    end
    if y == 'centre' then
        self.texty = VIRTUAL_HEIGHT / 2 - self.height / 2
    else 
        self.texty = y 
    end

    if bg_image ~= nil then
        self.bg_image = love.graphics.newImage('Buttons/' .. bg_image .. '.png')
        self.imagewidth,self.imageheight = self.bg_image:getDimensions()
        if x == 'centre' then
            self.x = VIRTUAL_WIDTH / 2 - self.imagewidth / 2
        else 
            self.x = x - (self.imagewidth - self.width) / 2
        end
        if y == 'centre' then
            self.y = VIRTUAL_WIDTH / 2 - self.imageheight / 2
        else 
            self.y = y - (self.imageheight - self.height) / 2
        end
        self.width = self.imagewidth
        self.height = self.imageheight
    end
    if self.y == nil then self.y = self.texty end
    if self.x == nil then self.x = self.textx end
    self.scaling = 1
end

function Button:update()
    if love.mouse.buttonsPressed[1] and mouseLastX > self.x and mouseLastX < self.x + self.width and mouseLastY > self.y and mouseLastY < self.y + self.height then
        _G[self.func]()
    end
    if mouseDown and mouseLastX > self.x and mouseLastX < self.x + self.width and mouseLastY > self.y and mouseLastY < self.y + self.height then
        self.scaling = 1.1
    else
        self.scaling = 1
    end
end

function Button:render()
    if self.bg_image ~= nil then
        love.graphics.draw(self.bg_image, self.x, self.y,0,self.scaling,self.scaling,(-1+self.scaling)/2*self.imagewidth,(-1+self.scaling)/2*self.imageheight)
    end
    love.graphics.draw(self.text, self.textx, self.texty,0,self.scaling,self.scaling,(-1+self.scaling)/2*self.width,(-1+self.scaling)/2*self.height)
end