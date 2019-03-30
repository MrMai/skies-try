require "Entity"
require "Behaviors/HitProjectile"
require "Behaviors/Disintegration"
require "utils"

Arrow = {}
setmetatable(Arrow, Entity)
Arrow.__index = Arrow
Arrow.speed = 48
Arrow.damage = 1
Arrow.width = 0.4
Arrow.height = 0.4
Arrow.color = {1, 0.8, 0.8}
Arrow.lifetime = 0.6

function Arrow.new(world,x,y,vx,vy,filter)
  o = Entity.new(x-(Arrow.width/2),y-(Arrow.height/2))
  o.type = "Arrow"
  o.world = world
  o.world.world:add(o,x,y,Arrow.width,Arrow.height)
  -- Behaviors
  vx, vy = utils.scaleVec(vx,vy,Arrow.speed)
  local disintegration = Disintegration.new(o, Arrow.lifetime, {"IsFlyingProjectile"})
  o:addBehavior(disintegration)
  local hitProjectile = HitProjectile.new(o, Arrow.damage, vx, vy, filter)
  o:addBehavior(hitProjectile)
  -- drawables
  local entityBox = EntityBox.new(o, Arrow.color)
  o:addDrawable(entityBox)

  setmetatable(o, Arrow)
  return o
end

function Arrow:kill()
  self.world.world:remove(self)
  self.world.entities[self] = nil
end
