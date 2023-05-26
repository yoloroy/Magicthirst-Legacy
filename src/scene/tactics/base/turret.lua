require "src.common.util.structs"
require "src.scene.tactics.util.math_ext"
require "src.scene.tactics.attack"

--- @class Turret
--- @field _calculateShootAngleFor fun(selfXY: XY, target: Target): number
--- @field _newProjectileView fun(): any
--- @field _physics
--- @field _attackArea AttackArea
--- @field _pushing boolean stores is bullet pushes view that it will met
Turret = {}
Turret.__index = Turret

--- Turret:new
--- @param projectileProducer fun(): any
--- @param shootingAngleCalculator fun(selfXY: XY, target: Target): number
--- @param physics
--- @param attackArea AttackArea
--- @param pushing boolean
function Turret:new(projectileProducer, shootingAngleCalculator, physics, attackArea, pushing)
    --- @type Turret
    local obj = {
        _calculateShootAngleFor = shootingAngleCalculator or calculateShootAngleWithoutCalculations,
        _newProjectileView = projectileProducer,
        _physics = physics,
        _attackArea = attackArea,
        _pushing = pushing or false
    }
    setmetatable(obj, Turret)
    return obj
end

--- Turret:shoot
--- @param xy XY coordinates of from where shot will be coming
--- @param attacker Attackable who has ordered a shot
--- @param attack Attack
--- @param target Target
--- @param hitDurationMillis number
--- @param speed number
--- @param maxAffectedObjectsCount number
function Turret:shoot(xy, attacker, attack, target, hitDurationMillis, speed, maxAffectedObjectsCount)
    local shootAngle = self._calculateShootAngleFor(xy, target)
    local projectile = self._newProjectileView()
    projectile.x = xy.x
    projectile.y = xy.y
    projectile.rotation = shootAngle + 90
    self._physics.addBody(projectile, "dynamic")
    projectile.isBullet = true
    ---@type table
    local velocity = math.vectorOf(shootAngle, speed)
    projectile:setLinearVelocity(velocity.x, velocity.y)
    projectile.preCollision = function(_, event)
        event.contact.isEnabled = self._pushing
        local xy = XY.of(event.other)
        local rotation = projectile.rotation
        timer.performWithDelay(50, function()
            self._attackArea:spawn(xy, rotation, hitDurationMillis, attack, attacker, maxAffectedObjectsCount)
        end) -- can be replaced with pull of objects that must be created after collision events
        if not self._pushing then projectile:removeSelf() end
    end
    projectile.tags = { Attackable.tag }
    projectile.object = { view = projectile }
    projectile:addEventListener("preCollision")
    if self._pushing then
        projectile.collision = function(_, _) projectile:removeSelf() end
        projectile:addEventListener("collision")
    end
end

--- @class Target
--- @field x number
--- @field y number
--- @field velocity number nillable
--- @field direction number nillable

--- calculateDestinationWithoutCalculations
--- @param selfXY XY
--- @param target Target
--- @return number
function calculateShootAngleWithoutCalculations(selfXY, target)
    return math.angleOf(math.normalize(target - selfXY))
end

function calculateShootAngleWithPrediction(selfX, selfY, targetX, targetY, targetVelocity, targetDirectionAngle, bulletSpeed)
    -- Вычисляем расстояние до цели
    local distance = math.sqrt((targetY - selfY)^2 + (targetX - selfX)^2)

    -- Вычисляем угол между целью и наблюдателем
    local targetAngle = math.atan2((targetY - selfY), (targetX - selfX))

    -- Вычисляем угол между направлением движения цели и её направлением на наблюдателя
    local relativeAngle = targetAngle - targetDirectionAngle

    -- Прогнозируем перемещение цели с учётом её текущей скорости и направления
    local predictedX = targetX + math.cos(targetDirectionAngle) * targetVelocity
    local predictedY = targetY + math.sin(targetDirectionAngle) * targetVelocity

    -- Вычисляем расстояние до прогнозируемой позиции
    local predictedDistance = math.sqrt((predictedY - selfY)^2 + (predictedX - selfX)^2)

    -- Вычисляем время полёта снаряда до цели и до прогнозируемой позиции цели
    local timeToTarget = distance / bulletSpeed
    local timeToPredictedTarget = predictedDistance / bulletSpeed

    -- Если прогнозируемое перемещение цели находится ближе к наблюдателю, чем её текущее положение,
    -- то используем прогнозируемую позицию, иначе - текущую
    local interceptX, interceptY
    if predictedDistance < distance then
        interceptX, interceptY = predictedX, predictedY
    else
        interceptX, interceptY = targetX, targetY
    end

    -- Вычисляем угол между наблюдателем и точкой перехвата
    local interceptAngle = math.atan2((interceptY - selfY), (interceptX - selfX))

    -- Вычисляем требуемый угол наклона снаряда
    local shootAngle = interceptAngle - targetAngle

    return shootAngle
end

