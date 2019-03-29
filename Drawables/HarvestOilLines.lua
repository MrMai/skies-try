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

function HarvestOilLines:isLight()
  return false
end

function HarvestOilLines:isUI()
  return false
end

function HarvestOilLines:draw(x, y, scale)
  love.graphics.setColor(Oil.harvestColor)
  for o, sour in pairs(self.harvestOilBehavior.sources) do
    if(not sour.behaviors["ContainsOil"]:isEmpty())then
      love.graphics.line(x + (self.originEntity:getXCenter() * scale), y + (self.originEntity:getYCenter() * scale), x + (sour:getXCenter() * scale), y + (sour:getYCenter() * scale))
    end
  end
end
