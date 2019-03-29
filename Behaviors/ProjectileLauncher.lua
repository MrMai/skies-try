
ProjectileLauncher = {}
ProjectileLauncher.__index = ProjectileLauncher

function ProjectileLauncher.new(entity, controlBehavior, damage, speed, projectile)
  local o = {}
  o.type = "ProjectileLauncher"
  o.isControl = false
  o.entity = entity
  o.controlBehavior = controlBehavior
  o.damage = damage
  o.speed = speed
  o.projectile = projectile
  o.currentTime = 0
  setmetatable(o, ProjectileLauncher)
  return o
end

function ProjectileLauncher:update(dt)

end
