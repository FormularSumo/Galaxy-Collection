Text = Class{}

function Text:init(text,font,x,y,r,g,b,visible)
    self.font = font 
    
    self.centrex = x == 'centre'
    self.centrey = y == 'centre'
    
    if self.font == nil then 
        self.font = love.graphics.getFont()
    end

    self.text = love.graphics.newText(self.font,text)
    self.width,self.height = self.text:getDimensions()
    if self.centrex then
        self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    else
        self.x = x
    end
    if self.centrey then
        self.y = VIRTUAL_HEIGHT / 2 - self.height / 2
    else
        self.y = y
    end

    if r == nil then self.r = 1 else self.r = r end
    if g == nil then self.g = 1 else self.g = g end
    if b == nil then self.b = 1 else self.b = b end
    if visible == nil then self.visible = true else self.visible = visible end
end

function Text:update_text(text,font)
    if font then self.font = font end
    self.text = love.graphics.newText(self.font,text)
    self.width,self.height = self.text:getDimensions()
    if self.centrex then
        self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    end
    if self.centrey then
        self.y = VIRTUAL_HEIGHT / 2 - self.height / 2
    end
end

function Text:update()
end

function Text:render()
    if self.visible then
        love.graphics.setColor(self.r,self.g,self.b)
        love.graphics.draw(self.text, self.x, self.y)
        love.graphics.setColor(1,1,1)
    end
end