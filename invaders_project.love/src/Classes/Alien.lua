--[[
    Classe filha de Entity

    Representa inimigos que se movem e atiram
]]
Alien = Class{__includes = Entity}

Alien.WalkMotion = 1
Alien.code = 0

function Alien:update(dt)
    
end

function Alien:fire(projectiles)
    table.insert(projectiles, Projectile(self.x + 7, self.y + SPRITE_SIZE + PROJECTILE_LENGTH, 'down'))
end

function Alien:render()
    if self.WalkMotion%2 == 0 then
        love.graphics.draw(gTextures['sprites'], gFrames['sprites'][self.sprites[2]], self.x, self.y)
    else
        love.graphics.draw(gTextures['sprites'], gFrames['sprites'][self.sprites[1]], self.x, self.y)
    end
end