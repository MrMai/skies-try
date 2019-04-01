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
  o.vx, o.vy = 0,0
  setmetatable(o, Control)
  return o
end

function Control:update(dt)
  local movedX, movedY = false, false
  local nonsingle = 1
  local refSpeed = self.speed
  if(love.keyboard.isDown("d", "right") or love.keyboard.isDown("a", "left")) and (love.keyboard.isDown("w", "up") or love.keyboard.isDown("s", "down"))then
    nonsingle = 1.414213562373095
    refSpeed = self.speed / 1.414213562373095
  end
  print("moving")
  if love.keyboard.isDown("d", "right") and self.vx <= refSpeed then
    movedX = true
    self.vx = self.vx + (self.acceleration * dt / nonsingle)
    print("moving right", self.vx)
  end
  if love.keyboard.isDown("a", "left") and self.vx <= refSpeed then
    movedX = true
    self.vx = self.vx - (self.acceleration * dt / nonsingle)
    print("moving left", self.vx)
  end
  if love.keyboard.isDown("w", "up") and self.vy <= refSpeed then
    movedY = true
    self.vy = self.vy - (self.acceleration * dt / nonsingle)
    print("moving up", self.vy)
  end
  if love.keyboard.isDown("s", "down") and self.vy <= refSpeed then
    movedY = true
    self.vy = self.vy + (self.acceleration * dt / nonsingle)
    print("moving down", self.vy)
  end
  if movedX == false then
    if(self.vx > 0)then
      self.vx = self.vx - (self.acceleration * dt)
      if(self.vx < 0)then
        self.vx = 0
      end
    elseif(self.vx ~= 0)then
      self.vx = self.vx + (self.acceleration * dt)
      if(self.vx > 0)then
        self.vx = 0
      end
    end
  end
  if(not movedY)then
    if(self.vy > 0)then
      self.vy = self.vy - (self.acceleration * dt)
      if(self.vy < 0)then
        self.vy = 0
      end
    elseif(self.vy ~= 0)then
      self.vy = self.vy + (self.acceleration * dt)
      if(self.vy > 0)then
        self.vy = 0
      end
    end
  end
  if(self.vx > refSpeed)then
    self.vx = self.speed
  elseif(self.vx < -refSpeed)then
    self.vx = -self.speed
  end
  if(self.vy > refSpeed)then
    self.vy = self.speed
  elseif(self.vy < -refSpeed)then
    self.vy = -self.speed
  end
  if(self.vx or self.vy)then
    self.entity.currently["Controlling"] = true
  end
  self.entity.x, self.entity.y = self.entity.world.world:move(self.entity, self.entity.x + (self.vx * dt), self.entity.y + (self.vy * dt), Default.filter)
end
