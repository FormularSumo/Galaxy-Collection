Weapon2 = Class{__includes = BaseState}

function Weapon2:init(image,number,team,xoffset,yoffset)
    self.team = team
    self.xoffset = 0
    self.yoffset = 0
    self.image = image
    self.number = number
    self.double = self.image == Weapons['Inquisitor Lightsaber'] or self.image == Weapons['Double Red Lightsaber'] or self.image == Weapons['Double Blue Lightsaber'] or self.image == Weapons['Double Green Lightsaber'] or self.image == Weapons['Double Yellow Lightsaber'] or self.image == Weapons['Double Purple Lightsaber'] or self.image == Weapons['Electrostaff'] or self.image == Weapons['Staff'] or self.image == Weapons['Kallus\' Bo-Rifle'] or self.image == Weapons['Bo-Rifle'] or self.image == Weapons['Phasma\'s Spear'] or self.image == Weapons['War Sword'] or self.image == Weapons['Chirrut\'s Staff']
    self.short = self.image == Weapons['Dagger of Mortis'] or self.image == Weapons['Lightning'] or self.image == Weapons['Knife'] or self.image == Weapons['Flamethrower'] or self.image == Weapons['Truncheon'] or self.image == Weapons['Embo\'s Shield'] or self.image == Weapons['Tool 1'] or self.image == Weapons['Tool 2'] or self.image == Weapons['Kyuzo Petar'] or self.image == Weapons['Vine'] or self.image == Weapons['Sword'] or self.image == Weapons['Vibrosword'] or self.image == Weapons['Riot Control Baton'] or self.image == Weapons['Z6 Riot Control Baton'] or self.image == Weapons['Cane'] or self.image == Weapons['Shock Prod'] or self.image == Weapons['Fusioncutter'] or self.image == Weapons['Axe'] or self.image == Weapons['Spear']
    self.static = self.image == Weapons['Lightning'] or self.image == Weapons['Flamethrower'] or self.image == Weapons['Shock Prod'] or self.image == Weapons['Riot Control Shield']
    self.shield = self.image == Weapons['Riot Control Shield'] or self.image == Weapons['Embo\'s Shield']
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
end

function Weapon2:updateposition(x,y)
    self.x = x + self.xoffset
    self.y = y + self.yoffset
end

function Weapon2:render(angle)
    if self.static then
        love.graphics.draw(self.image,self.x,self.y,0,self.scalefactorx,1,self.width/2,self.yoriginoffset)
    else
        love.graphics.draw(self.image,self.x,self.y,angle,self.scalefactorx,1,self.width/2,self.yoriginoffset)
    end
end