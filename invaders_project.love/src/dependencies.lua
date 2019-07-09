--[[
    Dependências e imports
]]

-- Bibliotecas
Class = require('libs/class')
push = require('libs/push')

-- Source
require 'src/constants'
require 'src/Util'
require 'src/Classes/Entity'
require 'src/Classes/Alien'
require 'src/Classes/Player'
require 'src/Classes/Projectile'
require 'src/Classes/Explosion'

love.graphics.setDefaultFilter('nearest', 'nearest')

gTextures = {
    ['sprites'] = love.graphics.newImage('graphics/spritesheet3.png')
}

gFrames = {
    ['sprites'] = GenerateQuads(gTextures['sprites'], SPRITE_SIZE, SPRITE_SIZE)
}