require "Entity"
require "Behaviors/ContainsOil"
require "Drawables/OilMeter"

OilResource = {}
setmetatable(OilResource, Entity)
OilResource.__index = OilResource
OilResource.width = 0.5
OilResource.height = 0.5
OilResource.color = {0.46875, 0.1953125, 0.1640625}

function OilResource.new(world,x,y,max,current)
  o = Entity.new()
  o.type = "OilResource"
  o.x, o.y = x, y
  o.world = world
  o.behaviorList = {}
  o.behaviors = {}

  local containsOil = ContainsOil.new(o, max, current)
  o.behaviorList["ContainsOil"] = containsOil
  table.insert(o.behaviors, containsOil)

  o.drawables = {}
  local entityBox = EntityBox.new(o, OilResource.color)
  table.insert(o.drawables, entityBox)

  local oilMeter = OilMeter.new(o, containsOil, -0.8, -0.6, 0.4,1.2)
  table.insert(o.drawables, oilMeter)

  setmetatable(o, OilResource)
  return o
end
