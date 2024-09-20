WeaponManager = Class{__includes = BaseState}

function WeaponManager:init(name,team,xoffset,yoffset,card,graphics)
    self.show = false
    self.weaponCount = name['weaponCount'] or 1

    local xoffset = xoffset + (love.math.random()-0.5) * 10
    local yoffset = yoffset + (love.math.random()-0.5) * 30 

    self.weapons = {}
    local weaponNumber = 1
    for i=1,self.weaponCount do
        local nameString = name['weapon' .. tostring(i)]
        if nameString then
            if not graphics[name['weapon'..tostring(i)]] then
                graphics[name['weapon'..tostring(i)]] = love.graphics.newSpriteBatch(love.graphics.newImage('Graphics/'..nameString..'.png'))
            end
            self.weapons[i] = Weapon(weaponNumber,team,xoffset,yoffset,card,graphics[nameString],nameString)
        else 
            self.weapons[i] = Weapon(weaponNumber,team,xoffset,yoffset,card,graphics[name['weapon1']],name['weapon1'])
        end

        if not self.weapons[i].shield then
            weaponNumber = weaponNumber + 1
        end

    end
end

function WeaponManager:visibility(visibility)
    if self.show ~= visibility then
        self.show = visibility
        if self.show == false then
            self:hideWeapons(gStateMachine.current.graphics)
        end
    end
end

function WeaponManager:hideWeapons(graphics)
    for k, pair in pairs(self.weapons) do
        pair:hideWeapon(graphics)
    end
end

function WeaponManager:render(graphics,angle)
    if self.show then
        for k, pair in pairs(self.weapons) do
            pair:render(graphics,angle)
        end
    end
end