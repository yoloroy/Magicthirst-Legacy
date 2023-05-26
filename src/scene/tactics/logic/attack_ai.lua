require "src.common.util.iter"
require "src.common.util.structs"
require "src.scene.common.iter_of_group"
require "src.scene.tactics.base.attackable"
require "src.scene.tactics.attack"

--- @class AttackAI
--- @field _attackerView AttackableView
--- @field _maxDistance number
--- @field _cooldownMillis number
--- @field _maxAffectedObjectsCount number
--- @field _lastHitTime number
--- @field _gameLayer
--- @field _tagsToAttack string[]
--- @field _performAttack fun(inDirectionOf: XY)
AttackAI = {}
AttackAI.__index = AttackAI

--- AttackAI:new
--- @param attackerView AttackableView
--- @param maxDistance number
--- @param cooldownMillis number
--- @param maxAffectedObjectsCount number
--- @param gameLayer
--- @param tagsToAttack string[]
--- @param performAttack fun(inDirectionOf: XY)
function AttackAI:new(attackerView, maxDistance, cooldownMillis, maxAffectedObjectsCount, gameLayer, tagsToAttack, performAttack)
    --- @type AttackAI
    local obj = {
        _attackerView = attackerView,
        _maxDistance = maxDistance,
        _cooldownMillis = cooldownMillis,
        _maxAffectedObjectsCount = maxAffectedObjectsCount,
        _lastHitTime = system.getTimer() - cooldownMillis,
        _gameLayer = gameLayer,
        _tagsToAttack = tagsToAttack,
        _performAttack = performAttack
    }
    setmetatable(obj, self)
    return obj
end

--- AttackAI:tryAttack
--- @return boolean is attack has been performed
function AttackAI:tryAttack()
    local currentTime = system.getTimer()
    if self._lastHitTime + self._cooldownMillis > currentTime then return false end

    local attackerXY = XY.of(self._attackerView)
    local maxDistance2 = self._maxDistance * self._maxDistance
    local affectedObjectsCount = #Iterable.ofChildren(self._gameLayer)
        :filter(function(o) return o.tags ~= nil and table.contains(o.tags, Attackable.tag) end)
        :filter(function(o) return table.isIntersects(o.tags, self._tagsToAttack) end)
        :filter(function(o) return XY.of(o):squaredDistanceTo(attackerXY) <= maxDistance2 end)
        :sortBy(function(o) return XY.of(o):squaredDistanceTo(attackerXY) end) -- NOTE: there is a possibility to optimize, do it if necessary
        :limit(self._maxAffectedObjectsCount)
        :onEach(function(o) self._performAttack(XY.of(o)) end)

    if affectedObjectsCount == 0 then return false end
    self._lastHitTime = currentTime
    return true
end
