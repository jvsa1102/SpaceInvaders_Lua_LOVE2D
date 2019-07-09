--[[
    Arquivo Main
]]

-- Importando arquivos externos
require('src/dependencies')

-- Variáveis com acesso limitado
local projectiles = {}
local aliens = {}
local player
local alienDirection = 'right'
local alienMovementTimer = 0
local alienMovementInterval = 0.705
local farRightAlien = 0
local farLeftAlien = 256
local explosions = {}
local lowerAliens = {}
local notAlien = {}
notAlien.y = 0
local alienShootTimer = 0
local alienShootInterval = 1.8
local respawnTimer = 0
local alienShootSound = love.audio.newSource('sound/alien_shoot.wav', 'static')
local gameOver = false
local score = 0
local hiscore = 0
math.randomseed(os.time())

function findFar()
    farRightAlien = 0
    farLeftAlien = 256
    for _, alien in pairs (aliens) do
        if alien.x + SPRITE_SIZE > farRightAlien then
            farRightAlien = alien.x
        end
        if alien.x < farLeftAlien then
            farLeftAlien = alien.x
        end
    end
end

function attAliens(dt)
    findFar()
    alienMovementTimer = alienMovementTimer + dt
    alienShootTimer = alienShootTimer + dt
    math.randomseed(os.time())
    if alienShootTimer >= alienShootInterval then
        alienShootTimer = 0
        if table.maxn(lowerAliens) >= 1 then
            lowerAliens[math.random(table.maxn(lowerAliens))]:fire(projectiles)
            love.audio.play(alienShootSound)
        end
    end
    if alienMovementTimer >= alienMovementInterval then
        if alienDirection == 'right' then
            for i, alien in ipairs(aliens) do
                alienMovementTimer = 0
                alien.WalkMotion = alien.WalkMotion + 1
                alien.x = alien.x + ALIEN_STEP_LENGTH
            end

            if farRightAlien >= VIRTUAL_W - SPRITE_SIZE - 6 then
                alienDirection = 'left'
                for _, alien in pairs (aliens) do
                    alien.y = alien.y + ALIEN_STEP_HEIGHT
                end
            end
        elseif alienDirection == 'left' then
            for _, alien in pairs(aliens) do
                alienMovementTimer = 0
                alien.WalkMotion = alien.WalkMotion + 1
                alien.x = alien.x - ALIEN_STEP_LENGTH
            end

            if farLeftAlien <= 8 then
                alienDirection = 'right'
                for _, alien in pairs (aliens) do
                    alien.y = alien.y + ALIEN_STEP_HEIGHT
                end
            end
        end
    end

    function alienDestroyed(alien, index)
        alien.isAlive = false
        for i = 1, 7 do 
            if lowerAliens[i] == alien then
                table.remove(lowerAliens, i)
                for _, newLower in pairs (aliens) do
                    if newLower.code == alien.code - 7 then
                        table.insert(lowerAliens, i, newLower)
                        break
                    end
                end
            end
        end
        table.remove(aliens, index)
    end

end

function love.load()
    projectiles = {}
    aliens = {}
    alienDirection = 'right'
    alienMovementTimer = 0
    alienMovementInterval = 0.705
    farRightAlien = 0
    farLeftAlien = 256
    explosions = {}
    lowerAliens = {}
    alienShootTimer = 0
    alienShootInterval = 1.8
    respawnTimer = 0
    score = 0
    
    -- Corrigindo filtro
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Adicionando fontes
    gFonte = love.graphics.newFont('font/pixelmix.ttf', 8)
    love.graphics.setFont(gFonte)

    -- Criando janela com resolução virtual
    love.window.setTitle('Space Invaders')
    push:setupScreen(VIRTUAL_W, VIRTUAL_H, WINDOW_W, WINDOW_H, {
        fullscreen = false, 
        vsync = true,
        resizable = true,
    })

    -- Instanciando player e aliens
    player = Player(PLAYER_START_X, PLAYER_START_Y, PLAYER_SPRITES, 'player')

    for y = 1, 5 do
        if y == 1 or y == 2 then
            for x = 1, 7 do
                table.insert(aliens, Alien((x * SPRITE_SIZE * 1.6), (y * SPRITE_SIZE * 1.1) + 10, ALIEN3_SPRITES, 'alien3'))
            end
        end
        if y == 3 or y == 4 then
            for x = 1, 7 do
                table.insert(aliens, Alien((x * SPRITE_SIZE * 1.6), (y * SPRITE_SIZE * 1.1) + 10, ALIEN2_SPRITES, 'alien2'))
            end
        end
        if y == 5 then
            for x = 1, 7 do
                table.insert(aliens, Alien((x * SPRITE_SIZE * 1.6), (y * SPRITE_SIZE * 1.1) + 10, ALIEN1_SPRITES, 'alien1'))
            end
        end
    end

    for i = 1, 35 do
        aliens[i].code = i
    end

    for i = 1, 7 do
        table.insert(lowerAliens, aliens[i+28])
    end

    findFar()
    for i, alien in ipairs(aliens) do
        if i%2 == 0 then
            alien.WalkMotion = alien.WalkMotion + 1
        end
    end
    
