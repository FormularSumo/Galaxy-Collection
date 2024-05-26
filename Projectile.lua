Projectile = Class{__includes = BaseState}

function Projectile:init(name,team,xoffset,yoffset)
    self.projectileCount = name['projectileCount'] or 1

    self.Projectiles = {}
    for i=1,self.projectileCount do
        if name['projectile' .. tostring(i)] then
            if not projectileImages[name['projectile'..tostring(i)]] then
                projectileImages[name['projectile'..tostring(i)]] = love.graphics.newImage('Graphics/'..name['projectile'..tostring(i)]..'.png')
            end
            self.Projectiles[i] = Projectile2(projectileImages[name['projectile'..tostring(i)]],team,xoffset,yoffset,name['range'..tostring(i)] or name['range'])
        else 
            self.Projectiles[i] = Projectile2(projectileImages[name['projectile1']],team,xoffset,yoffset,name['range'])
        end
    end
end

function Projectile:hide()
    for k, pair in pairs(self.Projectiles) do
        pair.show = false
    end
end

function Projectile:fire(projectile,card,card2)
    self.Projectiles[projectile]:fire(card,card2)
end

function Projectile:fireall(card,card2)
    for k, pair in pairs(self.Projectiles) do
        pair:fire(card,card2)
    end
end

function Projectile:update(dt)
    for k, pair in pairs(self.Projectiles) do
        pair:update(dt)
    end
end

function Projectile:render()
    for k, pair in pairs(self.Projectiles) do
        pair:render()
    end
end