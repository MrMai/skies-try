require "utils"

SightSeek = {}
SightSeek.__index = SightSeek

function SightSeek.new(world, entity, allowed, range, speed)
  local o = {}
  o.isControl = false
  o.world = world
  o.entity = entity
  o.allowed = allowed
  setmetatable(o, SightSeek)
  return o
end
--[[
function SightSeek:update(dt)
  for i=1, #self.world.entities[i] do
    local ent = self.world.entities[i]
    if(utils.distanceFrom(self.entity.x, self.entity.y, ent.x, ent.y) <= self.range) then

end
]]--
