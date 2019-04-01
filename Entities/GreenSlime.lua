require "Entity"
require "Behaviors/SightSeek"
require "Behaviors/ContactDamage"
require "Behaviors/Wander"
require "Drawables/AnimateWhile"
require "Spritesheet"

GreenSlime = {}
setmetatable(GreenSlime, Entity)
GreenSlime.__index = GreenSlime
GreenSlime.allowed = {"Player"}
GreenSlime.movingAnimation = Spritesheet.newFromSheet("Assets/greenBlobMoving.png",16,16)
GreenSlime.health = 2
GreenSlime.range = 25
GreenSlime.speed = 7
GreenSlime.decisiveness = 2.5
GreenSlime.wanderSpeed = 2
GreenSlime.wallClosest = 1
GreenSlime.wanderRange = 10
GreenSlime.lazyness = 0.5
GreenSlime.rooting = 1
GreenSlime.waitTime = 0.5
GreenSlime.damage = 0.5
GreenSlime.attackSpeed = 0.5
GreenSlime.knockback = 3
GreenSlime.color = {0.44140625, 0.9375, 0.1328125}

function GreenSlime.new(world,x,y)
  o = Entity.new(x,y)
  o.type = "GreenSlime"
  o.width, o.height = 0.8 + ((math.random() - 0.5) * 0.2),0.8 + ((math.random() - 0.5) * 0.2)
  o.world = world
  world.world:add(o, x,y,o.width,o.height)
  -- Behaviors
  local health = Health.new(o, GreenSlime.health, GreenSlime.health)
  o:addBehavior(health)
  local sightSeek = SightSeek.new(o, GreenSlime.allowed, GreenSlime.range, GreenSlime.speed, GreenSlime.waitTime)
  o:addBehavior(sightSeek)
  local contactDamage = ContactDamage.new(o, GreenSlime.damage, GreenSlime.attackSpeed, GreenSlime.knockback, GreenSlime.allowed, sightSeek)
  o:addBehavior(contactDamage)
  local wander = Wander.new(o, 8, GreenSlime.wanderRange, GreenSlime.wanderSpeed, GreenSlime.decisiveness, GreenSlime.wallClosest, GreenSlime.lazyness, GreenSlime.rooting)
  o:addBehavior(wander)
  -- Drawables
  --local entityBox = EntityBox.new(o, GreenSlime.color)
  --o:addDrawable(entityBox)
  local healthMeter = HealthMeter.new(o, health, -0.35, -1, 0.7,0.4)
  o:addDrawable(healthMeter)
  local animateWhileWalking = AnimateWhile.new(o, GreenSlime.movingAnimation, {0.3, 0.3}, {"Wandering","Seeking"})
  setmetatable(o, GreenSlime)
  return o
end


function GreenSlime:kill()
  self.world.world:remove(self)
  self.world.entities[self] = nil
end
