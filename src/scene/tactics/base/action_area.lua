require "src.common.util.structs"
require "src.scene.tactics.base.attackable"

--- @class ActionArea
--- @field size Size
--- @field _physics
--- @field viewFactory fun(size: Size, xy: XY, rotation: number): any
--- @field action fun(action)
ActionArea = {}
ActionArea.__index = ActionArea

--- ActionArea:new
--- @param size Size
--- @param viewFactory fun(size: Size, xy: XY, rotation: number): any
--- @param physics
--- @param action fun(other)
--- @return ActionArea
function ActionArea:new(size, viewFactory, physics, action)
    --- @type ActionArea
    local obj = {
        size = size,
        viewFactory = viewFactory,
        _physics = physics,
        _action = action
    }
    setmetatable(obj, self)
    return obj
end

--- ActionArea:spawn
--- @param xy XY
--- @param rotation number
--- @param durationMillis number
--- @param attacker Attackable
--- @param maxAffectedObjectsCount number nillable
function ActionArea:spawn(xy, rotation, durationMillis, attacker, maxAffectedObjectsCount)
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
        self._action(otherView.object)
        hitObjectsCount = hitObjectsCount + 1
    end
    view:addEventListener("collision")
    timer.performWithDelay(durationMillis, function() if view.removeSelf ~= nil then view:removeSelf() end end)
end

--- ActionArea:spawnForMelee
--- @param xy XY
--- @param direction number
--- @param durationMillis number
--- @param attacker Attackable
--- @param maxAffectedObjectsCount number nillable
function ActionArea:spawnForMelee(xy, direction, durationMillis, attacker, maxAffectedObjectsCount)
    local directionalDelta = self.size:toXY() * math.vectorOf(direction, 0.5) * XY:new(1, 1)
    local rotation = direction + 90
    self:spawn(xy + directionalDelta, rotation, durationMillis, attacker, maxAffectedObjectsCount)
end
