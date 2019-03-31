AnimateWhile = {}
AnimateWhile.__index = AnimateWhile

function AnimateWhile.new(originEntity, spritesheet, timing, whileDoing)
  local o = {}
  o.originEntity = originEntity
  o.spritesheet = spritesheet
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

end

function AnimateWhile:update(dt)
end
