WeaponManager = Class{__includes = BaseState}

function WeaponManager:init(name,team,xoffset,yoffset,card,images,imagesInfo)
    self.show = false

    self.weaponCount = name['weaponCount'] or 1

    self.weapons = {}
    for i=1,self.weaponCount do
        local imageName;
        if name['weapon' .. tostring(i)] then
            imageName = 'Graphics/' .. name['weapon'..tostring(i)]
        else
            imageName = 'Graphics/' .. name['weapon1']
        end
        self.weapons[i] = Weapon(i,team,xoffset,yoffset,card,imageName)

        if images[imageName] then
            self.weapons[i]:init2(images[imageName])
        else
            if imagesInfo[imageName] then
                table.insert(imagesInfo[imageName][1],self.weapons[i])
            else
                imagesInfo[imageName] = {{self.weapons[i]}, false}
            end
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