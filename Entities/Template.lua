require "Entity"

Template = {}
setmetatable(Template, Entity)
Template.__index = Template

function Template.new(world,x,y)
  o = Entity.new(x,y)
  o.type = "Template"
  o.world = world
  
  -- behaviors

  -- drawables

  setmetatable(o, Template)
  return o
end
