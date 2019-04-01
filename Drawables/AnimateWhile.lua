AnimateWhile = {}
AnimateWhile.__index = AnimateWhile

function AnimateWhile.new(originEntity, spritesheet, timing, whileDoing)
  local o = {}
  o.originEntity = originEntity
  o.spritesheet = spritesheet
  -- the given time is the amount of time spent on a given frame, but the timing is the end time of that frame
  -- ex 0.2, 0.2, 0.2 would be 0.2, 0.4, 0.6
  o.timing = {}
  for i=1, #timing do
    o.timing[i] = 0
    for z=1, i do
      o.timing[i] = o.timing[i] + o.timing[z]
    end
  end
  o.current = 0
  o.whileDoing = whileDoing
  setmetatable(o, AnimateWhile)
  return o
end

function AnimateWhile:isLight()
  return false
end

function AnimateWhile:isUI()
  return false
end

function AnimateWhile:draw(x, y, scale)
  for i=2, #self.timing do
    if self.timing[i-1] < self.current and self.timing[i] > self.current then
      self.spritesheet:draw(i,x,y,scale)
      return
    end
  end
end

function AnimateWhile:update(dt)
  local isdoing = false
  for i,x in pairs(self.whileDoing) do
    if(self.originEntity.currently[x])then
      isdoing = true
    end
  end
  if(isdoing)then
    self.current = self.current + dt
    if self.current >= self.timing[#self.timing] then
      self.current = 0
    end
  end
end
