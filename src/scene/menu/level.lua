local composer = require "composer"
local widget = require "widget"

require "strings"
require "fonts"

function init(scene)
    local background = display.newRect(scene.view, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    background.fill = backgroundFilling

    local centerGroup = display.newGroup(); scene.view:insert(centerGroup)
    local header = display.newText {
        text = strings.gameName,
        x = 0,
        y = -64,
        font = bigTitleFont,
        fontSize = 42
    }
    local testLevel1Button = widget.newButton {
        label = strings.testLevel1,
        labelColor = { default = { 1, 1, 1, 1 }, over = { 1, 1, 1, 0.5 } },
        x = 0,
        y = 4,
        font = commonFont,
        fontSize = 14,
        textOnly = true,
        onRelease = function(_)
            composer.setVariable(CURRENT_LEVEL_PARAMETER, "res.premade_levels.zombies")
            composer.gotoScene("src.scene.tactics.scene")
        end
    }
    local testLevel2Button = widget.newButton {
        label = strings.testLevel2,
        labelColor = { default = { 1, 1, 1, 1 }, over = { 1, 1, 1, 0.5 } },
        x = 0,
        y = 34,
        font = commonFont,
        fontSize = 14,
        textOnly = true,
        onRelease = function(_)
            composer.setVariable(CURRENT_LEVEL_PARAMETER, "res.premade_levels.arena")
            composer.gotoScene("src.scene.tactics.scene")
        end
    }
    local testLevel3Button = widget.newButton {
        label = strings.testLevel3,
        labelColor = { default = { 1, 1, 1, 1 }, over = { 1, 1, 1, 0.5 } },
        x = 0,
        y = 64,
        font = commonFont,
        fontSize = 14,
        textOnly = true,
        onRelease = function(_)
            composer.setVariable(CURRENT_LEVEL_PARAMETER, "res.premade_levels.quake3_intro")
            composer.gotoScene("src.scene.tactics.scene")
        end
    }
    local exitButton = widget.newButton {
        label = strings.exit,
        labelColor = { default = { 1, 1, 1, 1 }, over = { 1, 1, 1, 0.5 } },
        x = 0,
        y = 112,
        font = commonFont,
        fontSize = 14,
        textOnly = true,
        onRelease = function(_) os.exit(0) end
    }

    centerGroup:insert(header)
    centerGroup:insert(testLevel1Button)
    centerGroup:insert(testLevel2Button)
    centerGroup:insert(testLevel3Button)
    centerGroup:insert(exitButton)

    centerGroup.x, centerGroup.y = display.contentCenterX, display.contentCenterY
end

return {
    init = init
}
