RemoveCard = Class{__includes = BaseState}

function RemoveCard:init()
    self.image = love.graphics.newImage('Buttons/X.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.x = VIRTUALWIDTH / 2 - self.width / 2
    self.y = 740
end

function RemoveCard:swap()
    P1deck[mouseTrapped.number] = CardEditor('Blank',mouseTrapped.row,mouseTrapped.column,mouseTrapped.number,nil,nil,true)
    P1cardsEdit(-1,{mouseTrapped.name,mouseTrapped.level,mouseTrapped.evolution})
    P1deckEdit(mouseTrapped.number,nil)
    collectgarbage()
    gStateMachine.current:sortInventory()
    if love.mouse.isVisible() == false then
        if mouseTrapped.number < 6 then
            repositionMouse(gui[mouseTrapped.number+16])
        elseif mouseTrapped.number < 12 then
            repositionMouse(gui[mouseTrapped.number+4])
        else
            repositionMouse(gui[mouseTrapped.number-8])
        end
    end
    mouseTrapped = false
    mouseLocked = false
    mouseTrapped2 = false
end

function RemoveCard:update()
    if mouseTrapped and mouseTrapped.inDeck then
        self.visible = true
        if mouseX > self.x and mouseX < self.x + self.width and mouseY > self.y and mouseY < self.y + self.height then
            self.scaling = 1.04
            mouseTrapped.deleting = true
            if not love.mouse.isVisible() then
                mouseTouching = self
            end
            if love.mouse.buttonsReleased[1] then
                self:swap()
            end
        else
            self.scaling = 1
            mouseTrapped.deleting = false
        end
    else
        self.visible = false
    end
end

function RemoveCard:render()
    if self.visible then
        love.graphics.draw(self.image,self.x,self.y,0,self.scaling,self.scaling,(-1+self.scaling)/2*self.width,(-1+self.scaling)/2*self.height)
    end
end