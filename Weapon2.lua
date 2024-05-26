Weapon2 = Class{__includes = BaseState}

function Weapon2:init(image,number,team,xoffset,yoffset,card)
    self.team = team
    self.xoffset = 0
    self.yoffset = 0
    self.image = image
    self.number = number
    self.double = self.image == weaponImages['Inquisitor Lightsaber'] or self.image == weaponImages['Double Red Lightsaber'] or self.image == weaponImages['Double Blue Lightsaber'] or self.image == weaponImages['Double Green Lightsaber'] or self.image == weaponImages['Double Yellow Lightsaber'] or self.image == weaponImages['Double Purple Lightsaber'] or self.image == weaponImages['Electrostaff'] or self.image == weaponImages['Staff'] or self.image == weaponImages['Kallus\' Bo-Rifle'] or self.image == weaponImages['Bo-Rifle'] or self.image == weaponImages['Phasma\'s Spear'] or self.image == weaponImages['War Sword'] or self.image == weaponImages['Chirrut\'s Staff']
    self.short = self.image == weaponImages['Dagger of Mortis'] or self.image == weaponImages['Lightning'] or self.image == weaponImages['Knife'] or self.image == weaponImages['Flamethrower'] or self.image == weaponImages['Truncheon'] or self.image == weaponImages['Embo\'s Shield'] or self.image == weaponImages['Tool 1'] or self.image == weaponImages['Tool 2'] or self.image == weaponImages['Kyuzo Petar'] or self.image == weaponImages['Vine'] or self.image == weaponImages['Sword'] or self.image == weaponImages['Vibrosword'] or self.image == weaponImages['Riot Control Baton'] or self.image == weaponImages['Z6 Riot Control Baton'] or self.image == weaponImages['Cane'] or self.image == weaponImages['Shock Prod'] or self.image == weaponImages['Fusioncutter'] or self.image == weaponImages['Axe'] or self.image == weaponImages['Spear']
    self.static = self.image == weaponImages['Lightning'] or self.image == weaponImages['Flamethrower'] or self.image == weaponImages['Shock Prod'] or self.image == weaponImages['Riot Control Shield']
    self.shield = self.image == weaponImages['Riot Control Shield'] or self.image == weaponImages['Embo\'s Shield']
    if self.shield then self.static = true end

    self.width,self.height = self.image:getDimensions()
    if self.double or self.shield then self.yoriginoffset = self.height/2 end


    --Modify X/Y offset based on whether short and/or static
    if self.shield then
        self.xoffset = self.xoffset + xoffset * 0.95
        self.yoffset = self.yoffset + yoffset * 0.4
    elseif not self.short then
        self.xoffset = self.xoffset + xoffset * 0.35
        self.yoffset = self.yoffset + yoffset * 0.7
    else   
        if self.short and self.static then
            self.xoffset = self.xoffset + xoffset + self.width / 2
        else
            self.xoffset = self.xoffset + xoffset * 0.65
        end
        if not self.static then
            self.yoffset = self.yoffset + yoffset * 0.6
        else
            self.yoffset = self.yoffset + yoffset * 0.5 - self.height / 2
        end
    end

    --Modify X/Y offset based on what number weapon is
    if self.double then
        self.xoffset = self.xoffset + self.height / 4
        self.yoffset = self.yoffset - self.height / 5
        if self.number ~= 1 then
            self.xoffset = self.xoffset + 30
            self.yoffset = self.yoffset - 20
        end
    elseif self.number ~= 1 and not self.shield then
        self.yoffset = self.yoffset - (self.number-1) * 20
        if self.number % 2 == 0 then
            if not self.short then self.xoffset = self.xoffset + 40 else self.xoffset = self.xoffset + 30 end        
        end
    end

    --Flip weapon if on team 2
    if self.team == 2 then
        self.scalefactorx = -1
        self.xoffset = (115 - self.xoffset) ----115 card width, mirrors for team 2 cards
    else
        self.scalefactorx = 1
    end

    self.card = card
end

function Weapon2:render(angle)
    if self.static then
        love.graphics.draw(self.image,self.card.x+self.xoffset,self.card.y+self.yoffset,0,self.scalefactorx,1,self.width/2,self.yoriginoffset)
    else
        love.graphics.draw(self.image,self.card.x+self.xoffset,self.card.y+self.yoffset,angle,self.scalefactorx,1,self.width/2,self.yoriginoffset)
    end
end