end

function love.update(dt)
    -- Atualizando projéteis
    player:update(dt, projectiles)

    if respawnTimer <= 1 and player.isRespawning == true then
        respawnTimer = respawnTimer + dt
    else
        respawnTimer = 0
        player.isRespawning = false
        player.doRender = true
    end

    -- Atualizando aliens
    if player.lives > 0 and not gameOver then
        attAliens(dt)
    end
    
    for i, projectile in ipairs(projectiles) do
        projectile:update(dt)
        if projectile.y < 20 or projectile.y > 250 then
            table.remove(projectiles, i)
        end
        
        if projectile:collide(player) and not player.isRespawning then
            table.remove(projectiles, i)
            player.lives = player.lives - 1
            player.doRender = false
            table.insert(explosions, Explosion(player.x, player.y, player.sprites, 'player'))
            if player.lives > 0 then
                player.isRespawning = true
            else
                gameOver = true
                player.isAlive = false
            end
        end
        for r, projec in ipairs (projectiles) do
            if projectile:projectileCollide(projec) and i~=r then
                table.remove(projectiles, i)
                table.remove(projectiles, r)
            end
        end

        for j, alien in ipairs (aliens) do
            if alien.isAlive then
                if projectile:collide(alien) then
                    table.remove(projectiles, i)
                    if alien.class == 'alien1' then
                        score = score + 10
                    elseif alien.class == 'alien2' then
                        score = score + 30
                    elseif alien.class == 'alien3' then
                        score = score + 50
                    end
                    table.insert(explosions, Explosion(alien.x, alien.y, alien.sprites, 'alien'))
                    alienDestroyed(alien, j)
                    alienShootInterval = alienShootInterval - 0.02
                    alienMovementInterval = alienMovementInterval - 0.02
                end 
            end
        end

        for i = 1, #lowerAliens do
            if lowerAliens[i].y + SPRITE_SIZE >= player.y then
                
                gameOver = true
            end
        end

    end
    if hiscore < score then
        hiscore = score
    end

    for i, explosion in ipairs(explosions) do
        explosion:update(dt)
        if explosion.timer >= 0.2 then
            table.remove(explosions, i)
        end
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'space' and gameOver then
        gameOver = false
        player.isAlive = true
        player.lives = 3
        player.score = 0
        for i, alien in ipairs(aliens) do
            table.remove(aliens, i)
        end
        love.load()
    end

end

function love.draw()
    -- Iniciando push
    push:start()
    love.graphics.clear(0, 0, 0, 1)
    -- UI
    if player.isAlive then
        love.graphics.print('SCORE', 10, 3, 0, 1)
        love.graphics.print(score, 10, 15, 0, 1)
        love.graphics.print('HISCORE', 90, 3, 0, 1)
        love.graphics.print(hiscore, 90, 15, 0, 1)
        love.graphics.print('LIVES', 185, 3, 0, 1)
        love.graphics.print(player.lives, 185, 15, 0, 1)
    end
    
    if player.doRender == true and player.isAlive == true then
        player:render()
    end

    for _, projectile in pairs(projectiles) do
        projectile:render()
    end

    for _, alien in pairs(aliens) do
        if alien.isAlive then
            alien:render()
        end
    end

    for _, explosion in pairs(explosions) do
        explosion:render()
    end

    if gameOver then
        love.graphics.setColor(0,0,0,0.35)
        love.graphics.rectangle('fill', 0, 0, 224, 256)
        love.graphics.setColor(1,1,1)
        love.graphics.print("GAME-OVER", 32, 40, 0, 3)
        love.graphics.print("SCORE: ", 52, 80, 0, 2)
        love.graphics.print(score, 130, 80, 0, 2)
        love.graphics.print("HISCORE: ", 45, 110, 0, 2)
        love.graphics.print(hiscore, 140, 110, 0, 2)
        love.graphics.print("PRESS SPACE TO PLAY AGAIN...", 40, 150, 0, 1)
        love.graphics.print("PRESS ESC TO QUIT GAME...", 46, 180, 0, 1)
        
    end
    
    push:finish()
end