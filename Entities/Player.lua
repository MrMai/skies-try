require "Entity"
require "Behaviors/Control"
require "Behaviors/Health"
require "Drawables/EntityBox"
require "Drawables/HealthMeter"

Player = {}
setmetatable(Player, Entity)
Player.__index = Player
Player.color = {0.28515625, 0.52734375, 0.8515625}
Player.speed = 8
Player.acceleration = 8
Player.projectileFilter = function(item, other)
  if other.id ~= nil then
    return 'touch'
  elseif other.type == "GreenSlime" then
    return "touch"
  end
  -- else return nil
end

function Player.new(world,x,y)
  o = Entity.new(x,y)
  o.type = "Player"
  o.width, o.height = 1.5, 1.5
  o.world = world
  world.world:add(o,x,y,o.width,o.height)

  -- Behaviors
  local control = Control.new(o, Player.speed, Player.acceleration)
  o:addBehavior(control)
  local health = Health.new(o, 5)
  o:addBehavior(health)

  -- Drawables
  local entityBox = EntityBox.new(o, Player.color)
  o:addDrawable(entityBox)
  local healthMeter = HealthMeter.new(o, health, -0.8, -1.4, 1.6,0.4)
  o:addDrawable(healthMeter)

  setmetatable(o, Player)
  return o
end
