Weapon = Class{__includes = BaseState}

function Weapon:init(name,team,xoffset,yoffset,card)
    self.show = false
    self.team = team

    self.weaponCount = name['weaponCount'] or 1

    self.Weapons = {}
    for i=1,self.weaponCount do
        if name['weapon' .. tostring(i)] then
            if not Weapons[name['weapon'..tostring(i)]] then
                Weapons[name['weapon'..tostring(i)]] = love.graphics.newImage('Graphics/'..name['weapon'..tostring(i)]..'.png')
            end
            self.Weapons[i] = Weapon2(Weapons[name['weapon'..tostring(i)]],i,team,xoffset,yoffset,card)
        else 
            self.Weapons[i] = Weapon2(Weapons[name['weapon1']],i,team,xoffset,yoffset,card)
        end
    end
end

function Weapon:render()
    if self.show then
        for k, pair in pairs(self.Weapons) do
            pair:render()
        end
    end
end