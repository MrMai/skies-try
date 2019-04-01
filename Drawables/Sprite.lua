Sprite = {}
Sprite.__index = Sprite

function Sprite.new(originEntity, spritesheet, index)
  local o = {}
  o.originEntity = originEntity
  o.spritesheet = spritesheet
  o.index = index
  setmetatable(o, Sprite)
  return o
end

function Sprite:isLight()
  return false
end

function Sprite:isUI()
  return false
end

function Sprite:draw(x, y, scale)
  self.spritesheet:draw(self.index, x + (scale * self.originEntity.x), y + (scale * self.originEntity.y), scale)
end

function Sprite:update(dt)

end
