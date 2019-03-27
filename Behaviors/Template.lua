
Template = {}
Template.__index = Template

function Template.new(entity)
  local o = {}
  o.type = "Template"
  o.isControl = false
  o.entity = entity
  setmetatable(o, Template)
  return o
end

function Template:update(dt)

end
