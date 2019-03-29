
Disintegration = {}
Disintegration.__index = Disintegration

function Disintegration.new(entity, lifetime)
  local o = {}
  o.type = "Disintegration"
  o.isControl = false
  o.entity = entity
  o.time = 0
  o.lifetime = lifetime
  setmetatable(o, Disintegration)
  return o
end

function Disintegration:update(dt)
  self.time = self.time + dt
  if(self.time >= self.lifetime)then
    self.entity:kill()
  end
end
