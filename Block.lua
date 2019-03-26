local bump = require "bump"

Block = {}
Block.__index = Block

function Block.new(id)
  local o = {}
  o.id = id
  setmetatable(o, Block)
  return o
end

function Block.fromStore(str)
  local o = {}
  o.id = tonumber(str)
  setmetatable(o, Block)
  return o
end

function Block:toStore()
  return self.id
end
