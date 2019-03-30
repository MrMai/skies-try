
Disintegration = {}
Disintegration.__index = Disintegration

function Disintegration.new(entity, lifetime, whileDoing)
  local o = {}
  o.type = "Disintegration"
  o.isControl = false
  o.entity = entity
  o.time = 0
  o.lifetime = lifetime
  o.whileDoing = whileDoing
  setmetatable(o, Disintegration)
  return o
end

function Disintegration:update(dt)
  self.time = self.time + dt
  local should = false
  for i in pairs(self.whileDoing) do
    if self.entity.currently[i] then
      should = true
    end
  end
  if(self.time >= self.lifetime and should)then
    self.entity:kill()
  end
end
