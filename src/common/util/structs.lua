--- @class Size
--- @field width number
--- @field height number
Size = {}
Size.__index = Size

--- size
--- @param width number
--- @param height number
--- @return Size
function Size:new(width, height)
    --- @type Size
    local obj = { width = width, height = height }
    setmetatable(obj, self)
    return obj
end

--- randomInRange
--- @param atLeast Size
--- @param atMost Size
--- @return Size
function Size.randomInRange(atLeast, atMost)
    if atMost == nil then
        atMost = atLeast
        atLeast = Size:new(0, 0)
    end
    return Size:new(math.random(atLeast.width, atMost.width), math.random(atLeast.height, atMost.height))
end

--- Size:unpack
--- @return number, number
function Size:unpack()
    return self.width, self.height
end

--- toXY
--- @return XY
function Size:toXY()
    return XY:new(self.width, self.height)
end

--- toString
--- @return string
function Size:toString()
    return "{ w: "..self.width..", h: "..self.height.." }"
end

--- divideBy
--- @param any number|XY|Size
--- @return Size
function Size:divideBy(any)
    if type(any) == "number" then
        return self:divideBy(XY:new(any, any))

    elseif any.x ~= nil and any.y ~= nil then
        return Size:new(self.width / any.x, self.height / any.y)

    elseif any.width ~= nil and any.height ~= nil then
        return self:divideBy(any:toXY())
    end

    error("Size:divideBy(any): any argument must be either of type number, XY or Size")
end

--- Size:__mul
--- @param other Size
function Size:__mul(other)
    if type(other) == "number" then return self * { width = other, height = other } end

    return Size:new(self.width * other.width, self.height * other.height)
end

--- Size:__sub
--- @param other Size
function Size:__sub(other)
    return Size:new(self.width - other.width, self.height - other.height)
end

--- Size:__add
--- @param other Size
function Size:__add(other)
    return Size:new(self.width + other.width, self.height + other.height)
end

function Size:halvedHeight()
    return self:divideBy(XY:new(1, 2))
end

Size.__div = Size.divideBy

--- @class XYProvider
--- @field x number
--- @field y number

--- @class XY : XYProvider
--- @field x number
--- @field y number
XY = {}
XY.__index = XY

--- xy
--- @param x number
--- @param y number
--- @return XY
function XY:new(x, y)
    --- @type XY
    local obj = { x = x, y = y }
    setmetatable(obj, XY)
    return obj
end

--- xy
--- @overload fun(number: number): XY
--- @overload fun(pseudoXY: XYProvider): XY
--- @return XY
function XY.of(any)
    if type(any) == "number" then
        return XY:new(any, any)
    end
    if type(any.x) == "number" and type(any.y) == "number" then
        return XY:new(any.x, any.y)
    end
    error("`any` in XY.of(any) must be either number or contain fields x, y of type number")
end

--- randomInRange
--- @param atLeast XY
--- @param atMost XY
--- @return XY
function XY.randomInRange(atLeast, atMost)
    if atMost == nil then
        atMost = atLeast
        atLeast = XY:new(0, 0)
    end
    return XY:new(math.random(atLeast.x, atMost.x), math.random(atLeast.y, atMost.y))
end

--- XY:unpack
--- @return number, number
function XY:unpack()
    return self.x, self.y
end

--- XY:toSize
--- @return Size
function XY:toSize()
    return Size:new(self.x, self.y)
end

--- XY:divideBy
--- @param other XY
--- @return XY
function XY:multiplyBy(other)
    return XY:new(self.x * other.x, self.y * other.y)
end

XY.__mul = XY.multiplyBy

--- XY:divideBy
--- @param other XY
--- @return XY
function XY:divideBy(other)
    return XY:new(self.x / other.x, self.y / other.y)
end

XY.__div = XY.divideBy

--- XY:__add
--- @param other XY
function XY:__add(other)
    return XY:new(self.x + other.x, self.y + other.y)
end

--- XY:__sub
--- @param other XY
function XY:__sub(other)
    return XY:new(self.x - other.x, self.y - other.y)
end

--- XY:distanceTo
--- @param other XY
function XY:distanceTo(other)
    return math.sqrt(self:squaredDistanceTo(other))
end

--- XY:distanceToSquared
--- @param other XY
function XY:squaredDistanceTo(other)
    local offset = other - self
    return offset.x ^ 2 + offset.y ^ 2
end

--- XY:abs
--- @return XY
function XY:abs()
    return XY:new(math.abs(self.x), math.abs(self.y))
end

--- XY.sizeAndCenterOf
--- @param a XY
--- @param b XY
--- @return Size, XY
function XY.sizeAndCenterOf(a, b)
    return (b - a):toSize(), (a + b) / XY.of(2)
end

--- XY:toString
--- @return string
function XY:toString()
    return "{ x: "..self.x..", y: "..self.y.." }"
end
