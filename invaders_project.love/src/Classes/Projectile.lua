--[[
    Classe de projéteis
]]

Projectile = Class{}

function Projectile:init(x, y, direction)
    self.x = x
    self.y = y
    self.direction = direction
end

function Projectile:update(dt)
    if self.direction == 'up' then
        self.y = self.y - PROJECTILE_SPEED * dt
    else
        self.y = self.y + ALIEN_PROJECTILE_SPEED * dt
    end
end

function Projectile:collide(entity)
    if self.direction == 'up' then
        if self.x > entity.x and self.x < entity.x + SPRITE_SIZE and self.y < entity.y + SPRITE_SIZE and self.y > entity.y then
            return true
        else
            return false
        end
    else
        if self.x > entity.x and self.x < entity.x + SPRITE_SIZE and self.y + PROJECTILE_LENGTH > entity.y and self.y < entity.y + SPRITE_SIZE then
            return true
        else
            return false
        end
    end
end

function Projectile:projectileCollide(projec)
    if self.direction == 'up' and projec.direction == 'down' then
        if self.y <= projec.y + PROJECTILE_LENGTH and self.x >= projec.x and self.x <= projec.x + 1 then
            return true
        else
            return false
        end
    end
    if self.direction == 'down' and projec.direction == 'up' then
        if self.y + PROJECTILE_LENGTH >= projec.y and self.x >= projec.x and self.x <= projec.x + 1 then
            return true
        else
            return false
        end
    end
end

function Projectile:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('fill', self.x, self.y, 1, PROJECTILE_LENGTH)
    love.graphics.setColor(1, 1, 1, 1)
end