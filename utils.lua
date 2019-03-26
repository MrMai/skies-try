utils = {}

function utils.split(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

function utils.distanceFrom(x1,y1,x2,y2)
  return math.sqrt(math.pow(x2 - x1, 2) + math.pow(y2 - y1, 2))
end

function utils.indexSearch(k, plist)
  for i=1, #plist do
    local v = plist[i][k]
    if v then return v end
  end
end

function utils.createClass(...) -- a method to create multiple inheritance classes
  local c = {}
  setmetatable(c, {__index = function(t,k)
    local v = utils.search(k, arg)
    t[k] = v
    return v
  end})
  c.__index = c
  return c
end
