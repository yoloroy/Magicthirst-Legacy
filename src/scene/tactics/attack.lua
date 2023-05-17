require "src.common.util.structs"

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
    local view = self.viewFactory(self.size, xy, rotation)
    self._physics.addBody(view, "dynamic", { isSensor = true })
    view.isHitTestable = true
    local hitObjectsCount = 0
    view.collision = function(_, event)
        local otherView = event.other
        if
            maxAffectedObjectsCount ~= nil and hitObjectsCount > maxAffectedObjectsCount or
            otherView.tags == nil or
            otherView.tags == attacker.tags or
            not table.contains(otherView.tags, Attackable.tag)
        then
            return
        end
        otherView.object:sufferAttack(attacker, attack)
        hitObjectsCount = hitObjectsCount + 1
    end
    view:addEventListener("collision")
    timer.performWithDelay(durationMillis, function() if view.removeSelf ~= nil then view:removeSelf() end end)
end

--- AttackArea:spawnForMelee
--- @param xy XY
--- @param direction number
--- @param durationMillis number
--- @param attack Attack
--- @param attacker Attackable
--- @param maxAffectedObjectsCount number nillable
function AttackArea:spawnForMelee(xy, direction, durationMillis, attack, attacker, maxAffectedObjectsCount)
    local directionalDelta = self.size:toXY() * math.vectorOf(direction, 0.5) * XY:new(1, 1)
    local rotation = direction + 90
    self:spawn(xy + directionalDelta, rotation, durationMillis, attack, attacker, maxAffectedObjectsCount)
end

--- @class Attackable
--- @field tags table<string>
--- @field view AttackableView
Attackable = {
    tag = "Attackable"
}
Attackable.__index = Attackable

--- Attackable:sufferAttack
--- @param attacker Attackable
--- @param attack Attack
function Attackable:sufferAttack(attacker, attack)
    error("TODO: implement")
end

function Attackable:addDeathListener(listener)
    if self.deathListeners == nil then
        self.deathListeners = {}
    end
    table.insert(deathListeners, listener)
end

--- @class AttackableView
--- @field object Attackable
