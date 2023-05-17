require "src.common.util.structs"
require "src.common.util.array"
require "src.scene.tactics.configs"

local FILLING = {
    type = "image",
    filename = "res/img/teleporter.png"
}
local VIEW_SIZE = Size:new(32, 64)
local COLLIDER_SIZE = Size:new(28, 24)

--- teleporter
--- @param xy XY
--- @param exitXY XY
function teleporter(xy, exitXY, physics, layer)
    local view = _teleporterView(xy, layer, physics)
    view:addEventListener("collision", function(event)
        local other = event.other
        if other.tags == nil or not table.contains(other.tags, playerConfig.tag) then return end
        print(table.concat(other.tags, ", "))
        timer.performWithDelay(50, function()
            print(exitXY:toString())
            other.x = exitXY.x
            other.y = exitXY.y
        end)
    end)
    view.zType = "HasHeight"
    return view
end

function _teleporterView(xy, group, physics)
    local view = display.newRect(group, xy.x, xy.y, VIEW_SIZE:unpack())
    view.fill = FILLING
    physics.addBody(view, "static", {
        isSensor = true,
        halfWidth = COLLIDER_SIZE.width,
        halfHeight = COLLIDER_SIZE.height
    })
    view.anchorY = 1
    return view
end
