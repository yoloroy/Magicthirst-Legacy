local zombieFilling = require("res.characters.zombie_filling")
require "src.scene.tactics.base.attackable"
require "src.scene.tactics.attack"
require "src.scene.tactics.ai_unit"
require "src.scene.tactics.configs"
require "src.scene.tactics.base.container"
require "src.scene.tactics.logic.attack_ai"
require "src.scene.tactics.logic.move_ai"
require "src.scene.tactics.resources"

local ATTACK_DURATION_MILLIS = 200

-- TODO make sensor collider for attackable objects with non sensor collider for view at the bottom for movement
function zombie(gameLayer, physics, xy, target, loot, _attackOverride, _attackRangeOverride) -- FIXME replace target with targetPosProvider
    -- TODO class to handle animations

    local isAttacking = false -- FIXME refactor
    local placementStrategy = randomCircularPlacementStrategy(1)

    local directionalFilling = zombieFilling.unarmed.idle
    local view = display.newRect(gameLayer, xy.x, xy.y, 32, 32)
    view.fill = directionalFilling.down

    local updateView

    physics.addBody(view, "dynamic", {
        box = {
            halfWidth = 7,
            halfHeight = 4
        }
    })
    view.linearDamping = 20
    view.isFixedRotation = true
    view.anchorY = 0.5 + 12 / 32

    local attackArea = AttackArea:new(
        Size:new(16, _attackRangeOverride or 16),
        function(size, xy, _)
            local rect = display.newRect(gameLayer, xy.x, xy.y, size.width, size.height)
            rect.fill = { 0, 0, 0, 0 }
            return rect
        end,
        physics
    )

    --- @type AIUnit
    local unit
    unit = AIUnit:new(
        view,
        20,
        {
            AttackAI:new(
                view,
                _attackRangeOverride or 16,
                1000,
                1,
                gameLayer,
                { playerConfig.tag },
                function(inDirectionOf)
                    local direction = math.angleOf(math.normalize(inDirectionOf - XY.of(view)))
                    directionalFilling = zombieFilling.unarmed.attack
                    isAttacking = true
                    updateView(direction)
                    attackArea:spawnForMelee(XY.of(view), direction, ATTACK_DURATION_MILLIS, _attackOverride or Attack:new(4), unit)
                    timer.performWithDelay(ATTACK_DURATION_MILLIS, function()
                        directionalFilling = zombieFilling.unarmed.idle
                        isAttacking = false
                        updateView(direction)
                    end)
                end
            )
        },
        function(unit) return MoveAI:new(unit, directionThroughWallsProvider(target, 200, 10)) end,
        50,
        { Attackable.tag }
    )

    -- FIXME refactor using observer pattern
    table.insert(unit.tags, baseTags.container)
    function unit:sufferAttack(attacker, attack)
        self._health = self._health - attack.value
        if self._health <= 0 then
            local positions = placementStrategy(#loot)
            for i, item in ipairs(loot) do
                item.viewCreator(item.item, self.view.parent, positions[i] + self.view)
            end
            self:removeSelf()
        end
    end

    unit.direction:observe(function()
        if isAttacking then return end
        updateView()
    end)

    updateView = function(direction) -- direction for view can be specified if needed
        local anyDirection = direction or unit.direction:get()
        if view.parent == nil then return end
        if anyDirection == nil then return end
        view.fill = directionalFilling[directionNameOf(anyDirection)]
    end

    return unit
end
