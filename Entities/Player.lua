require "Entity"
require "Behaviors/Control"
require "Behaviors/Health"
require "Drawables/EntityBox"
local DEFAULT_SPEED = 10

Player = {}
setmetatable(Player, Entity)
Player.__index = Player
Player.COLOR = {0.28515625, 0.52734375, 0.8515625}

function Player.new(world,x,y)
  o = Entity.new()
  o.type = "Player"
  o.x, o.y = x, y
  o.width, o.height = 1.5, 1.5
  o.world = world
  world.world:add(o, x,y,o.width,o.height)

  o.behaviorList = {}
  o.behaviors = {}

  local control = Control.new(o, DEFAULT_SPEED)
  o.behaviorList["Control"] = control
  table.insert(o.behaviors, control)

  local health = Health.new(o, 5)
  o.behaviorList["Health"] = health
  table.insert(o.behaviors, health)

  o.drawables = {}
  local entityBox = EntityBox.new(o, Player.COLOR)
  table.insert(o.drawables, entityBox)

  setmetatable(o, Player)
  return o
end
