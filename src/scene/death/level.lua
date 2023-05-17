local composer = require "composer"
local widget = require "widget"

require "src.scene.death.resources"
require "strings"
require "fonts"

function init(scene)
    local background = display.newRect(scene.view, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    background.fill = backgroundFilling

    local centerGroup = display.newGroup(); scene.view:insert(centerGroup)
    local header = display.newText {
        text = strings.deathScreenHeader,
        x = 0,
        y = -32,
        font = bigTitleFont,
        fontSize = 56
    }
    local continueTryingButton = widget.newButton {
        label = strings.continueTryingButton,
        labelColor = { default = { 1, 1, 1, 1 }, over = { 1, 1, 1, 0.5 } },
        x = 0,
        y = 16,
        font = commonFont,
        fontSize = 16,
        textOnly = true,
        onRelease = function(_)
            composer.gotoScene("src.scene.tactics.scene")
        end
    }
    centerGroup:insert(header)
    centerGroup:insert(continueTryingButton)

    centerGroup.x, centerGroup.y = display.contentCenterX, display.contentCenterY
end

return {
    init = init
}
