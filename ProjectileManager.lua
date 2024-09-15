ProjectileManager = Class{__includes = BaseState}

function ProjectileManager:init(name,team,xoffset,yoffset,graphics)
    self.projectileCount = name['projectileCount'] or 1

    self.projectiles = {}
    for i=1,self.projectileCount do
        local nameString = 'projectile' .. tostring(i)
        if name[nameString] then
            if not graphics[name[nameString]] then
                graphics[name[nameString]] = love.graphics.newSpriteBatch(love.graphics.newImage('Graphics/'..name[nameString]..'.png'))
            end
            self.projectiles[i] = Projectile(team,xoffset,yoffset,name['range'..tostring(i)] or name['range'],graphics[name[nameString]],name[nameString])
        else 
            self.projectiles[i] = Projectile(team,xoffset,yoffset,name['range'],graphics[name['projectile1']],name['projectile1'])
        end
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

function ProjectileManager:hideProjectiles(graphics)
    for k, pair in pairs(self.projectiles) do
        pair:hideProjectile(graphics)
    end
end

function ProjectileManager:render(graphics)
    if graphics then
        for k, pair in pairs(self.projectiles) do
            pair:render(graphics)
        end
    end
end