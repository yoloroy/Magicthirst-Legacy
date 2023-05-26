local heroFilling = require("res.characters.hero_filling")

require "src.scene.tactics.resources"
require "src.scene.tactics.attack"
require "src.scene.tactics.base.attackable"
require "src.scene.tactics.base.action_state_manipulator"
require "src.common.util.iter"

--- @class EquipmentAction Friendly/inner abstract class for the Hero, all children are friendly/inner too
--- @field hero Hero
--- @field name string
--- @field actionName string
--- @field _intervalInSeconds number
--- @field _durationInSeconds number
--- @field _lastActionTimeInSeconds number
local EquipmentAction = {}
EquipmentAction.__index = EquipmentAction

--- @class Hero : Attackable, HealthProvider
--- @field _health number
--- @field view
--- @field tags string[]
--- @field sceneView
--- @field movementDirection number
--- @field isMoving boolean
--- @field collisionListeners Iterable<PlayerEventListener>
--- @field healthListeners Iterable<HealthUpdateListener>
--- @field equipmentName string
--- @field actionName string
--- @field _stateManipulator ActionStateManipulator
--- @field _fillingProvider HeroFillingProvider
--- @field _equipmentAction EquipmentAction
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
function Hero:new(container, startPosition, physics) -- fixme refactor attacks
    EquipmentAction.init(physics, container)

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
        _health = playerConfig.maxHealth,
        _lastAttackTimeSeconds = system.getTimer() / 1000 - playerConfig.attackIntervalSeconds,
        equipmentName = "magicPush",
        actionName = "idle"
    }
    setmetatable(obj, Attackable)
    setmetatable(obj, self)

    obj._equipmentAction = EquipmentAction.byState(obj)
    obj._fillingProvider = HeroFillingProvider:new(obj, heroFilling)
    obj._stateManipulator = ActionStateManipulator:new(obj, {
        idle = {
            possibleTransformations = { "attack", "idle" },
            isPossible = function(_) return true end
        },
        attack = {
            possibleTransformations = { "idle" },
            isPossible = function(_) return true end
        }
    })

    view.object = obj
    view.tags = obj.tags
    view.collision = function(_, event) obj:handleCollision(event) end

    view:addEventListener("collision")
    Runtime:addEventListener("enterFrame", obj)
    return obj
end

--region hero methods
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
    self._equipmentAction:perform()
end

--- Hero:equip
--- @field itemName string
function Hero:equip(itemName) -- TODO
    if not table.containsKey(heroFilling, itemName) then return end
    self.equipmentName = itemName
    self._equipmentAction = EquipmentAction.byState(self)
    self:_updateFilling()
end

--- Hero:moveInDirection
--- @param degrees number direction in which player will move
function Hero:changeDirection(degrees)
    self.movementDirection = degrees
    self:_updateFilling()
end

function Hero:_updateFilling()
    local filling = self._fillingProvider:filling()[directionNameOf(self.movementDirection)]
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
--endregion

--- @class HealthUpdateListener
--- @field __call fun(self: HealthUpdateListener, newHealth: number, oldHealth: number, maxHealth: number)

--- @class HealthProvider
--- @field healthListeners HealthUpdateListener[]
--- @field addHealthListener fun(self: HealthProvider, listener: HealthUpdateListener)

--- @class HeroFillingProvider
--- @field dataProvider { equipmentName: string, actionName: string, direction: string, health: number }
--- @field _fullFilling
HeroFillingProvider = {}
HeroFillingProvider.__index = HeroFillingProvider

--- new
--- @param fullFilling
function HeroFillingProvider:new(dataProvider, fullFilling)
    --- @type HeroFillingProvider
    local obj = { dataProvider = dataProvider, _fullFilling = fullFilling }
    setmetatable(obj, self)
    return obj
end

--- @return { up: table, down: table, left: table, right: table }
function HeroFillingProvider:filling()
    local fillingForEquipment = self._fullFilling[self.dataProvider.equipmentName] or self._fullFilling[self._fullFilling.keyDefault]
    return fillingForEquipment[self.dataProvider.actionName] or fillingForEquipment[fillingForEquipment.keyDefault]
end

--region Hero.EquipmentAction
function EquipmentAction:perform()
    if (self._lastActionTimeInSeconds + self._intervalInSeconds) >= system.getTimer() / 1000 then return end
    if not self.hero._stateManipulator:tryChangeState(self.actionName) then return end
    self._lastActionTimeInSeconds = system.getTimer() / 1000
    self:_action()
    self.hero:_updateFilling()
    timer.performWithDelay(self._durationInSeconds * 1000, function()
        print("time in seconds: "..system.getTimer() / 1000)
        self.hero._stateManipulator:changeStateBack()
        self.hero:_updateFilling()
    end)
