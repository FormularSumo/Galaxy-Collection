ProjectileManager = Class{__includes = BaseState}

function ProjectileManager:init(name,team,xoffset,yoffset,images,imagesInfo)
    self.projectileCount = name['projectileCount'] or 1

    self.projectiles = {}
    for i=1,self.projectileCount do
        local imageName;
        if name['projectile' .. tostring(i)] then
            imageName = 'Graphics/' .. name['projectile'..tostring(i)]
            self.projectiles[i] = Projectile(team,xoffset,yoffset,name['range'..tostring(i)] or name['range'],imageName)
        else
            imageName = 'Graphics/' .. name['projectile1']
            self.projectiles[i] = Projectile(team,xoffset,yoffset,name['range'],imageName)
        end

        if images[imageName] then
            self.projectiles[i]:init2(images[imageName])
        else
            if imagesInfo[imageName] then
                table.insert(imagesInfo[imageName][1],self.projectiles[i])
            else
                imagesInfo[imageName] = {{self.projectiles[i]}, false}
            end
        end
    end
end

function ProjectileManager:hide()
    for k, pair in pairs(self.projectiles) do
        pair.show = false
    end
end

function ProjectileManager:fire(projectile,card,card2)
    self.projectiles[projectile]:fire(card,card2)
end

function ProjectileManager:fireall(card,card2)
    for k, pair in pairs(self.projectiles) do
        pair:fire(card,card2)
    end
end

function ProjectileManager:update(dt)
    for k, pair in pairs(self.projectiles) do
        pair:update(dt)
    end
end

function ProjectileManager:render()
    for k, pair in pairs(self.projectiles) do
        pair:render()
    end
end