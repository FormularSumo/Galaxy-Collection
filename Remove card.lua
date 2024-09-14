RemoveCard = Class{__includes = BaseState}

function RemoveCard:init()
    self.image = love.graphics.newImage('Buttons/Remove.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.x = VIRTUALWIDTH / 2 - self.width / 2
    self.y = 385
end

function RemoveCard:swap()
    P1strength = P1strength - characterStrength({mouseTrapped.name,mouseTrapped.level,mouseTrapped.evolution}) --Reduce deck strength by card removed, before card is set as blank

    --Edit card removed to be a blank card
    P1deck[mouseTrapped.number]:deleteEvolutionSprites()
    P1deck[mouseTrapped.number].name, P1deck[mouseTrapped.number].level, P1deck[mouseTrapped.number].evolution, P1deck[mouseTrapped.number].imagePath, P1deck[mouseTrapped.number].image, P1deck[mouseTrapped.number].deleting = 'Blank', nil, nil, 'blankCard', gStateMachine.current.images['blankCard'], nil

    if not sandbox then --Not necessary in sandbox as inventory does not change
        P1cardsEdit(-1,{mouseTrapped.name,mouseTrapped.level,mouseTrapped.evolution})
        gStateMachine.current:loadCards()
    end
    P1deckEdit(mouseTrapped.number,nil)
    collectgarbage()

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
    if mouseTrapped and mouseTrapped.inDeck and ((math.abs(mouseLastX - mousePressedX) > 10 or math.abs(mouseLastY - mousePressedY) > 10) or not love.mouse.isVisible())then
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