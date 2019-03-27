require "Entity"
require "Behaviors/Control"
require "Behaviors/Health"
require "Drawables/EntityBox"

Player = {}
setmetatable(Player, Entity)
Player.__index = Player
Player.COLOR = {0.28515625, 0.52734375, 0.8515625}
Player.speed = 8

function Player.new(world,x,y)
  o = Entity.new(x,y)
  o.type = "Player"
  o.width, o.height = 1.5, 1.5
  o.world = world
  world.world:add(o,x,y,o.width,o.height)

  o.behaviorList = {}
  o.behaviors = {}

  local control = Control.new(o, Player.speed)
  o:addBehavior(control)

  local health = Health.new(o, 5)
  o:addBehavior(health)

  o.drawables = {}
  local entityBox = EntityBox.new(o, Player.COLOR)
  o:addDrawable(entityBox)

  setmetatable(o, Player)
  return o
end
