require "src.common.util.structs"
require "src.scene.tactics.resources"
require "src.scene.tactics.configs"
require "src.scene.tactics.base.turret"
require "src.scene.tactics.attack"
require "src.scene.tactics.logic.attack_ai"
require "src.scene.tactics.logic.move_ai"
require "src.scene.tactics.ai_unit"

function spittingBrazier(gameLayer, physics, xy, target)
    local testTurretView = display.newRect(gameLayer, xy.x, xy.y, 32, 32)
    testTurretView.fill = testTurretImageFilling
    local testTurret = Turret:new(
        function()
            return display.newRect(gameLayer, 0, 0, 8, 8)
        end,
        null,
        physics,
        AttackArea:new(
            Size:new(16, 16),
            function(size, xy, _)
                return display.newRect(gameLayer, xy.x, xy.y, size.width, size.height)
            end,
            physics
        ),
        false
    )
    local testTurretAttackAI = AttackAI:new(testTurretView, 300, 800, 1, gameLayer, { playerConfig.tag }, function(inDirection)
        testTurret:shoot(
            XY.of(testTurretView),
            { tags = { Attackable.tag, "TEST_TURRET" } },
            { value = 80 },
            inDirection,
            200,
            200,
            1
        )
    end)

    local testTurretUnit = AIUnit:new(
        testTurretView,
        0,
        { testTurretAttackAI },
        function(controllable) return MoveAI:new(controllable, directionThroughWallsProvider(target, 150, -0)) end,
        10000,
        { Attackable.tag, "TEST_TURRET" }
    )

    return testTurretUnit
end
