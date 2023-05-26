local heroFilling = require("res.characters.hero_filling")

require "src.scene.tactics.resources"
require "src.scene.tactics.attack"
require "src.scene.tactics.base.attackable"
require "src.common.util.iter"

-- FIXME? Hero is a God Object or will become one soon, should I deal with it?

--- @class Hero : Attackable, HealthProvider
--- @field _health number
--- @field view
--- @field tags string[]
--- @field sceneView
--- @field movementDirection number
--- @field isMoving boolean
--- @field collisionListeners Iterable<PlayerEventListener>
--- @field healthListeners Iterable<HealthUpdateListener>
--- @field _meleeAttackArea AttackArea
--- @field _meleeAttack Attack
--- @field _lastAttackTimeSeconds number
--- @field _enterFrameData { lastEnteringTime: number }
--- @field _directionalFilling { up: table, down: table, left: table, right: table }
Hero = {}
Hero.__index = Hero

--- Hero:new
--- @param container
--- @param meleeAttackArea AttackArea
--- @param meleeAttack Attack
--- @return Hero
function Hero:new(container, meleeAttackArea, meleeAttack, startPosition)
    local view = self.createView(container, startPosition)
    view.zType = "HasHeight"

    --- @type Hero
    local obj = {
        view = view,
        tags = { playerConfig.tag, Attackable.tag },
        sceneView = container,
        movementDirection = 0,
        collisionListeners = Iterable:new {},
        healthListeners = Iterable:new {},
        _enterFrameData = {
            lastEnteringTime = nil
        },
        _meleeAttackArea = meleeAttackArea,
        _meleeAttack = meleeAttack,
        _health = playerConfig.maxHealth,
        _lastAttackTimeSeconds = system.getTimer() / 1000 - playerConfig.attackIntervalSeconds,
        _directionalFilling = heroFilling.unarmed.idle -- fixme refactor hero state using state machine
    }
    setmetatable(obj, Attackable)
    setmetatable(obj, self)

    view.object = obj
    view.tags = obj.tags
    view.collision = function(_, event) obj:handleCollision(event) end

    view:addEventListener("collision")
    Runtime:addEventListener("enterFrame", obj)
    return obj
end

function Hero:removeSelf()
    self.view:removeEventListener("collision")
    Runtime:removeEventListener("enterFrame", self)
end

--- Hero:createView
--- @param container
function Hero.createView(container, startPosition)
    local view = display.newRect(container,
        startPosition.x, startPosition.y,
        playerConfig.viewSize.width, playerConfig.viewSize.height)
    view.fill = playerConfig.fill
    physics.addBody(view, "dynamic", {
        box = {
            halfWidth = playerConfig.colliderSize.width / 2,
            halfHeight = playerConfig.colliderSize.height / 2
        }
    })
    view.linearDamping = 10
    view.isFixedRotation = true
    view.anchorY = 0.5 + playerConfig.viewSize.height / playerConfig.colliderOffset.y
    return view
end

--- Hero:performAttack
function Hero:performAttack()
    if (self._lastAttackTimeSeconds + playerConfig.attackIntervalSeconds) >= system.getTimer() / 1000 then return end
    self._lastAttackTimeSeconds = system.getTimer() / 1000
    self._meleeAttackArea:spawnForMelee(
        XY.of(self.view) + playerConfig.attackOffset,
        self.movementDirection,
        playerConfig.meleeAttackDurationMillis,
        self._meleeAttack,
        self
    )
    self._directionalFilling = heroFilling.spear.attack
    self:_updateFilling()
    timer.performWithDelay(playerConfig.meleeAttackDurationMillis, function()
        self._directionalFilling = heroFilling.spear.idle
        self:_updateFilling()
    end)
end

--- Hero:equip
--- @field itemName string
function Hero:equip(itemName) -- TODO
    if not table.containsKey(heroFilling, itemName) then return end
    -- fixme bug with the animation state
    self._directionalFilling = heroFilling[itemName].idle -- fixme idle
end

--- Hero:moveInDirection
--- @param degrees number direction in which player will move
function Hero:changeDirection(degrees)
    self.movementDirection = degrees
    self:_updateFilling()
end

function Hero:_updateFilling()
    local filling = self._directionalFilling[directionNameOf(self.movementDirection)]
    self.view.fill = filling
    self.view.anchorX = filling.anchorX
end

--- Hero:move
--- @param x number
--- @param y number
function Hero:move(x, y)
    self.view:translate(x, y)
end

--- Hero:moveInDirection
--- @param degrees number direction in which player will move
--- @param dtSeconds number delta of time between frames
function Hero:moveInDirection(degrees, dtSeconds)
    local xy = math.vectorOf(degrees, playerConfig.speedPerSecond * dtSeconds)
    self:move(xy.x, xy.y)
end

--- Hero:sufferAttack
--- @param attacker Attackable
--- @param attack Attack
function Hero:sufferAttack(attacker, attack)
    if attacker == self then return end
    local oldHealth = self.health
    self._health = self._health - attack.value
    self.healthListeners:onEach(function(listener) listener(self._health, oldHealth, playerConfig.maxHealth) end)
end

--- Hero:enterFrame
---
--- https://docs.coronalabs.com/guide/events/detectEvents/index.html
--- @param event ?
function Hero:enterFrame(event)
    if self.isMoving then
        local deltaTime = (event.time - self._enterFrameData.lastEnteringTime) / 1000
        self:moveInDirection(self.movementDirection, deltaTime)
    end
    self.sceneView.x = display.contentCenterX - self.view.x
    self.sceneView.y = display.contentCenterY - self.view.y
    self._enterFrameData.lastEnteringTime = event.time
end

--- Hero:handleCollision
--- @param event
function Hero:handleCollision(event)
    if not event.phase == "began" then return end
    --- @param listener PlayerEventListener
    self.collisionListeners:onEach(function(listener) listener:triggered(event.other) end)
end

--- Hero:addCollisionListener
--- @param listener PlayerEventListener
function Hero:addCollisionListener(listener)
    table.insert(self.collisionListeners, listener)
end

--- Hero:addHealthListener
--- @param listener HealthUpdateListener
function Hero:addHealthListener(listener)
    table.insert(self.healthListeners, listener)
end

--- @class HealthUpdateListener
--- @field __call fun(self: HealthUpdateListener, newHealth: number, oldHealth: number, maxHealth: number)

--- @class HealthProvider
--- @field healthListeners HealthUpdateListener[]
--- @field addHealthListener fun(self: HealthProvider, listener: HealthUpdateListener)
