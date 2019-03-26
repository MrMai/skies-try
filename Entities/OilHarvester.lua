require "Entity"
require "Behaviors/ContainsOil"
require "Behaviors/HarvestOil"
require "Drawables/EntityBox"
require "Drawables/HarvestOilLines"
require "ItemAttributes/Oil"

OilHarvester = {}
setmetatable(OilHarvester, Entity)
OilHarvester.__index = OilHarvester
OilHarvester.allowed = {"OilResource"}

function OilHarvester.new(world,x,y,max,current)
  o = Entity.new()
  o.type = "OilHarvester"
  o.x, o.y = x, y
  o.width, o.height = 1,1
  o.world = world
  world.world:add(o, x,y,o.width,o.height)
  o.behaviorList = {}
  o.behaviors = {}

  local containsOil = ContainsOil.new(o, max, current)
  o.behaviorList["ContainsOil"] = containsOil
  table.insert(o.behaviors, containsOil)

  local harvestOil = HarvestOil.new(world, o, containsOil, OilHarvester.allowed, 5, 0.6)
  o.behaviorList["HarvestOil"] = harvestOil
  table.insert(o.behaviors, harvestOil)

  o.drawables = {}
  local entityBox = EntityBox.new(o, Oil.color)
  table.insert(o.drawables, entityBox)

  local harvestOilLines = HarvestOilLines.new(o, containsOil, harvestOil)
  table.insert(o.drawables, harvestOilLines)

  local oilMeter = OilMeter.new(o, containsOil, -1.1, -0.6, 0.4,1.2)
  table.insert(o.drawables, oilMeter)

  setmetatable(o, OilHarvester)
  return o
end
