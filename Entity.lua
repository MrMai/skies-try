local inspect = require "inspect"

Entity = {}
Entity.__index = Entity

function Entity.new(x,y, facing)
  local o = {}
  o.x, o.y = x, y
  o.facing = facing or 0
  o.behaviors = {}
  o.currently = {}
  o.drawables = {}
  setmetatable(o, Entity)
  return o
end

function Entity:addBehavior(behavior)
  self.behaviors[behavior.type] = behavior
end

function Entity:addDrawable(drawable)
  table.insert(self.drawables, drawable)
end

function Entity:update(dt)
  for i,x in pairs(self.behaviors) do
    if(not x.isControl)then
      x:update(dt)
    end
  end
  for i,x in pairs(self.drawables) do
    if(x.update ~= nil)then
      x:update(dt)
    end
  end
end

function Entity:controlUpdate(dt)
  for i,x in pairs(self.behaviors) do
    if(x.isControl)then
      x:update(dt)
    end
  end
end

function Entity:draw(x, y, scale)
  for i=1,#self.drawables do
    if(not self.drawables[i].isLight() and not self.drawables[i].isUI())then
      self.drawables[i]:draw(x, y, scale)
    end
  end
end

function Entity:drawLight(x, y, scale)
  for i=1,#self.drawables do
    if(self.drawables[i].isLight() and not self.drawables[i].isUI())then
      self.drawables[i]:draw(x, y, scale)
    end
  end
end

function Entity:drawUI(x, y, scale)
  for i=1,#self.drawables do
    if(not self.drawables[i].isLight() and self.drawables[i].isUI())then
      self.drawables[i]:draw(x, y, scale)
    end
  end
end


function Entity:getXCenter()
  return self.x + (self.width /2)
end

function Entity:getYCenter()
  return self.y + (self.height /2)
end
