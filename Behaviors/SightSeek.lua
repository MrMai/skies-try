require "utils"
require "ItemAttributes/Default"

SightSeek = {}
SightSeek.__index = SightSeek

function SightSeek.new(entity, allowed, range, speed, waitTime)
  local o = {}
  o.type = "SightSeek"
  o.isControl = false
  o.entity = entity
  o.allowed = allowed
  o.range = range
  o.speed = speed
  o.isCaster = true
  o.waiting = 0
  o.waitTime = waitTime
  o.collisions = {}
  entity.world.world:add(o,entity.x,entity.y,0.0001,0.0001)
  o.target = nil
  setmetatable(o, SightSeek)
  return o
end

function SightSeek:update(dt)
  local active = false

  if(self.target == nil)then
    local allowed = {}
    for ent in pairs(self.entity.world.entities) do
      if(utils.distanceFrom(self.entity:getXCenter(), self.entity:getYCenter(), ent:getXCenter(), ent:getYCenter()) <= self.range) then
        for z=1, #self.allowed do
          if(self.allowed[z] == ent.type)then
            table.insert(allowed, ent)
          end
        end
      end
    end
    if(#allowed > 0)then
      self.target = allowed[math.random(1, #allowed)]
      self.waiting = 0
      local fx, fy, cols, num = utils.raycast(self.entity.world.world, self, Default.sightFilter, self.entity:getXCenter(), self.entity:getYCenter(), self.target.x, self.target.y)
      if(num > 0)then
        self.target = nil
      end
    end
  else
    local fx, fy, cols, num = utils.raycast(self.entity.world.world, self, Default.sightFilter, self.entity:getXCenter(), self.entity:getYCenter(), self.target.x, self.target.y)
    if(num > 0)then
      self.target = nil
    elseif(self.waiting >= self.waitTime)then
      local vx, vy = utils.scaledVec(self.entity:getXCenter(), self.entity:getYCenter(), self.target:getXCenter(), self.target:getYCenter(), self.speed)
      self.entity.facing = utils.angleVec(vx,vy)
      --vx, vy = utils.roundVec(vx,vy,8)
      self.entity.x, self.entity.y, self.collisions = self.entity.world.world:move(self.entity, self.entity.x + (vx * dt), self.entity.y + (vy * dt), Default.filter)
      active = true
    else
      self.waiting = self.waiting + dt
    end
  end
  self.entity.currently["Seeking"] = active
end
