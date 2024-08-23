WeaponManager = Class{__includes = BaseState}

function WeaponManager:init(name,team,xoffset,yoffset,card,images)
    self.show = false

    self.weaponCount = name['weaponCount'] or 1

    self.weapons = {}
    for i=1,self.weaponCount do
        if name['weapon' .. tostring(i)] then
            if not images[name['weapon'..tostring(i)]] then
                images[name['weapon'..tostring(i)]] = love.graphics.newImage('Graphics/'..name['weapon'..tostring(i)]..'.png')
            end
            self.weapons[i] = Weapon(i,team,xoffset,yoffset,card,images[name['weapon'..tostring(i)]],name['weapon'..tostring(i)])
        else 
            self.weapons[i] = Weapon(i,team,xoffset,yoffset,card,images[name['weapon1']],images[name['weapon1']])
        end
    end
end

function WeaponManager:render(angle)
    if self.show then
        for k, pair in pairs(self.weapons) do
            pair:render(angle)
        end
    end
end