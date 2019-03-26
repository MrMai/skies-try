EntityBox = {}
EntityBox.__index = EntityBox

function EntityBox.new(entity, color)
  local o = {}
  o.entity = entity
  o.color = color
  setmetatable(o, EntityBox)
  return o
end

function EntityBox:draw(x, y, scale)
  love.graphics.setColor(self.color)
  love.graphics.rectangle("fill", x + (self.entity.x * scale), y + (self.entity.y * scale), self.entity.width * scale, self.entity.height * scale)
end
