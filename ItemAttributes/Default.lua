Default = {}
Default.filter = function(item, other)
  if other.id ~= nil then return 'slide'
  elseif other.type == "GreenSlime" then return "slide"
  elseif other.type == "Player" then return "slide"
  end
  -- else return nil
end
Default.hitFilter = function(item, other)
  if other.id ~= nil then return 'touch'
  elseif other.type == "GreenSlime" then return "touch"
  elseif other.type == "Player" then return "touch"
  end
  -- else return nil
end
Default.sightFilter = function(item, other)
  if other.id ~= nil then return 'touch' end
  -- else return nil
end
Default.healthColor = {0.9765625, 0.06640625, 0.08203125}
