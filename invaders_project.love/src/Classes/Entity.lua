--[[
    Classe Base

    Tem movimento na tela e é representada por um sprite
]]
Entity = Class{}

Entity.isAlive = true

function Entity:init(x,y,sprites,class)
    self.x = x
    self.y = y
    self.sprites = sprites
    self.class = class
end

function Entity:render()
    love.graphics.draw(gTextures['sprites'], gFrames['sprites'][self.sprites[1]], self.x, self.y)
end