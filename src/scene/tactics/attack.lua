require "src.common.util.structs"
require "src.scene.tactics.base.action_area"
require "src.scene.tactics.base.attackable"

-- TODO damage types: { kinetic, energetic, magical }
--- @class Attack
--- @field value number
Attack = {}
Attack.__index = Attack

--- Attack:new
--- @param value number
--- @return Attack
function Attack:new(value)
    --- @type Attack
    local obj = {
        value= value
    }
    return obj
end

--- @class AttackArea
--- @field size Size
--- @field _physics
--- @field viewFactory fun(size: Size, xy: XY, rotation: number): any
AttackArea = {}
AttackArea.__index = AttackArea

--- AttackArea:new
--- @param size Size
--- @param viewFactory fun(size: Size, xy: XY, rotation: number): any
--- @param physics
--- @return AttackArea
function AttackArea:new(size, viewFactory, physics)
    --- @type AttackArea
    local obj = {
        size = size,
        viewFactory = viewFactory,
        _physics = physics
    }
    setmetatable(obj, self)
    return obj
end

--- AttackArea:spawn
--- @param xy XY
--- @param rotation number
--- @param durationMillis number
--- @param attack Attack
--- @param attacker Attackable
--- @param maxAffectedObjectsCount number nillable
function AttackArea:spawn(xy, rotation, durationMillis, attack, attacker, maxAffectedObjectsCount)
    self:_attackArea(attacker, attack):spawn(xy, rotation, durationMillis, attacker, maxAffectedObjectsCount)
end

--- AttackArea:spawnForMelee
--- @param xy XY
--- @param direction number
--- @param durationMillis number
--- @param attack Attack
--- @param attacker Attackable
--- @param maxAffectedObjectsCount number nillable
function AttackArea:spawnForMelee(xy, direction, durationMillis, attack, attacker, maxAffectedObjectsCount)
    self:_attackArea(attacker, attack):spawnForMelee(xy, direction, durationMillis, attacker, maxAffectedObjectsCount)
end

function AttackArea:_attackArea(attacker, attack)
    return ActionArea:new(self.size, self.viewFactory, self._physics, self:_attackAction(attacker, attack))
end

function AttackArea:_attackAction(attacker, attack)
    return function(other)
        if other.sufferAttack ~= nil then
            other:sufferAttack(attacker, attack)
        else
            print("TODO see more about attacked non-attackable objects")
        end end
end

--- @class AttackableView
--- @field object Attackable
