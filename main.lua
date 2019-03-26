require "Spritesheet"
require "World"
require "Block"
require "Entities/Player"
require "Entities/OilResource"
require "Entities/OilHarvester"
local bump = require "bump"

Interface = {}
Interface.__index = World

function Interface.new()
  local o = {}
  o.elements = {}
  setmetatable(o, Interface)
  return o
end

function Interface:add(element)
  table.insert(self.elements, element)
end

saveslocation = "/worlds/"

function love.load()
  gameworld = World.new("world-1")
  -- gameworld:fill(100,100)
  -- gameworld:manifestBlocks()
  gameworld:load()
  player = Player.new(gameworld,1,1)
  gameworld:addEntity(player)
  gameworld:addEntity(OilResource.new(gameworld,5,2,5,5))
  gameworld:addEntity(OilResource.new(gameworld,10,4,5,5))
  gameworld:addEntity(OilResource.new(gameworld,5,6,5,5))
  gameworld:addEntity(OilHarvester.new(gameworld,8,5,10,0))
  selectedblock = 1
  gamescale = 20
  offx, offy = 0,0
end

function love.update(dt)
  gameworld:update(dt)
  if(love.mouse.isDown(1))then
    local x, y = love.mouse.getPosition()
    if(selectedblock ~= 0)then
      gameworld:place(math.floor((x-offx)/gamescale),math.floor((y-offy)/gamescale),Block.new(selectedblock))
    else
      gameworld:dig(math.floor((x-offx)/gamescale),math.floor((y-offy)/gamescale))
    end
  end
end

function love.draw()
  offx, offy = love.window.getMode()
  offx = (offx / 2) - (player.x * gamescale) - (player.width  * gamescale / 2)
  offy = (offy / 2) - (player.y * gamescale) - (player.height * gamescale / 2)
  gameworld:draw(offx,offy,gamescale)
end

function love.keypressed(key, scancode, isrepeat)
  if(tonumber(key) ~= nil)then
    selectedblock = tonumber(key)
  end
  if(key == "f5")then
    gameworld:store()
  end
end

function love.mousepressed(x, y, button, isTouch)

end
