WeaponManager = Class{__includes = BaseState}

function WeaponManager:init(name,team,xoffset,yoffset,card,graphics,imagesInfo)
    self.show = false
    self.weaponCount = name['weaponCount'] or 1

    self.weapons = {}
    for i=1,self.weaponCount do
        local imagePath
        local nameString = 'weapon' .. tostring(i)
        if name[nameString] then
            imagePath = 'Graphics/' .. name['weapon'..tostring(i)]
            self.weapons[i] = Weapon(i,team,xoffset,yoffset,card,name[nameString],imagePath)
        else
            nameString = 'weapon1'
            imagePath = 'Graphics/' .. name[nameString]
            self.weapons[i] = Weapon(i,team,xoffset,yoffset,card,name[nameString],imagePath)
        end

        if graphics[imagePath] then
            self.weapons[i]:init2(graphics[imagePath])
        else
            if imagesInfo[imagePath] then
                table.insert(imagesInfo[imagePath][1],self.weapons[i])
            else
                imagesInfo[imagePath] = {{self.weapons[i]}, false}
            end
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