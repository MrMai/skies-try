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
  return utils.pythag(utils.pointVec(x1,y1,x2,y2))
end

function utils.pythag(x,y)
  return math.sqrt(math.pow(x, 2) + math.pow(y, 2))
end

function utils.indexSearch(k, plist)
  for i=1, #plist do
    local v = plist[i][k]
    if v then return v end
  end
end

function utils.round(x)
  if(x - math.floor(x) >= 0.5)then
    return math.ceil(x)
  else
    return math.floor(x)
  end
end

function utils.pointVec(x1,y1,x2,y2)
  return x2 - x1, y2 - y1
end

function utils.angleVec(angle, mag)
  mag = mag or 1
  return math.cos(angle) * mag, math.sin(angle) * mag
end
function utils.scaledVec(x1,y1,x2,y2,dist)
  dist = dist or 1
  return utils.scaleVec(x2-x1,y2-y1,dist)
end

function utils.scaleVec(x,y,dist)
  dist = dist or 1
  local diag = utils.pythag(x,y)
  return x / diag * dist, y / diag * dist
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

function utils.raycast(world, caster, filter, fromX, fromY, toX, toY) -- physics world
  world:update(caster, fromX, fromY)
  return world:check(caster, toX, toY, filter)
end

function utils.dotProduct(x1,y1,x2,y2)
	return (x1 * x2) + (y1 * y2)
end

function utils.vecAngle(x,y)
	local ang = math.acos(math.abs(utils.dotProduct(x,y,1,0)) / utils.pythag(x,y))
	if(y < math.pi)then
		ang = math.pi * 2 - ang
	end
	return ang
end

function utils.roundVec(x,y, seg) -- doesnt work
  local angle = math.floor(utils.vecAngle(x,y) / (2 * math.pi) * seg) / seg * 2 * math.pi
  return utils.angleVec(angle, utils.pythag(x,y))
end
