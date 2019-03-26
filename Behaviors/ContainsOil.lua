
ContainsOil = {}
ContainsOil.__index = ContainsOil

function ContainsOil.new(entity,max,current)
  current = current or max
  local o = {}
  o.current = current
  o.max = max
  o.isControl = false
  o.entity = entity
  setmetatable(o, ContainsOil)
  return o
end

function ContainsOil:use(x)
  self.current = self.current - x
  if(self.current < 0)then
    local leftover = self.current
    self.current = 0
    return leftover
  else
    return 0
  end
end

function ContainsOil:empty()
  self.current = 0
end

function ContainsOil:isEmpty()
  if self.current <= 0 then
    return true
  end
  return false
end

function ContainsOil:isFull()
  if self.current >= self.max then
    return true
  end
  return false
end

function ContainsOil:fill(x)
  self.current = self.current + x
  if(self.current > self.max)then
    local leftover = self.current - self.max
    self.current = self.max
    return leftover
  else
    return 0
  end
end

function ContainsOil:update(dt)

end
