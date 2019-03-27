require "utils"
require "ItemAttributes/Default"

SightSeek = {}
SightSeek.__index = SightSeek
SightSeek.filter = function(item, other)
  if other.id ~= nil then return 'touch' end
  -- else return nil
end

function SightSeek.new(world, entity, allowed, range, speed, waitTime)
  local o = {}
  o.type = "SightSeek"
  o.isControl = false
  o.world = world
  o.entity = entity
  o.allowed = allowed
  o.range = range
  o.speed = speed
  o.isCaster = true
  o.waiting = 0
  o.waitTime = waitTime
  o.collisions = {}
  world.world:add(o,entity.x,entity.y,0.0001,0.0001)
  o.target = nil
  setmetatable(o, SightSeek)
  return o
end

function SightSeek:update(dt)
  if(self.target == nil)then
    local allowed = {}
    for i=1, #self.world.entities do
      local ent = self.world.entities[i]
      if(utils.distanceFrom(self.entity:getXCenter(), self.entity:getYCenter(), ent:getXCenter(), ent:getYCenter()) <= self.range) then
        for z=1, #self.allowed do
          if(self.allowed[z] == self.world.entities[i].type)then
            table.insert(allowed, z)
          end
        end
      end
    end
    if(#allowed > 0)then
      self.target = self.world.entities[allowed[math.random(1, #allowed)]]
      self.waiting = 0
      fx, fy, cols, num = self:cast(self.target:getXCenter(), self.target:getYCenter())
      if(num > 0)then
        self.target = nil
      end
    end
  else
    fx, fy, cols, num = self:cast(self.target.x, self.target.y)
    if(num > 0)then
      self.target = nil
    elseif(self.waiting >= self.waitTime)then
      local vx, vy = utils.scaledVec(self.entity:getXCenter(), self.entity:getYCenter(), self.target:getXCenter(), self.target:getYCenter(), self.speed)
      self.entity.x, self.entity.y, self.collisions = self.world.world:move(self.entity, self.entity.x + (vx * dt), self.entity.y + (vy * dt), Default.filter)
    else
      self.waiting = self.waiting + dt
    end
  end
end

function SightSeek:cast(x,y)
  self.world.world:update(self, self.entity:getXCenter(), self.entity:getYCenter())
  return self.world.world:check(self, x, y, SightSeek.filter)
end
