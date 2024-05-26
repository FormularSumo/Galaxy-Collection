ProjectileManager = Class{__includes = BaseState}

function ProjectileManager:init(name,team,xoffset,yoffset)
    self.projectileCount = name['projectileCount'] or 1

    self.projectiles = {}
    for i=1,self.projectileCount do
        if name['projectile' .. tostring(i)] then
            if not projectileImages[name['projectile'..tostring(i)]] then
                projectileImages[name['projectile'..tostring(i)]] = love.graphics.newImage('Graphics/'..name['projectile'..tostring(i)]..'.png')
            end
            self.projectiles[i] = Projectile(projectileImages[name['projectile'..tostring(i)]],team,xoffset,yoffset,name['range'..tostring(i)] or name['range'])
        else 
            self.projectiles[i] = Projectile(projectileImages[name['projectile1']],team,xoffset,yoffset,name['range'])
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