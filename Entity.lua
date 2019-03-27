local inspect = require "inspect"

Entity = {}
Entity.__index = Entity

function Entity.new(x,y)
  local o = {}
  o.x, o.y = x, y
  o.behaviorList = {}
  o.behaviors = {}
  setmetatable(o, Entity)
  return o
end

function Entity:addBehavior(behavior)
  self.behaviorList[behavior.type] = behavior
  table.insert(self.behaviors, behavior)
end

function Entity:addDrawable(drawable)
  table.insert(self.drawables, drawable)
end

function Entity:update(dt)
  for i=1,#self.behaviors do
    if(not self.behaviors[i].isControl)then
      self.behaviors[i]:update(dt)
    end
  end
end

function Entity:controlUpdate(dt)
  for i=1,#self.behaviors do
    if(self.behaviors[i].isControl)then
      self.behaviors[i]:update(dt)
    end
  end
end

function Entity:draw(x, y, scale)
  for i=1,#self.drawables do
    self.drawables[i]:draw(x, y, scale)
  end
end


function Entity:getXCenter()
  return self.x + (self.width /2)
end

function Entity:getYCenter()
  return self.y + (self.height /2)
end
