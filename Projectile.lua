Projectile = Class{__includes = BaseState}

function Projectile:init(projectile1,projectile2,projecile3,projectile4,projectile_count,range,range2,range3,range4,team,xoffset,yoffset)
    if not projectile_count then self.projectile_count = 1 else self.projectile_count = projectile_count end

    self.Projectiles = {}
    self.Projectiles[1] = Projectile2(projectile1,team,xoffset,yoffset)

    if self.projectile_count > 1 then
        if not projectile2 then
            self.Projectiles[2] = Projectile2(projectile1,team,xoffset,yoffset,range)
        else 
            self.Projectiles[2] = Projectile2(projectile2,team,xoffset,yoffset,range2)
        end
        if self.projectile_count > 2 then
            if not projecile3 then
                self.Projectiles[3] = Projectile2(projectile1,team,xoffset,yoffset,range)
            else
                self.Projectiles[3] = Projectile2(projectile3,team,xoffset,yoffset,range3)
            end
            if self.projectile_count > 3 then
                if not projectile4 then
                    self.Projectiles[4] = Projectile2(projectile1,team,xoffset,yoffset,range)
                else
                    self.Projectiles[4] = Projectile2(projectile4,team,xoffset,yoffset,range4)
                end
            end
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