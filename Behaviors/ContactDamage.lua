require "utils"
local inspect = require "inspect"
ContactDamage = {}
ContactDamage.__index = ContactDamage

function ContactDamage.new(entity,damage,speed,knockback,allowed,seekBehavior) -- seek behavior is optional
  local o = {}
  o.seekBehavior = seekBehavior
  o.damage = damage
  o.speed = speed
  o.attackRe = 0
  o.knockback = knockback
  o.allowed = allowed
  o.type = "ContactDamage"
  o.isControl = false
  o.entity = entity
  setmetatable(o, ContactDamage)
  return o
end

function ContactDamage:update(dt)
  for i=1, #self.seekBehavior.collisions do
    local allowed = false
    if(self.seekBehavior.collisions)then
      for x=1, #self.allowed do
        if self.seekBehavior.collisions[i].other.type == self.allowed[x] then
          allowed = true
        end
      end
    end
    if allowed and self.attackRe >= self.speed then
      self.seekBehavior.collisions[i].other.behaviors["Health"]:damage(self.damage)
      local vector = self.seekBehavior.collisions[i].move
      local vx, vy = utils.scaleVec(vector.x, vector.y, self.knockback)
      self.entity.x, self.entity.y = self.entity.world.world:move(self.entity, self.entity.x + vx, self.entity.y + vy)
      self.attackRe = 0
    elseif(allowed == true)then
      self.attackRe = self.attackRe + dt
    elseif(allowed == false)then
      self.attackRe = 0
    end
  end
end
