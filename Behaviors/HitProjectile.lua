HitProjectile = {}
HitProjectile.__index = HitProjectile

function HitProjectile.new(entity, damage, vx, vy, filter)
  local o = {}
  o.type = "HitProjectile"
  o.isControl = false
  o.entity = entity
  o.filter = filter
  o.damage = damage
  print(vx,vy)
  o.vx, o.vy = vx,vy
  setmetatable(o, HitProjectile)
  return o
end

function HitProjectile:update(dt)
  local cols, num = nil,nil
  self.entity.x,self.entity.y,cols,num = self.entity.world.world:move(self.entity, self.entity.x + (self.vx * dt), self.entity.y + (self.vy * dt), self.filter)
  if(num > 0)then
    for i=1, #cols do
      if(cols[i].other.behaviors ~= nil and cols[i].other.behaviors["Health"] ~= nil) then
        cols[i].other.behaviors["Health"]:damage(self.damage)
      end
    end
    print("arrow dead")
    self.entity:kill()
  end
end
