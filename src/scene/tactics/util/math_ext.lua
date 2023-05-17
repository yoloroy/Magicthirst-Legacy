require "src.common.util.structs"

--- math.vectorOf
--- @param degrees number
--- @param speed number
--- @return XY
function math.vectorOf(degrees, speed)
    return XY:new(
        math.cos(math.rad(degrees)) * speed,
        math.sin(math.rad(degrees)) * speed
    )
end

--- math.normalize
--- @param xy XY
--- @return XY
function math.normalize(xy)
    local length = XY.of(0):distanceTo(xy)
    return XY:new(xy.x / length, xy.y / length)
end

--- math.angleOf
--- @param xy XY normalized vector
--- @return number
function math.angleOf(xy)
    return math.deg(math.atan2(xy.y, xy.x))
end

--- math.roundUpToDivisor
--- @param x number
--- @param divisor number
--- @return number
function math.roundUpToDivisor(x, divisor)
    return math.ceil(x / divisor) * divisor
end

--- math.roundDownToDivisor
--- @param x number
--- @param divisor number
--- @return number
function math.roundDownToDivisor(x, divisor)
    return math.floor(x / divisor) * divisor
end
