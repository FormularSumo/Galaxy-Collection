Weapon = Class{__includes = BaseState}

function Weapon:init(name,team,xoffset,yoffset)
    self.show = false
    self.team = team
    if self.team == 1 then
        self.angle = math.rad(210)
    else
        self.angle = math.rad(150)
    end

    self.weaponCount = name['weaponCount'] or 1

    self.Weapons = {}
    for i=1,self.weaponCount do
        if name['weapon' .. tostring(i)] then
            if not Weapons[name['weapon'..tostring(i)]] then
                Weapons[name['weapon'..tostring(i)]] = love.graphics.newImage('Graphics/'..name['weapon'..tostring(i)]..'.png')
            end
            self.Weapons[i] = Weapon2(Weapons[name['weapon'..tostring(i)]],i,team,xoffset,yoffset)
        else 
            self.Weapons[i] = Weapon2(Weapons[name['weapon1']],i,team,xoffset,yoffset)
        end
    end
end

function Weapon:update(dt,x,y)
    if timer > 6.4 then
        if timer < 6.9 then
            if self.team == 1 and self.angle < math.rad(270) then
                self.angle = self.angle + dt * 2
            elseif self.angle > math.rad(90) then
                self.angle = self.angle - dt * 2
            end
        elseif timer < 7.4 then
            if self.team == 1 and self.angle > math.rad(210) then
                self.angle = self.angle - dt * 2
            elseif self.angle < math.rad(150) then
                self.angle = self.angle + dt * 2
            end
        end
        for k, pair in pairs(self.Weapons) do
            pair:update(x,y)
        end
    end
end

function Weapon:render()
    if timer > 6.4 and self.show then
        for k, pair in pairs(self.Weapons) do
            pair:render(self.angle)
        end
    end
end