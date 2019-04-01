require "Item"

Inventory = {}
Inventory.__index = Inventory

function Inventory.new(width, height)
  local o = {}
  o.mapspace = {}
  o.width, o.height = width, height
  for kx=1, width do
    o.mapspace[kx] = {}
    for ky=1, height do
      o.mapspace[kx][ky] = Item.new(0)
    end
  end
  setmetatable(o, Inventory)
  return o
end

function Inventory:addItem(x,y,item)
  if(self:checkSpace(x,y,item))then
    for kx=0, item.width-1 do
      for ky=0, item.height-1 do
        self:allocateSpace(x+kx,y+ky,item)
      end
    end
    return true
  else
    return false
  end
end

function Inventory:lookAtSpace(x,y) -- from 0,0
  if(x < width and x >= 0 and y < height and y >= 0) then
    return self.mapspace[x+1][y+1]
  end
end

function Inventory:allocateSpace(x,y,item) -- from 0,0
  if(x < width and x >= 0 and y < height and y >= 0) then
    self.mapspace[x+1][y+1] = item
  end
end

function Inventory:checkSpace(x,y,item)
  for kx=0, item.width-1 do
    for ky=0, item.height-1 do
      if self:lookAtSpace(x+kx,y+ky).id ~= 0 then
        return false -- if a space is occupied return false, no other code is executed
      end
    end
  end
  return true
end

function Inventory:findSpace(item)
  for kx=0, self.width-1 do
    for ky=0, self.height-1 do
      if(self:checkSpace(kx,ky,item))then
        return kx,ky
      end
    end
  end
end
