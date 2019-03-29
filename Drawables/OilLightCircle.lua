Template = {}
Template.__index = Template

function Template.new(originEntity, lampbehavior)
  local o = {}
  o.originEntity = originEntity
  o.lampbehavior = lampbehavior
  setmetatable(o, Template)
  return o
end

function Template:isLight()
  return true
end

function Template:isUI()
  return false
end

function Template:draw(x, y, scale)
  love.graphics.circle("fill", x, y, self.lampbehavior.lightLevel * scale, 20)
end
