Weapon = Class{__includes = BaseState}

function Weapon:init(weapon1,weapon2,weapon3,weapon4,weapon_count,team,xoffset,yoffset)
    self.team = team
    self.xoffset = xoffset
    self.yoffset = yoffset
    self.show = false
    if not weapon_count then self.weapon_count = 1 else self.weapon_count = weapon_count end
    self.image = weapon

    if self.team == 1 then
        if self.static then
            self.angle = 0
        else
            self.angle = math.rad(210)
        end
    else
        if self.static then
            self.angle = math.rad(180)
        else
            self.angle = math.rad(150)
        end
    end

    self.Weapons = {}
    self.Weapons[1] = Weapon2(weapon1,1,team,xoffset,yoffset)

    if self.weapon_count > 1 then
        if not weapon2 then
            self.Weapons[2] = Weapon2(weapon1,2,team,xoffset,yoffset)
        else 
            self.Weapons[2] = Weapon2(weapon2,2,team,xoffset,yoffset)
        end
        if self.weapon_count > 2 then
            if not weapon3 then
                self.Weapons[3] = Weapon2(weapon1,3,team,xoffset,yoffset)
            else
                self.Weapons[3] = Weapon2(weapon3,3,team,xoffset,yoffset)
            end
            if self.weapon_count > 3 then
                if not weapon4 then
                    self.Weapons[4] = Weapon2(weapon2,4,team,xoffset,yoffset)
                else
                    self.Weapons[4] = Weapon2(weapon4,4,team,xoffset,yoffset)
                end
            end
        end
    end
end

function Weapon:updateposition(x,y)
    --Called when card is moved and position needs updating
    for k, pair in pairs(self.Weapons) do
        pair:updateposition(x,y)
    end
end

function Weapon:update(dt)
    if timer > 6.4 then
        if timer < 6.9 then
            if self.team == 1 and self.angle < math.rad(270) then
                self.angle = self.angle + dt * 2
            elseif self.angle > math.rad(90) then
                self.angle = self.angle - dt * 2
            end
        elseif timer < 7.4 then
            if self.team == 1 and self.angle > math.rad(210) then
                self.angle = self.angle - dt * 2
            elseif self.angle < math.rad(150) then
                self.angle = self.angle + dt * 2
            end
        end
    end
end

function Weapon:render()
    if timer > 6.4 and self.show then
        for k, pair in pairs(self.Weapons) do
            pair:render(self.angle)
        end
    end
end