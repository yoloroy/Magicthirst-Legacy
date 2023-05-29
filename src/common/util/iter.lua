require "src.common.util.array"

--- @class Iterable : Array<V>
--- @generic V
Iterable = {}
Iterable.__index = Iterable

--- Iterable:new
--- @generic T
--- @param list T[]
--- @return Iterable
function Iterable:new(list)
    --- @generic T
    --- @type Iterable
    local obj = { unpack(list) }
    setmetatable(obj, self)
    return obj
end

--- Iterable.ofRange
--- @generic T
--- @param first number
--- @param last number
--- @return Iterable
function Iterable.ofRange(first, last)
    --- @generic T
    --- @type Iterable
    local obj = Iterable:new {}
    for i = first, last do table.insert(obj, i) end
    return obj
end

--- Iterable.ofCount
--- @generic T
--- @param n number
--- @return Iterable
function Iterable.ofCount(n)
    return Iterable.ofRange(1, n)
end

--- Iterable:appended
--- @generic T
--- @param other T[]
--- @return Iterable
function Iterable:append(other)
    --- @generic R
    --- @type Iterable
    local result = Iterable:new {}
    for i, v in ipairs(self) do
        result[i] = v
    end
    for i, v in ipairs(other) do
        result[#self + i] = v
    end
    return result
end

--- Iterable:replace
--- @generic T
--- @overload fun(predicate: (fun(t: T): boolean), replacement: T): Iterable
--- @overload fun(replacee: T, mapper: fun(t: T): T): Iterable
--- @overload fun(replacee: T, replacement: T): Iterable
--- @param predicate fun(t: T): boolean
--- @param mapper fun(t: T): T
--- @return Iterable
function Iterable:replace(predicate, mapper)
    if type(predicate) ~= "function" then
        return self:replace(function(t) return t == predicate end, mapper)
    end
    if type(mapper) ~= "function" then
        return self:replace(predicate, function(_) return mapper end)
    end
    return self:map(function(t) if predicate(t) then return mapper(t) else return t end end)
end

--- Iterable:map
--- @generic T
--- @generic R
--- @param func fun(t: T): R
--- @return Iterable
function Iterable:map(func)
    --- @generic R
    --- @type Iterable
    local result = Iterable:new {}
    for i, v in ipairs(self) do
        result[i] = func(v)
    end
    return result
end

--- Iterable:buildMap
--- @generic T
--- @generic R
--- @param func fun(accumulator: Iterable, t: T)
--- @return Iterable
function Iterable:buildMap(func)
    --- @generic R
    --- @type Iterable
    local result = Iterable:new {}
    for _, v in ipairs(self) do
        func(result, v)
    end
    return result
end

--- Iterable:flatMap
--- @generic T
--- @generic R
--- @param func fun(t: T): R[]
--- @return Iterable
function Iterable:flatMap(func)
    return self:buildMap(function(acc, t) table.insertAll(acc, func(t)) end)
end

--- Iterable:flatten
--- @generic T
--- @return Iterable
function Iterable:flatten()
    --- @generic R
    --- @type Iterable
    local result = Iterable:new {}
    for _, v in ipairs(self) do
        table.insertAll(result, v)
    end
    return result
end

--- Iterable:productWith
--- @generic T1
--- @generic T2
--- @param other T2[]
--- @return Iterable Pairs: { [1]: T1, [2]: T2 }[]
function Iterable:productWith(other)
    --- @type Iterable
    local result = Iterable:new {}
    for _, v1 in ipairs(self) do
        for _, v2 in ipairs(other) do
            table.insert(result, { v1, v2 })
        end
    end
    return result
end

--- Iterable:zip
--- @generic T1
--- @generic T2
--- @param other T2[]
--- @return Iterable
function Iterable:zip(other)
    --- @type Iterable<table[]>
    local result = Iterable:new {}
    for i, v in ipairs(self) do
        result[i] = { v, other[i] }
    end
    return result
end

--- Iterable:filter
--- @generic T
--- @param predicate fun(t: T): boolean
--- @return Iterable
function Iterable:filter(predicate)
    --- @type Iterable
    local result = Iterable:new {}
    for _, t in ipairs(self) do
        if predicate(t) then
            table.insert(result, t)
        end
    end
    return result
end

--- Iterable:sort
--- @generic T
--- @param comp fun(t1: T, t2: T): boolean
--- @return Iterable
function Iterable:sort(comp)
    --- @type Iterable
    local result = Iterable:new(self)
    table.sort(result, comp)
    return result
end

--- Iterable:sortBy
--- @generic T
--- @param map fun(t): 'comparable'
--- @return Iterable
function Iterable:sortBy(map)
    --- @type Iterable
    local result = Iterable:new(self)
    table.sort(result, function(a, b) return map(a) < map(b) end)
    return result
end

--- Iterable:limit
--- @generic T
--- @param count number
--- @return Iterable
function Iterable:limit(count)
    --- @type Iterable
    local result = Iterable:new {}
    for i = 1, math.min(count, #self) do
        table.insert(result, self[i])
    end
    return result
end

--- Iterable:onEach
--- @generic T
--- @param block fun(t: T)
--- @return Iterable
function Iterable:onEach(block)
    for _, t in ipairs(self) do
        block(t)
    end
    return self
end

--- Iterable:callAll
--- @vararg any[] args which will become parameters for all function that this list contains
--- @return Iterable
function Iterable:callAll(...)
    for _, fun in ipairs(self) do
        fun(unpack(arg))
    end
    return self
end
