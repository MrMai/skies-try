Item = {}
Item.__index = Item

function Item.new(id)
  local o = {}
  o.id = id
  setmetatable(o, Item)
  return o
end

function Item:getBehavior()
  
end
