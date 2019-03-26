require "Block"
require "utils"
local bump = require "bump"

World = {}
World.__index = World

function World.new(name)
  local o = {}
  o.name = name
  o.entities = {}
  o.world = bump.newWorld(4)
  o.colorP = {
    {1,1,1},
    {1,0,0},
    {0,1,0},
    {0,0,1}
  }
  setmetatable(o, World)
  return o
end

function World:update(dt)
  for i=1, #self.entities do
    self.entities[i]:update(dt)
    self.entities[i]:controlUpdate(dt)
  end
end

function World:draw(x, y, scale)
  self:drawBoxes(x, y, scale)
  for i=1, #self.entities do
    self.entities[i]:draw(x,y,scale)
  end
end

function World:addEntity(entity)
  table.insert(self.entities, entity)
end

function World:findType(type)
  ents = {}
  for i=1, #self.entities do
    if(self.entities[i].type == type)then
      table.insert(ents, self.entities[i])
    end
  end
  if(#ents == 0)then
    return nil
  else
    return ents
  end
end


function World:width()
  return #self
end

function World:height()
  return #self[1]
end

function World:manifestBlocks()
  for kx=0,self:width()-1 do
    for ky=0,self:height()-1 do
      if(self:get(kx,ky).id ~= 0)then
        self.world:add(self:get(kx,ky),kx,ky,1,1)
      end
    end
  end
end

function World:disintergrateBlocks()
  for kx=1,self:width() do
    for ky=1,self:height() do
      if(self:get(kx,ky).id ~= 0)then
        self.world:remove(self[kx][ky])
      end
    end
  end
end

function World:store(filename)
  filename = filename or self.name
  local str = ""
  for x=1, #self do
    for y=1, #self[x] do
      str = str .. self[x][y]:toStore() .. " "
    end
    str = str .. "\n"
  end
  local file, error = love.filesystem.newFile(filename)
  if (file == nil) then
    print(error)
    return false
  else
    file:open("w")
    file:write(str)
    file:close()
  end
end

function World:load(filename)
  filename = filename or self.name
  local file, err = love.filesystem.newFile(filename)
  if(file ~= nil)then
    newWorld = {}
    file:open("r")
    rows = utils.split(file:read(), "\n")
    for x, r in ipairs(rows) do
      str = utils.split(r, " ")
      row = {}
      for y, c in ipairs(str) do
        table.insert(row, Block.fromStore(c))
      end
      table.insert(newWorld, row)
    end
    self:fill(#newWorld, #newWorld[1])
    for x=1, #newWorld do
      for y=1, #newWorld[1] do
        self[x][y] = newWorld[x][y]
      end
    end
    self:manifestBlocks()
    file:close()
    return true
  else
    print(err)
    return false
  end
end

function World:fill(width, height)
  for kx=1, width do
    self[kx] = {}
    for ky=1, height do
      self[kx][ky] = Block.new(0)
    end
  end
end

function World:drawSprites(x,y,scale)
  for kx=0,#self do
    for ky=0,#self[1] do
      if(self[kx+1][ky+1] ~= 0)then
        self.spritesheet.draw(self[kx+1][ky+1],x + (self.spritesheet.width * scale * kx), y + (self.spritesheet.height * scale * ky), scale)
    	end
    end
  end
end

function World:drawBoxes(x,y,scale)
  for kx=0,self:width()-1 do
    for ky=0,self:height()-1 do
      if(self[kx+1][ky+1].id ~= 0)then
        love.graphics.setColor(self.colorP[self[kx+1][ky+1].id])
        love.graphics.setLineWidth(1)
        love.graphics.rectangle("line",x + (scale * kx), y + (scale * ky), scale, scale)
    	end
    end
  end
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("line", x, y, scale * self:width(), scale * self:height())
end

function World:get(x,y) -- from 0,0 as the first top left block
  return self[x+1][y+1]
end

function World:set(x,y,block) -- same as get
  self[x+1][y+1] = block
end

function World:dig(x,y)
  local blockdug = self:get(x,y)
  if(blockdug.id ~= 0)then
    self.world:remove(blockdug)
    self:set(x,y,Block.new(0))
    return blockdug
  end
  return nil
end

function World:place(x,y,block)
  local blockdug = self:get(x,y)
  if(blockdug.id ~= 0)then
    self.world:remove(blockdug)
  end
  self.world:add(block,x,y,1,1)
  self:set(x,y,block)
  return blockdug
end
