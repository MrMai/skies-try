Default = {}
Default.filter = function(item, other)
  if other.id ~= nil then return 'slide'
  elseif other.type == "GreenSlime" then return "slide"
  elseif other.type == "Player" then return "slide"
  end
  -- else return nil
end
