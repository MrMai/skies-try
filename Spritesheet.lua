Spritesheet = {}
Spritesheet.__index = Spritesheet

function Spritesheet.newFromSheet(file, width, height)
  o = {}
  o.quads = {}
  o.width = width
  o.height = height
  o.image = love.graphics.newImage(file)
  o.image:setFilter("nearest")
  for y = 0, o.image:getHeight() - width, height do
    for x = 0, o.image:getWidth() - width, height do
      table.insert(o.quads, love.graphics.newQuad(x, y, width, height, o.image:getDimensions()))
    end
  end
  setmetatable(o, Spritesheet)
  return o
end

function Spritesheet:draw(index, x, y, scale, rotation)
  rotation = rotation or 0
  wscale = scale / self.width
  hscale = scale / self.height
  love.graphics.draw(self.image, self.quads[index], x, y, rotation, wscale, hscale)
end
