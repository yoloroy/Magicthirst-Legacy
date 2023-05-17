require "src.common.util.structs"

function display.contentCenterXY()
    return XY:new(display.contentCenterX, display.contentCenterY)
end

function display.viewableContentStartXY()
    return XY:new(
        display.contentCenterX - display.viewableContentWidth / 2,
        display.contentCenterY - display.viewableContentHeight / 2
    )
end
