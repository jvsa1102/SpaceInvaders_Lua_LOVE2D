--[[
    Classe filha de Entity

    Representa o jogador
]]
Player = Class{__includes = Entity}

Player.cooldown = 0
Player.speed = 0
Player.lives = 3
Player.doRender = true
Player.isRespawning = false
laser_sound = love.audio.newSource('sound/laser_shoot.wav', 'static')

function Player:update(dt, projectiles)
    if not self.isRespawning and self.isAlive then
        if love.keyboard.isDown('left') then
            if Player.speed <= PLAYER_MAX_SPEED then
                Player.speed = Player.speed + PLAYER_ACCELERATION * dt
            end
            self.x = math.max(0, self.x - Player.speed * dt)
        elseif love.keyboard.isDown('right') then
            if Player.speed <= PLAYER_MAX_SPEED then
                Player.speed = Player.speed + PLAYER_ACCELERATION * dt
            end
            self.x = math.min(VIRTUAL_W - SPRITE_SIZE ,self.x + Player.speed * dt)
        end
        if love.keyboard.isDown('space') and Player.cooldown <= 0  then
            love.audio.play(laser_sound)
            Player.cooldown = PLAYER_COOLDOWN
            table.insert(projectiles, Projectile(self.x + 7, self.y - PROJECTILE_LENGTH, 'up'))
        end
        if Player.speed > 0 and not love.keyboard.isDown('right') and not love.keyboard.isDown('left') then
            Player.speed = Player.speed - PLAYER_ACCELERATION * dt
        end
        
        Player.cooldown = Player.cooldown - dt
    end
end


