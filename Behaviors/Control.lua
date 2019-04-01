require "ItemAttributes/Default"
require "utils"

Control = {}
Control.__index = Control

function Control.new(entity, speed,acceleration)
  local o = {}
  o.type = "Control"
  o.isControl = true
  o.entity = entity
  o.maxspeed = speed
  o.speed = speed
  o.acceleration = acceleration or speed
  o.currentSpeed = 0
  setmetatable(o, Control)
  return o
end

function Control:update(dt)
  local vx, vy = 0,0
  local modifier = 1
  if (love.keyboard.isDown("d", "right") or love.keyboard.isDown("a", "left")) and (love.keyboard.isDown("w", "up") or love.keyboard.isDown("s", "down")) then
    modifier = 1.73205080757
  end
  if love.keyboard.isDown("d", "right") or love.keyboard.isDown("a", "left") or love.keyboard.isDown("w", "up") or love.keyboard.isDown("s", "down") then
    if(self.currentSpeed <= self.speed / modifier)then
      self.currentSpeed = self.currentSpeed + (dt * self.acceleration / modifier)
      if(self.currentSpeed > self.speed / modifier)then
        self.currentSpeed = self.speed / modifier
      end
    end
  else
    if(self.currentSpeed > 0)then
      self.currentSpeed = self.currentSpeed - (dt * self.acceleration / modifier)
      if(self.currentSpeed < 0)then
        self.currentSpeed = 0
      end
    end
  end
  if(self.currentSpeed > self.speed / modifier)then
    self.currentSpeed = self.speed / modifier
  end
  if love.keyboard.isDown("d", "right") then
    vx = vx + 1
  end
  if love.keyboard.isDown("a", "left") then
    vx = vx - 1
  end
  if love.keyboard.isDown("s", "down") then
    vy = vy + 1
  end
  if love.keyboard.isDown("w", "up") then
    vy = vy - 1
  end
  vx = vx * self.currentSpeed
  vy = vy * self.currentSpeed
  if(self.vx or self.vy)then
    self.entity.currently["Controlling"] = true
  end
  self.entity.x, self.entity.y = self.entity.world.world:move(self.entity, self.entity.x + (vx * dt), self.entity.y + (vy * dt), Default.filter)
end
