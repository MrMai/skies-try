require "ItemAttributes/Default"

HealthMeter = {}
HealthMeter.__index = HealthMeter

function HealthMeter.new(originEntity, behavior, offx, offy, width, height)
  local o = {}
  o.originEntity = originEntity
  o.behavior = behavior
  o.offx, o.offy = offx, offy
  o.width, o.height = width, height
  setmetatable(o, HealthMeter)
  return o
end

function HealthMeter:isLight()
  return false
end

function HealthMeter:isUI()
  return true
end

function HealthMeter:draw(x, y, scale)
  love.graphics.setColor(Default.healthColor)
  love.graphics.rectangle("fill", x + ((self.offx + self.originEntity:getXCenter()) * scale), y + ((self.offy + self.originEntity:getYCenter()) * scale), self.width * self.behavior.current / self.behavior.max * scale, self.height * scale)
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("line", x + ((self.offx + self.originEntity:getXCenter()) * scale), y + ((self.offy + self.originEntity:getYCenter()) * scale), self.width * scale, self.height * scale)
end
