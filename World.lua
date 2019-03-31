require "Block"
require "utils"
require "lights"
require "ItemAttributes/Default"
local bump = require "bump"

World = {}
World.__index = World

function World.new(name)
  local o = {}
  o.name = name
  o.entities = {}
  o.world = bump.newWorld(4)
  o.lightWorld = Lights.new()
  o.caster = {}
  o.world:add(o.caster, 0,0,0.0001,0.0001)
  o.colorP = {
    {1,1,1},
    {1,0,0},
    {0,1,0},
    {0,0,1}
  }
  setmetatable(o, World)
  return o
end

local domain8 = {1,0,   1,1,    0,1,    -1,1,   -1,0,   -1,-1,    0,-1,   1,-1}
function World:isCorner(x,y)
  local numBlocks = 0
  for i=1,#domain8,2 do
    block = self:get(domain8[i] + x,domain8[i+1] + y)
    if(block ~= nil)then
      if(block.id ~= 0)then
        numBlocks = numBlocks + 1
      end
    end
  end
  if(numBlocks == 0 or numBlocks == 1 or numBlocks == 3 or numBlocks == 4 or numBlocks == 6 or numBlocks == 7)then
    return true
  elseif(numBlocks == 2)then
    local conflicts = {self:get(1 + x,y), self:get(-1 + x,y), self:get(x,1 + y), self:get(x,-1 + y)}
    if (conflicts[1].id ~= 0 and conflicts[2].id ~= 0) or (conflicts[3].id ~= 0 and conflicts[4].id ~= 0) then
      return false
    else
      return true
    end
  elseif(numBlocks == 5)then
    local conflicts = {self:get(1 + x,1 + y), self:get(-1 + x, 1 + y), self:get(-1 + x,-1 + y), self:get(1 + x,-1 + y)}
    local corners = 0
    for i=1, #conflicts do
      if(conflicts[i].id ~= 0)then
        corners = corners + 1
      end
    end
    if(corners > 2)then
      return true
    else
      return false
    end
  elseif(numBlocks == 8)then
    return false
  end
end

function World:update(dt)
  for i in pairs(self.entities) do
    i:update(dt)
    i:controlUpdate(dt)
  end
end

function World:draw(x, y, scale)
  local blockDraw = function()
    self:drawBoxes(x, y, scale)
  end
  --[[
  local lightMask = function()
    self.lightWorld:drawLights(blockDraw, 0, 0)
    love.graphics.circle("fill", 500, 500, 300, 20)
  end
  love.graphics.stencil(lightMask, "replace", 1)
  love.graphics.setStencilTest("greater", 0)
  ]]--
  self.lightWorld:drawLights(blockDraw, 0, 0)
  self:drawBoxes(x, y, scale)
  for i in pairs(self.entities) do
    i:draw(x,y,scale)
  end
  for i in pairs(self.entities) do
    i:drawUI(x,y,scale)
  end

end

function World:drawLightMask(x, y, scale)
  for i in pairs(self.entities) do
    i:drawLight(x,y,scale)
  end
end

function World:addEntity(entity)
  self.entities[entity] = entity
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

function World:cornersInRange(x,y,range)
  x,y = math.floor(x), math.floor(y)
  local corners = {}
  for kx=1, range * 2 do
    for ky=1, range * 2 do
      local locX, locY = x - range + kx, y - range + ky
      if(self:get(locX, locY).id ~= 0 and self:isCorner(locX, locY) and utils.pythag(locX - x, locY - y) < range)then
        table.insert(corners, locX)
        table.insert(corners, locY)
      end
    end
  end
  return corners
end

function World:checkCorners(x,y,range)
  local allCorners = {}
  local corners = self:cornersInRange(x,y,range)
  for i=1,#corners,2 do
    self:place(corners[i], corners[i+1], Block.new(2))
  end
end

function World:drawSightPolygon(drawX, drawY, scale, x,y,range)
  local visionRays = {}
  local allCorners = {}
  local corners = self:cornersInRange(x,y,range)
  for i=1, #corners, 2 do -- insert all 4 corners of each block
    table.insert(allCorners, corners[i])
    table.insert(allCorners, corners[i+1])
    table.insert(allCorners, corners[i]+1)
    table.insert(allCorners, corners[i+1])
    table.insert(allCorners, corners[i]+1)
    table.insert(allCorners, corners[i+1]+1)
    table.insert(allCorners, corners[i])
    table.insert(allCorners, corners[i+1]+1)
  end
  for i=1, 20 do -- adding vision rays
    local vecX, vecY = utils.angleVec(1/20 * (i-1) * 2 * math.pi, range)
    table.insert(allCorners, vecX + x)
    table.insert(allCorners, vecY + y)
  end
--  table.sort(sortedCorners, function(a,b) return a[2] > b[2] end)
  self.world:update(self.caster, x, y)
  for i=1,#allCorners,2 do
    local projX, projY = self.world:check(self.caster, allCorners[i], allCorners[i+1], Default.sightFilter)
    table.insert(visionRays, drawX + (projX * scale))
    table.insert(visionRays, drawY + (projY * scale))
  end
  love.graphics.setColor(1, 1, 1, 0.5)
  for i=1,#visionRays-2,2 do
    love.graphics.polygon("fill", drawX + (x * scale), drawY + (y * scale), visionRays[i], visionRays[i+1], visionRays[i+2], visionRays[i+3])
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
  if(x >= 0 and y >= 0)then
    return self[x+1][y+1]
  else
    return Block.new(0)
  end
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
  return Block.new(0)
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
