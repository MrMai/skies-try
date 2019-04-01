require "Spritesheet"
require "World"
require "Block"
require "Entities/Player"
require "Entities/OilResource"
require "Entities/OilHarvester"
require "Entities/GreenSlime"
require "Entities/Arrow"
local bump = require "bump"

Interface = {}
Interface.__index = World

function love.load()
  love.window.setMode(1400, 900, {highdpi = true})
  love.graphics.setFont(love.graphics.newImageFont("Assets/ImageFont.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\""))
  gamescale = 20

  gameworld = World.new("world-1")
  -- gameworld:fill(100,100)
  -- gameworld:manifestBlocks()
  local centerX, centerY = love.window.getMode()
  gameworld.lightWorld:addLight(centerX/2, centerY/2, 1000, 0.2, 0.2, 0.2)
  gameworld:load()
  gameworld:checkCorners(10,10,10)
  player = Player.new(gameworld,1,1)
  gameworld:addEntity(player)
  gameworld:addEntity(OilResource.new(gameworld,5,2,5,5))
  gameworld:addEntity(OilResource.new(gameworld,10,4,5,5))
  gameworld:addEntity(OilResource.new(gameworld,5,6,5,5))
  gameworld:addEntity(OilHarvester.new(gameworld,8,5,10,0))
  --gameworld:addEntity(GreenSlime.new(gameworld,20,4))
  selected = 1
  offx, offy = 0,0
end

function love.update(dt)
  gameworld:update(dt)
  if(love.mouse.isDown(1))then
    local x, y = love.mouse.getPosition()
    if(selected <= 4)then
      if(selected ~= 0)then
        gameworld:place(math.floor((x-offx)/gamescale),math.floor((y-offy)/gamescale),Block.new(selected))
      else
        gameworld:dig(math.floor((x-offx)/gamescale),math.floor((y-offy)/gamescale))
      end
    end
  end
end

function love.draw()
  local centerX, centerY = love.window.getMode()
  centerX, centerY = centerX/2, centerY/2
  offx = centerX - (player.x * gamescale) - (player.width  * gamescale / 2)
  offy = centerY - (player.y * gamescale) - (player.height * gamescale / 2)
  --[[
  local blockDraw = function()
    gameworld:drawBoxes(offx, offy, gamescale)
  end
  stencilfunction = function()
    gameworld.lightWorld:drawLights(blockDraw, 0, 0)
    --gameworld:drawSightPolygon(offx, offy, gamescale, player.x,player.y,20)
  end
  love.graphics.stencil(stencilfunction)
  love.graphics.setStencilTest("greater", 0)
  ]]--
  gameworld:draw(offx,offy,gamescale)
  love.graphics.setStencilTest()
end

function love.keypressed(key, scancode, isrepeat)
  if(tonumber(key) ~= nil)then
    selected = tonumber(key)
  end
  if(key == "f5")then
    gameworld:store()
  end
end

function love.mousepressed(x, y, button, isTouch)
  local wx, wy = (x-offx)/gamescale,(y-offy)/gamescale -- the position a point clicked in the gameworld
  if(selected > 4)then
    if(selected == 5)then
      gameworld:addEntity(GreenSlime.new(gameworld,wx,wy))
    elseif(selected == 6)then
      local vx, vy = love.window.getMode()
      vx, vy = (wx - player.x) / gamescale, (wy - player.y) / gamescale
      print(vx, vy, wx,wy)
      gameworld:addEntity(Arrow.new(gameworld,player:getXCenter(),player:getYCenter(),vx,vy,Player.projectileFilter))
    end
  end
end
