--[[
    Classe de explosões
]]

Explosion = Class{}

Explosion.enemy = love.audio.newSource('sound/enemy_explosion.wav', 'static')
Explosion.player = love.audio.newSource('sound/player_explosion.wav', 'static')
Explosion.timer = 0

function Explosion:init(x,y,sprites,type)
    self.x = x
    self.y = y
    self.sprites = sprites
    self.spriteToRender = sprites[3]
    self.type = type
    if type == 'alien' then
        love.audio.play(self.enemy)
    else love.audio.play(self.player) end

end

function Explosion:update(dt)
   self.timer = self.timer + dt
   if self.timer > 0.1 then
        self.spriteToRender = self.sprites[4]
   end
end

function Explosion:render()
    love.graphics.draw(gTextures['sprites'], gFrames['sprites'][self.spriteToRender], self.x, self.y)
end