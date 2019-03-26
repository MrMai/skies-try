Spritesheet = {}

function Spritesheet:new(file, width, height)
  image = love.graphics.newImage(file)
  image:setFilter("nearest")
  o = {image = image, quads = {}, width = width, height = height}
  for y = 0, image:getHeight() - height, height do
    for x = 0, image:getWidth() - width, width do
      table.insert(o.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
    end
  end
  setmetatable(o, self)
  self.__index = self
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
