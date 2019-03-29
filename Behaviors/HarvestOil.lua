require "utils"

HarvestOil = {}
HarvestOil.__index = HarvestOil

function HarvestOil.new(world, entity, storage, allowed, detectRange, speed)
  local o = {}
  o.type = "HarvestOil"
  o.isControl = false
  o.entity = entity
  o.storage = storage
  o.sources = {}
  o.speed = speed
  for ent in pairs(world.entities) do
    local isallowed = false
    for z=1, #allowed do
      if ent.type == allowed[z] then
        isallowed = true
      end
    end
    if(utils.distanceFrom(entity.x, entity.y, ent.x, ent.y) <= detectRange and ent.behaviors["ContainsOil"] and isallowed)then
      table.insert(o.sources, ent)
    end
  end
  setmetatable(o, HarvestOil)
  return o
end

function HarvestOil:update(dt)
  if(not self.storage:isFull())then
    local active = false
    for i=1, #self.sources do
      local amount = self.speed / #self.sources * dt
      if(not self.sources[i].behaviors["ContainsOil"]:isEmpty())then
        active = true
        local leftover = self.storage:fill(amount)
        if(leftover > 0)then
          self.sources[i].behaviors["ContainsOil"]:use(amount - leftover)
        else
          self.sources[i].behaviors["ContainsOil"]:use(amount)
        end
      else
        table.remove(self.sources, i)
        i = i -1
      end
    end
    self.entity.currently["HarvestingOil"] = active
  end
end
