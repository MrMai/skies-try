
Control = {}
Control.__index = Control

function Control.new(entity, speed)
  local o = {}
  o.isControl = true
  o.entity = entity
  o.speed = speed
  setmetatable(o, Control)
  return o
end

function Control:update(dt)
  local vx, vy = 0,0
  if love.keyboard.isDown("d", "right") then
    vx = (self.speed * dt)
  end
  if love.keyboard.isDown("a", "left") then
    vx = -(self.speed * dt)
  end
  if love.keyboard.isDown("w", "up") then
    vy = -(self.speed * dt)
  end
  if love.keyboard.isDown("s", "down") then
    vy = (self.speed * dt)
  end
  if(vx ~= 0 and vy ~= 0)then
    vx = vx / 1.414213562373095 -- square root of two
    vy = vy / 1.414213562373095
  end
  local actualX, actualY, cols, len = self.entity.world.world:move(self.entity, self.entity.x + vx, self.entity.y + vy)
  self.entity.x = actualX
  self.entity.y = actualY
end
