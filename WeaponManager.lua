WeaponManager = Class{__includes = BaseState}

function WeaponManager:init(name,team,xoffset,yoffset,card)
    self.show = false

    self.weaponCount = name['weaponCount'] or 1

    self.weapons = {}
    for i=1,self.weaponCount do
        if name['weapon' .. tostring(i)] then
            if not weaponImages[name['weapon'..tostring(i)]] then
                weaponImages[name['weapon'..tostring(i)]] = love.graphics.newImage('Graphics/'..name['weapon'..tostring(i)]..'.png')
            end
            self.weapons[i] = Weapon(weaponImages[name['weapon'..tostring(i)]],i,team,xoffset,yoffset,card)
        else 
            self.weapons[i] = Weapon(weaponImages[name['weapon1']],i,team,xoffset,yoffset,card)
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