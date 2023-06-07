require "src.common.util.structs"

function display.contentCenterXY()
    return XY:new(display.contentCenterX, display.contentCenterY)
end

function display.viewableContentStartXY()
    return XY:new(display.screenOriginX, display.screenOriginY)
end
