require "ItemAttributes/Oil"

HarvestOilLines = {}
HarvestOilLines.__index = HarvestOilLines

function HarvestOilLines.new(originEntity, containsOilBehavior, harvestOilBehavior)
  local o = {}
  o.originEntity = originEntity
  o.containsOilBehavior = containsOilBehavior
  o.harvestOilBehavior = harvestOilBehavior
  setmetatable(o, HarvestOilLines)
  return o
end

function HarvestOilLines:draw(x, y, scale)
  love.graphics.setColor(Oil.harvestColor)
  for i=1, #self.harvestOilBehavior.sources do
    if(not self.harvestOilBehavior.sources[i].behaviorList["ContainsOil"]:isEmpty())then
      love.graphics.line(x + (self.originEntity:getXCenter() * scale), y + (self.originEntity:getYCenter() * scale), x + (self.harvestOilBehavior.sources[i]:getXCenter() * scale), y + (self.harvestOilBehavior.sources[i]:getYCenter() * scale))
    end
  end
end
