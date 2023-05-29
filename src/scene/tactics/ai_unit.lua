local gameplayRuntime = require "src.scene.tactics.gameplay_runtime"

require "src.scene.tactics.util.math_ext"
require "src.scene.tactics.attack"
require "src.common.util.structs"
require "src.common.util.iter"
require "src.common.util.observable"

--- @class AIUnit : Attackable, Controllable
--- * Unit is the one who receive attacks/other events and shows them on view, transfers them to ais if required
--- * AIs are provided to unit
--- * Unit shall be like Hero
--- @field view AttackableView
--- @field direction Observable<number>
--- @field _speed number
--- @field _maxHealth number
--- @field _health number
--- @field _attackAIs Iterable<AttackAI>
--- @field _moveAI MoveAI
--- @field _enterFrameData { lastEnteringTime: number }
--- @field _removed boolean
AIUnit = {}
AIUnit.__index = AIUnit

--- AIUnit:new
--- @param view
--- @param speed number
--- @param attackAIs AttackAI
--- @param moveAIProvider fun(controllable: Controllable): MoveAI
--- @param maxHealth number
--- @param tags string[]
function AIUnit:new(view, speed, attackAIs, moveAIProvider, maxHealth, tags)
    --- @type AIUnit
    local obj = {
        view = view,
        tags = tags,
        direction = Observable:new(),
        _attackAIs = Iterable:new(attackAIs),
        _speed = speed,
        _enterFrameData = {
            lastEnteringTime = nil
        },
        _health = maxHealth,
        _removed = false
    }
    obj._moveAI = moveAIProvider(obj)
    view.tags = tags
    view.object = obj
    view.zType = "HasHeight"
    setmetatable(obj, Attackable)
    setmetatable(obj, self)

    gameplayRuntime:addEnterFrameListener(obj)

    local directionObserverFunc = function(direction)
        if direction == nil then return end
        if obj.view.setLinearVelocity == nil then
            obj.direction:stopObserving(directionObserverFunc)
            return
        end
        local dxy = math.vectorOf(direction, obj._speed)
        obj.view:setLinearVelocity(dxy.x, dxy.y)
    end
    obj.direction:observe(directionObserverFunc)

    return obj
end

function AIUnit:removeSelf()
    if self.view == nil then return end
    self.view:removeSelf()
    self.view = nil
    gameplayRuntime:removeEnterFrameListener(self)
end

--- AIUnit:sufferAttack
--- @param _ AttackableView
--- @param attack Attack
function AIUnit:sufferAttack(_, attack)
    self._health = self._health - attack.value
    if self._health <= 0 then
        self:removeSelf()
    end
    for _, deathListener in ipairs(self.deathListeners) do
        deathListener()
    end
end

--- AIUnit:provideXY
--- @return XYProvider
function AIUnit:provideXY()
    --- @type XYProvider
    local provider = self.view
    return provider
end

--- AIUnit:enterFrame
---
--- https://docs.coronalabs.com/guide/events/detectEvents/index.html
--- @param event ?
function AIUnit:enterFrame(event)
    if self.view == nil then return end
    self._moveAI:updateDirection()
    self._attackAIs:onEach(AttackAI.tryAttack)
    self._enterFrameData.lastEnteringTime = event.time
end
