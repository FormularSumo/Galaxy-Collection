Text = Class{}

function Text:init(text,font,x,y,rgb,visible)
    self.font = font or love.graphics.getFont()
    
    self.centreX = x == 'centre'
    self.centreY = y == 'centre'

    self.text = love.graphics.newText(self.font,text)
    self.width,self.height = self.text:getDimensions()
    if self.centreX then
        self.x = VIRTUALWIDTH / 2 - self.width / 2
    else
        self.x = x
    end
    if self.centreY then
        self.y = VIRTUALHEIGHT / 2 - self.height / 2
    else
        self.y = y
    end

    self.rgb = rgb or {1,1,1}
    if visible == nil then self.visible = true else self.visible = visible end
end

function Text:updateText(text,font)
    if font then self.font = font end
    self.text = love.graphics.newText(self.font,text)
    self.width,self.height = self.text:getDimensions()
    if self.centreX then
        self.x = VIRTUALWIDTH / 2 - self.width / 2
    end
    if self.centreY then
        self.y = VIRTUALHEIGHT / 2 - self.height / 2
    end
end

function Text:update()
end

function Text:render()
    if self.visible then
        love.graphics.setColor(self.rgb)
        love.graphics.draw(self.text, self.x, self.y)
        love.graphics.setColor(1,1,1)
    end
end