require "Entity"
require "ItemAttributes/Oil"
require "Behaviors/ContainsOil"
require "Drawables/OilMeter"
require "Drawables/RandomStationarySprite"
require "Spritesheet"

OilResource = {}
setmetatable(OilResource, Entity)
OilResource.__index = OilResource
OilResource.width = 0.5
OilResource.height = 0.5
OilResource.spritesheet = Spritesheet.newFromSheet("Assets/firecrystal.png",16,16)

function OilResource.new(world,x,y,max,current)
  o = Entity.new(x,y)
  o.type = "OilResource"
  o.world = world

  -- Drawables
  local containsOil = ContainsOil.new(o, max, current)
  o:addBehavior(containsOil)

  -- Drawables
  local randomStationarySprite = RandomStationarySprite.new(o, OilResource.spritesheet)
  o:addDrawable(randomStationarySprite)

  local oilMeter = OilMeter.new(o, containsOil, -0.8, -0.2, 0.4,1)
  o:addDrawable(oilMeter)

  setmetatable(o, OilResource)
  return o
end

function OilResource:getXRoot()
  return self.x + 0.5
end

function OilResource:getYRoot()
  return self.y + 0.5
end
