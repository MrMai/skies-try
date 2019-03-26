require "utils"

HarvestOil = {}
HarvestOil.__index = HarvestOil

function HarvestOil.new(world, entity, storage, allowed, detectRange, speed)
  local o = {}
  o.isControl = false
  o.entity = entity
  o.storage = storage
  o.sources = {}
  o.speed = speed
  for i=1, #world.entities do
    local isallowed = false
    for z=1, #allowed do
      if world.entities[i].type == allowed[z] then
        isallowed = true
      end
    end
    if(utils.distanceFrom(entity.x, entity.y, world.entities[i].x, world.entities[i].y) <= detectRange and world.entities[i].behaviorList["ContainsOil"] and isallowed)then
      table.insert(o.sources, world.entities[i])
    end
  end
  print(#o.sources)
  setmetatable(o, HarvestOil)
  return o
end

function HarvestOil:update(dt)
  if(not self.storage:isFull())then
    for i=1, #self.sources do
      local amount = self.speed / #self.sources * dt
      if(not self.sources[i].behaviorList["ContainsOil"]:isEmpty())then
        local leftover = self.storage:fill(amount)
        if(leftover > 0)then
          self.sources[i].behaviorList["ContainsOil"]:use(amount - leftover)
        else
          self.sources[i].behaviorList["ContainsOil"]:use(amount)
        end
      else
        table.remove(self.sources, i)
        i = i -1
      end
    end
  end
  print(self.storage.current)
end
