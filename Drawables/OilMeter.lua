OilMeter = {}
OilMeter.__index = OilMeter

function OilMeter.new(originEntity, behavior, offx, offy, width, height)
  local o = {}
  o.originEntity = originEntity
  o.behavior = behavior
  o.offx, o.offy = offx, offy
  o.width, o.height = width, height
  setmetatable(o, OilMeter)
  return o
end

function OilMeter:draw(x, y, scale)
  love.graphics.setColor(0.46875, 0.1953125, 0.1640625)
  love.graphics.rectangle("fill", x + ((self.offx + self.originEntity:getXCenter()) * scale), y + ((self.offy + self.originEntity:getYCenter() + (self.height - (self.height * self.behavior.current / self.behavior.max))) * scale), self.width * scale, self.height * self.behavior.current / self.behavior.max * scale)
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("line", x + ((self.offx + self.originEntity:getXCenter()) * scale), y + ((self.offy + self.originEntity:getYCenter()) * scale), self.width * scale, self.height * scale)
end
