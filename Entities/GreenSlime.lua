require "Entity"
require "Behaviors/SightSeek"
require "Behaviors/ContactDamage"
require "Behaviors/Wander"

GreenSlime = {}
setmetatable(GreenSlime, Entity)
GreenSlime.__index = GreenSlime
GreenSlime.allowed = {"Player"}
GreenSlime.health = 2
GreenSlime.range = 10
GreenSlime.speed = 8
GreenSlime.decisiveness = 5
GreenSlime.wanderSpeed = 2
GreenSlime.wanderRange = 2
GreenSlime.lazyness = 0.5
GreenSlime.waitTime = 0.5
GreenSlime.damage = 0.5
GreenSlime.attackSpeed = 0.5
GreenSlime.knockback = 3
GreenSlime.color = {0.5390625, 0.85546875, 0.1953125}

function GreenSlime.new(world,x,y)
  o = Entity.new(x,y)
  o.type = "GreenSlime"
  o.width, o.height = 1,1
  o.world = world
  world.world:add(o, x,y,o.width,o.height)

  local health = Health.new(o, GreenSlime.health, GreenSlime.health)
  o:addBehavior(health)
  local sightSeek = SightSeek.new(o, GreenSlime.allowed, GreenSlime.range, GreenSlime.speed, GreenSlime.waitTime)
  o:addBehavior(sightSeek)
  local contactDamage = ContactDamage.new(o, GreenSlime.damage, GreenSlime.attackSpeed, GreenSlime.knockback, GreenSlime.allowed, sightSeek)
  o:addBehavior(contactDamage)
  local wander = Wander.new(o, 8, GreenSlime.wanderRange, GreenSlime.wanderSpeed, GreenSlime.decisiveness, GreenSlime.lazyness)
  o:addBehavior(wander)

  o.drawables = {}
  local entityBox = EntityBox.new(o, GreenSlime.color)
  o:addDrawable(entityBox)

  setmetatable(o, GreenSlime)
  return o
end