require "Entity"
require "ItemAttributes/Oil"
require "Behaviors/ContainsOil"
require "Drawables/OilMeter"

OilResource = {}
setmetatable(OilResource, Entity)
OilResource.__index = OilResource
OilResource.width = 0.5
OilResource.height = 0.5

function OilResource.new(world,x,y,max,current)
  o = Entity.new(x,y)
  o.type = "OilResource"
  o.world = world

  -- Drawables
  local containsOil = ContainsOil.new(o, max, current)
  o:addBehavior(containsOil)

  -- Drawables
  local entityBox = EntityBox.new(o, Oil.color)
  o:addDrawable(entityBox)

  local oilMeter = OilMeter.new(o, containsOil, -0.8, -0.6, 0.4,1.2)
  o:addDrawable(oilMeter)

  setmetatable(o, OilResource)
  return o
end
