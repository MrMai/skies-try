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
  o.isControl = false
  o.world = world
  o.entity = entity
  o.allowed = allowed
  o.isCaster = true
  o.waiting = 0
  o.waitTime = waitTime
  world.world:add(o,entity.x,entity.y,0.0001,0.0001)
  o.target = nil
  setmetatable(o, SightSeek)
  return o
end

function SightSeek:update(dt)
  if(self.target == nil)then
    for i=1, #self.world.entities[i] do
      local ent = self.world.entities[i]
      if(utils.distanceFrom(self.entity.x, self.entity.y, ent.x, ent.y) <= self.range) then
        allowed = {}
        for z=1, #self.allowed do
          if(self.allowed[z] == self.world.entities[i].type)then
            table.insert(allowed, z)
          end
        end
        self.target = self.world.entities[allowed[math.random(1, #allowed)]]
        self.waiting = 0
      end
    end
    fx, fy, cols, num = self:cast(self.target.x, self.target.y)
    if(num > 0)then
      self.target = nil
    end
  else
    self.waiting = self.waiting + dt
    if(self.waiting > self.waitTime)then
      local vx, vy = utils.scaledVec(self.entity.x, self.entity.y, self.target.x, self.target.y)
      self.entity.x, self.entity.y = world.world:move(self.entity, self.entity.x + (vx * dt), self.entity.y + (vy * dt), Default.filter)
    end
  end
end

function SightSeek:cast(x,y)
  self.world.world:update(self, self.entity.x, self.entity.y)
  return world:check(self, x, y, SightSeek.filter)
end
