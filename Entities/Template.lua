require "Entity"

Template = {}
setmetatable(Template, Entity)
Template.__index = Template

function Template.new(world,x,y)
  o = Entity.new()
  o.type = "Template"
  o.x, o.y = x, y
  o.world = world
  o.behaviorList = {}
  o.behaviors = {}
  -- behaviors

  o.drawables = {}
  -- drawables

  setmetatable(o, Template)
  return o
end
