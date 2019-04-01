require "Entity"
require "Behaviors/ContainsOil"
require "Behaviors/HarvestOil"
require "Drawables/Sprite"
require "Drawables/HarvestOilLines"
require "ItemAttributes/Oil"
require "Spritesheet"

OilHarvester = {}
setmetatable(OilHarvester, Entity)
OilHarvester.__index = OilHarvester
OilHarvester.allowed = {"OilResource"}
OilHarvester.width, OilHarvester.height = 2,2
OilHarvester.spritesheet = Spritesheet.newFromSheet("Assets/crystalharvester.png",32,32)

function OilHarvester.new(world,x,y,max,current)
  o = Entity.new(x,y)
  o.type = "OilHarvester"
  o.world = world
  world.world:add(o, x,y,OilHarvester.width,OilHarvester.height)
  -- Behaviors
  local containsOil = ContainsOil.new(o, max, current)
  o:addBehavior(containsOil)

  local harvestOil = HarvestOil.new(world, o, containsOil, OilHarvester.allowed, 5, 0.6)
  o:addBehavior(harvestOil)
  -- Drawables

  local harvestOilLines = HarvestOilLines.new(o, containsOil, harvestOil)
  o:addDrawable(harvestOilLines)

  local sprite = Sprite.new(o, OilHarvester.spritesheet, 1)
  o:addDrawable(sprite)

  local oilMeter = OilMeter.new(o, containsOil, -1.6, -0.6, 0.4,1.2)
  o:addDrawable(oilMeter)

  setmetatable(o, OilHarvester)
  return o
end
