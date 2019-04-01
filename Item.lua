Item = {}
Item.__index = Item

function Item.new(id)
  local o = {}
  o.id = id
  o.metadata = {}
  setmetatable(o, Item)
  return o
end

function Item:getBehavior()

end

function Item:drawHold()

end

function Item:drawInventory()

end
