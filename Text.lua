Text = Class{}

function Text:init(text,font,x,y,r,g,b)
    self.font = font 
    
    if x == 'centre' then self.centrex = true else self.centrex = false end
    if y == 'centre' then self.centrey = true else self.centrey = false end
    
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
end

function Text:update_text(text)
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
    love.graphics.setColor(self.r,self.g,self.b)
    love.graphics.draw(self.text, self.x, self.y)
    love.graphics.setColor(1,1,1)
end