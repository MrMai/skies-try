RandomStationarySprite = {}
RandomStationarySprite.__index = RandomStationarySprite

function RandomStationarySprite.new(originEntity, spritesheet)
  local o = {}
  o.originEntity = originEntity
  o.spritesheet = spritesheet
  o.index = math.random(0, #spritesheet.quads)
  setmetatable(o, RandomStationarySprite)
  return o
end

function RandomStationarySprite:isLight()
  return false
end

function RandomStationarySprite:isUI()
  return false
end

function RandomStationarySprite:draw(x, y, scale)
  self.spritesheet:draw(self.index, x + (scale * self.originEntity.x), y + (scale * self.originEntity.y), scale)
end

function RandomStationarySprite:update(dt)

end
