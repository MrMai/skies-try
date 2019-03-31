Spritesheet = {}
Spritesheet.__index = Spritesheet

function Spritesheet.newFromSheet(file, width, height)
  o = {}
  o.image = image
  o.quads = {}
  o.width = width
  o.height = height
  local image = love.graphics.newImage("/Assets/tilesets/topdown.png")
  image:setFilter("nearest")
  for y = 0, image:getHeight() - width, height do
    for x = 0, image:getWidth() - width, height do
      table.insert(o.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
    end
  end
  setmetatable(o, Spritesheet)
  return o
end

function Spritesheet:draw(index, x, y, scale, rotation)
  rotation = rotation or 0
  love.graphics.draw(self.image, self.quads[index], x, y, rotation, scale, scale)
end

function Spritesheet:drawS(index, x, y, scale, shader, rotation) -- this is insaneley slow, do not use!!!!
  rotation = rotation or 0
  love.graphics.setShader(shader)
  love.graphics.draw(self.image, self.quads[index], x, y, rotation, scale, scale)
  love.graphics.setShader()
end
