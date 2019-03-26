Template = {}
Template.__index = Template

function Template.new(originEntity, behavior)
  local o = {}
  o.originEntity = originEntity
  o.behavior = behavior
  setmetatable(o, Template)
  return o
end

function Template:draw(x, y, scale)

end
