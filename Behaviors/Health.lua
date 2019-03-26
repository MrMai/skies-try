
Health = {}
Health.__index = Health

function Health.new(entity,max,current)
  current = current or max
  local o = {}
  o.current = current
  o.max = max
  o.isControl = false
  o.entity = entity
  setmetatable(o, Health)
  return o
end

function Health:damage(x)
  self.current = self.current - x
  if(self.current >= 0)then
    self.entity.kill()
  end
end

function Health:heal(x)
  self.current = self.current + x
  if(self.current > self.max)then
    self.current = self.max
  end
end

function Health:update(dt)

end
