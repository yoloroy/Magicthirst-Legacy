require "src.scene.tactics.util.math_ext"

--- @class MoveAI
--- @field _controllable Controllable
--- @field _calculateDirection
MoveAI = {}
MoveAI.__index = MoveAI

--- MoveAI:new
--- @param controllable Controllable
--- @param directionProvider fun(selfXY: XYProvider): number
--- @return MoveAI
function MoveAI:new(controllable, directionProvider)
    --- @type MoveAI
    local obj = {
        _controllable = controllable,
        _calculateDirection = directionProvider
    }
    setmetatable(obj, self)
    return obj
end

--- MoveAI:updateDirection
function MoveAI:updateDirection()
    local newDirection = self._calculateDirection(self._controllable:provideXY())
    -- FIXME refactor
    if type(self._controllable.direction) == "number" then
        self._controllable.direction = newDirection
    else
        self._controllable.direction:set(newDirection)
    end
end

--- @class Controllable
--- @field provideXY fun(self: Controllable): XYProvider
--- @field direction number|Observable nillable

--- directionThroughWallsProvider
--- @param target XYProvider
--- @param startFollowingDistance number
--- @return fun(selfXY: XYProvider): number
function directionThroughWallsProvider(target, startFollowingDistance, stopFollowingDistance) -- FIXME target
    local startFollowingSquaredDistance = startFollowingDistance * startFollowingDistance
    local stopFollowingSquaredDistance = stopFollowingDistance * stopFollowingDistance
    return function(selfXY)
        local squaredDistance = XY.of(target):squaredDistanceTo(selfXY)
        if squaredDistance > startFollowingSquaredDistance then return nil end
        if squaredDistance < stopFollowingSquaredDistance then return nil end
        return math.angleOf(math.normalize(XY.of(target) - selfXY))
    end
end
