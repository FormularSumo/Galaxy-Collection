Weapon = Class{__includes = BaseState}

function Weapon:init(number,team,xoffset,yoffset,card,imageName,imagePath)
    self.number = number
    self.team = team
    self.xoffset = xoffset
    self.yoffset = yoffset
    self.card = card
    self.imagePath = imagePath

    self.double = imageName == 'Inquisitor Lightsaber' or imageName == 'Double Red Lightsaber' or imageName == 'Double Blue Lightsaber' or imageName == 'Double Green Lightsaber' or imageName == 'Double Yellow Lightsaber' or imageName == 'Double Purple Lightsaber' or imageName == 'Electrostaff' or imageName == 'Staff' or imageName == 'Kallus\' Bo-Rifle' or imageName == 'Bo-Rifle' or imageName == 'Phasma\'s Spear' or imageName == 'War Sword' or imageName == 'Chirrut\'s Staff'
    self.short = imageName == 'Lightning' or imageName == 'Flamethrower' or imageName == 'Nightbrother Weapon' or imageName == 'Nightsister Sword' or imageName == 'Yoda Lightsaber' or imageName == 'Vine' or imageName == 'Vibrosword' or imageName == 'Shock Prod' or imageName == 'Glaive' or imageName == 'Scepter' or imageName == 'War Club'
    self.superShort = imageName == 'Knife' or imageName == 'Spear' or imageName == 'Riot Control Baton' or imageName == 'Cane' or imageName == 'Fusioncutter' or imageName == 'Dagger of Mortis' or imageName == 'Truncheon' or imageName == 'Tool 1' or imageName == 'Tool 2' or imageName == 'Kyuzo Petar' or imageName == 'Z6 Riot Control Baton' or imageName == 'Axe'
    if imageName == 'Riot Control Shield' or imageName == 'Embo\'s Shield' then
        self.static = true
        self.shield = true
        gStateMachine.current.graphicsShields[imagePath] = true
    else
        self.static = imageName == 'Lightning' or imageName == 'Flamethrower' or imageName == 'Shock Prod' or imageName == 'Riot Control Shield'
        self.shield = false
    end
end

function Weapon:init2(imageSpriteBatch)
    self.imageSpriteIndex = imageSpriteBatch:add(0,0,0,0,0)
    self.width,self.height = imageSpriteBatch:getTexture():getDimensions()
    
    if self.double or self.shield then self.yoriginoffset = self.height/2 end

    --Modify X/Y offset based on whether short and/or static
    if self.shield then
        self.xoffset = self.xoffset * 0.97
        self.yoffset = self.yoffset * 0.4
    elseif not (self.short or self.superShort) then
        self.xoffset = self.xoffset * 0.35
        self.yoffset = self.yoffset * 0.7
    else   
        if self.static then
            self.xoffset = self.xoffset + self.width / 2
            self.yoffset = self.yoffset * 0.5 - self.height / 2
        elseif self.short then
            self.xoffset = self.xoffset * 0.65
            self.yoffset = self.yoffset * 0.6
        else
            self.xoffset = self.xoffset * 0.85      
            self.yoffset = self.yoffset * 0.6
        end
        if not self.xoffset then self.xoffset = 0 end
        if not self.yoffset then self.yoffset = 0 end
    end

    --Modify X/Y offset based on what number weapon is
    if self.double then
        self.xoffset = (math.min(self.xoffset + self.height / 4,115))
        self.yoffset = self.yoffset - self.height / 5
        if self.number ~= 1 then
            self.xoffset = (math.min(self.xoffset + 30,115))
            self.yoffset = self.yoffset - 20
        end
    elseif self.number ~= 1 and not self.shield then
        self.yoffset = self.yoffset - (self.number-1) * 20
        if self.number % 2 == 0 then
            if not self.short then self.xoffset = (math.min(self.xoffset + 40,115)) else self.xoffset = self.xoffset + 30 end
        end
    end

    --Flip weapon if on team 2
    if self.team == 2 then
        self.scalefactorx = -1
        self.xoffset = (115 - self.xoffset) --115 card width, mirrors for team 2 cards
    else
        self.scalefactorx = 1
    end
end

function Weapon:hideWeapon(graphics)
    if self.imageSpriteIndex then
        graphics[self.imagePath]:set(self.imageSpriteIndex,0,0,0,0,0)
    end
end

function Weapon:render(graphics,angle)
    if self.imageSpriteIndex then
        if self.static then
            graphics[self.imagePath]:set(self.imageSpriteIndex,self.card.x+self.xoffset,self.card.y+self.yoffset,0,self.scalefactorx,1,self.width/2,self.yoriginoffset)
        else
            graphics[self.imagePath]:set(self.imageSpriteIndex,self.card.x+self.xoffset,self.card.y+self.yoffset,angle,self.scalefactorx,1,self.width/2,self.yoriginoffset)
        end
    end
end