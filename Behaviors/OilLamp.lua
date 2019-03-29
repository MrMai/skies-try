
OilLamp = {}
OilLamp.__index = OilLamp

function OilLamp.new(entity, lightLevel)
  local o = {}
  o.type = "OilLamp"
  o.isControl = false
  o.lightLevel = lightLevel
  o.entity = entity
  setmetatable(o, OilLamp)
  return o
end

function OilLamp:update(dt)

end
