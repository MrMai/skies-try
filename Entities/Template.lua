require "Entity"

Template = {}
setmetatable(Template, Entity)
Template.__index = Template

function Template.new(world,x,y)
  o = Entity.new(x,y)
  o.type = "Template"
  o.world = world
  o.behaviorList = {}
  o.behaviors = {}
  -- behaviors

  o.drawables = {}
  -- drawables

  setmetatable(o, Template)
  return o
end