end

function EquipmentAction:_action() error("abstract method") end

--- @class SpearAction : EquipmentAction
--- @field _attackArea AttackArea
local SpearAction = {}
setmetatable(SpearAction, EquipmentAction)
SpearAction.__index = SpearAction

function SpearAction:new(hero, physics, gameLayer)
    --- @type SpearAction
    local obj = {
        hero = hero,
        name = "spear",
        actionName = "attack",
        _intervalInSeconds = playerConfig.attackIntervalSeconds,
        _durationInSeconds = playerConfig.meleeAttackDurationMillis / 1000,
        _lastActionTimeInSeconds = system.getTimer() / 1000 - playerConfig.attackIntervalSeconds,
        _attackArea = AttackArea:new(
            Size:new(40, 40), -- height is length here
            function(size, xy, rotation)
                local view = display.newRect(gameLayer, xy.x, xy.y, size.width, size.height)
                view.fill = playerMeleeAttackAreaFilling
                view.rotation = rotation
                view.zType = "OnTop"
                return view
            end,
            physics
        ),
        _attack = Attack:new(5)
    }
    setmetatable(obj, self)
    return obj
end

function SpearAction:_action()
    self._attackArea:spawnForMelee(
        XY.of(self.hero.view) + playerConfig.attackOffset,
        self.hero.movementDirection,
        playerConfig.meleeAttackDurationMillis,
        self._attack,
        self.hero
    )
end

--- @class MagicPushAction : EquipmentAction
local MagicPushAction = {}
setmetatable(MagicPushAction, EquipmentAction)
MagicPushAction.__index = MagicPushAction

function MagicPushAction:new(hero, physics, gameLayer)
    --- @type SpearAction
    local obj = {
        hero = hero,
        name = "magicPush",
        actionName = "attack",
        _intervalInSeconds = playerConfig.attackIntervalSeconds,
        _durationInSeconds = playerConfig.meleeAttackDurationMillis / 1000,
        _lastActionTimeInSeconds = system.getTimer() / 1000 - playerConfig.attackIntervalSeconds,
        _magicPushArea = ActionArea:new(
            Size:new(60, 60), -- height is length here
            function(size, xy, rotation)
                local view = display.newRect(gameLayer, xy.x, xy.y, size.width, size.height)
                view.fill = playerMagicPushAreaFilling
                view.rotation = rotation
                view.zType = "OnTop"
                return view
            end,
            physics,
            function(other)
                if other.view.isBullet then
                    local vx, vy = other.view:getLinearVelocity()
                    local speed = math.sqrt(vx * vx + vy * vy) -- TODO create math extension function for getting speed of vector
                    local vector = math.vectorOf(math.angleOf(math.normalize(XY.of(other.view) - XY.of(hero.view))), speed)
                    other.view:setLinearVelocity(vector.x, vector.y)
                    return
                end
                -- TODO magic push force constant
                local vector = math.vectorOf(math.angleOf(math.normalize(XY.of(other.view) - XY.of(hero.view))), 0.1)
                other.view:applyLinearImpulse(vector.x, vector.y, other.view.x, other.view.y)
            end
        )
    }
    setmetatable(obj, self)
    return obj
end

function MagicPushAction:_action()
    self._magicPushArea:spawnForMelee(
        XY.of(self.hero.view) + playerConfig.attackOffset,
        self.hero.movementDirection,
        playerConfig.meleeAttackDurationMillis,
        self.hero
    )
end

--- Equipment.byTag
--- @param hero Hero
--- @return any
function EquipmentAction.byState(hero)
    local self = EquipmentAction
    if hero.equipmentName == "spear" then
        return SpearAction:new(hero, self.physics, self.gameLayer)
    elseif hero.equipmentName == "magicPush" then
        return MagicPushAction:new(hero, self.physics, self.gameLayer)
    else
        print("Invalid state("..hero.equipmentName..") in hero, default state is magicPush")
        return MagicPushAction:new(hero, self.physics, self.gameLayer)
    end
end

--- Equipment.byTag
--- @param physics
--- @param gameLayer
--- @return any
function EquipmentAction.init(physics, gameLayer)
    EquipmentAction.physics = physics
    EquipmentAction.gameLayer = gameLayer
end
--endregion
