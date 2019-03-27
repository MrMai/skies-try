require "utils"

Wander = {}
Wander.__index = Wander

function Wander.new(entity, rays, range, speed, decisiveness, lazyness)
  local o = {}
  o.type = "Wander"
  o.isControl = false
  o.entity = entity
  entity.world.world:add(o, entity.x, entity.y, 0.0001,0.0001)
  o.rays = {}
  for i=1, rays do
    local vec = {utils.angleVec(1/rays * (i-1) * 2 * math.pi, range)}
    table.insert(o.rays, vec)
  end
  o.range = range
  o.speed = speed
  o.decisiveness = decisiveness -- how long to stay on the trail
  o.lazyness = lazyness -- how much it waits
  o.waitTimer = 0
  o.waitUntil = 0
  o.wanderVec = {x=0,y=0}
  setmetatable(o, Wander)
  return o
end

function Wander:update(dt)
  if(not self.entity.currently["Seeking"])then
    if(not self.entity.currently["Wandering"] and not self.entity.currently["WaitingBefore"]) then
      if(math.random() < self.lazyness)then
        self.entity.currently["WaitingBefore"] = true
        self.entity.waitUntil = math.random() * self.decisiveness
      end
      local raycastDist = {}
      self.entity.world.world:update(self, self.entity.x, self.entity.y)
      for i=1, #self.rays do
        local vx, vy = self.entity.world.world:check(self, self.entity.x + self.rays[i][1], self.entity.y + self.rays[i][2])
        table.insert(raycastDist, utils.pythag(vx, vy)/self.range)
      end
      local sum = 0
      for i=1, #raycastDist do
        sum = sum + raycastDist[i]
      end
      for i=1, #raycastDist do
        raycastDist[i] = raycastDist[i] / sum
      end
      sum = 0 -- used as cashe
      local select = 0
      local rand = math.random()
      for i=1, #raycastDist do
        sum = sum + raycastDist[i]
        if(rand <= sum)then
          i = #raycastDist + 1
          select = i
        end
      end
      self.entity.currently["Wandering"] = true
      self.wanderVec.x, self.wanderVec.y = self.rays[select][1], self.rays[select][2]
    elseif self.entity.currently["Wandering"] and not self.entity.currently["WaitingBefore"] then
      self.entity.x, self.entity.y, cols, num = self.entity.world.world:move(self.entity, self.entity.x + self.wanderVec.x, self.entity.y + self.wanderVec.y)
      if(num)then
        self.entity.currently["Wandering"] = false
      end
    elseif self.entity.currently["Wandering"] and self.entity.currently["WaitingBefore"] then
      self.waitTimer = self.waitTimer + dt
      if(self.waitTimer >= self.waitUntil)then
        self.waitTimer = 0
        self.entity.currently["WaitingBefore"] = false
      end
    end
  end
end
