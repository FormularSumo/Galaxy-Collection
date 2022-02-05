Weapon2 = Class{__includes = BaseState}

function Weapon2:init(image,number,team,xoffset,yoffset)
    self.team = team
    self.xoffset = xoffset
    self.yoffset = yoffset
    self.image = image
    self.number = number
    self.double = self.image == Weapons['Inquisitor Lightsaber'] or self.image == Weapons['Double Red Lightsaber'] or self.image == Weapons['Double Blue Lightsaber'] or self.image == Weapons['Double Green Lightsaber'] or self.image == Weapons['Double Yellow Lightsaber'] or self.image == Weapons['Double Purple Lightsaber'] or self.image == Weapons['Electrostaff'] or self.image == Weapons['Staff'] or self.image == Weapons['Kallus\' Bo-Rifle'] or self.image == Weapons['Bo-Rifle'] or self.image == Weapons['Phasma\'s Spear']
    self.short = self.image == Weapons['Dagger of Mortis'] or self.image == Weapons['Lightning'] or self.image == Weapons['Knife'] or self.image == Weapons['Flamethrower'] or self.image == Weapons['Truncheon'] or self.image == Weapons['Embo\'s Shield'] or self.image == Weapons['Tool 1'] or self.image == Weapons['Tool 2'] or self.image == Weapons['Kyuzo Petar'] or self.image == Weapons['Vine'] or self.image == Weapons['Sword'] or self.image == Weapons['Vibrosword'] or self.image == Weapons['Riot Control Baton'] or self.image == Weapons['Z6 Riot Control Baton'] or self.image == Weapons['Cane'] or self.image == Weapons['Shock Prod'] or self.image == Weapons['Fusioncutter'] or self.image == Weapons['Axe'] or self.image == Weapons['Spear']
    self.static = self.image == Weapons['Lightning'] or self.image == Weapons['Flamethrower'] or self.image == Weapons['Shock Prod'] or self.image == Weapons['Riot Control Shield']

    if self.static then
        if self.team == 1 then
            self.angle = 0
        else
            self.angle = math.rad(180)
        end
    end

    self.width,self.height = self.image:getDimensions()
    if self.double then self.yfinaloffset = self.height/2 end
end

function Weapon2:updateposition(x,y)
    --Modify X/Y position based on whether short and/or static
    if self.team == 1 then
        if not self.short then
            self.x = x + self.xoffset * 0.35
        elseif self.short and self.static then
            self.x = x + self.xoffset + self.width / 2
        else
            self.x = x + self.xoffset * 0.65
        end
    else
        if not self.short then
            self.x = x + self.xoffset * 0.65
        elseif self.short and self.static then
            self.x = x - self.width / 2
        else
            self.x = x + self.xoffset * 0.35
        end
    end
    if not self.short then
        self.y = y + self.yoffset * 0.7
    else
        if not self.static then
            self.y = y + self.yoffset * 0.6
        else
            self.y = y + self.yoffset * 0.5 - self.height / 2
        end
    end
    if self.static and self.team == 2 then
        self.y = self.y + self.height
    end


    --Modify X/Y position based on what number weapon is
    if self.double then
        if self.team == 1 then
            if self.number == 1 then
                self.x = self.x+self.height/4
                self.y = self.y-self.height/5
            else
                self.x = self.x+self.height/4+30
                self.y = self.y-self.height/5-20
            end
        else
            if self.number == 1 then
                self.x = self.x-self.height/4
                self.y = self.y-self.height/5
            else
                self.x = self.x-self.height/4-30
                self.y = self.y-self.height/5-20
            end
        end
    elseif self.number ~= 1 then
        if self.number == 2 then
            if self.team == 1 then
                self.x = self.x+40
                self.y = self.y-20
            else
                self.x = self.x-40
                self.y = self.y-20
            end
        elseif self.number == 3 then
            self.x = self.x
            self.y = self.y-40
        elseif self.number == 4 then
            if self.team == 1 then
                self.x = self.x+40
                self.y = self.y-60
            else
                self.x = self.x-40
                self.y = self.y-60
            end
        end
    end
end

function Weapon2:render(angle)
    if self.static then
        love.graphics.draw(self.image,self.x,self.y,self.angle,1,1,self.width/2,self.yfinaloffset)
    else
        love.graphics.draw(self.image,self.x,self.y,angle,1,1,self.width/2,self.yfinaloffset)
    end
end