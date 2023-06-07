require "src.common.util.array"
require "src.common.util.iter"
require "src.scene.tactics.configs"

wallTag = "Wall"

--- wall
--- @param layer
--- @param physics
--- @param colliderStartXY XY
--- @param colliderEndXY XY
--- @param height number
--- @param fill
--- @param alpha string TODO description
--- @return { producedViews: any[] }
function wall(layer, physics, colliderStartXY, colliderEndXY, height, fill, alpha)
    local colliderSize, colliderCenterXY = XY.sizeAndCenterOf(colliderStartXY, colliderEndXY)
    local viewSize = colliderSize + Size:new(0, height)

    local foundation
    if not isTest then
        foundation = display.newRect(layer, colliderCenterXY.x, colliderStartXY.y, colliderSize:unpack())
        foundation.fill = fill
        if fill.tileWidth ~= nil and fill.tileHeight ~= nil then
            foundation.fill.scaleX = fill.tileWidth / foundation.width
            foundation.fill.scaleY = fill.tileHeight / foundation.height
        end
        foundation.anchorY = 0
        physics.addBody(foundation, "static")
    end
    local frontView = display.newRect(layer, colliderCenterXY.x, colliderEndXY.y, viewSize:unpack())
    frontView.fill = fill
    if fill.tileWidth ~= nil and fill.tileHeight ~= nil then
        frontView.fill.scaleX = fill.tileWidth / frontView.width
        frontView.fill.scaleY = fill.tileHeight / frontView.height
    end
    frontView.alpha = 1
    frontView.anchorY = 1
    frontView.zType = "HasHeight"
    frontView.tags = { wallTag }
    physics.addBody(frontView, "static", { isSensor = true })

    local blockedObjects = {}
    frontView.collision = function(_, event)
        if not event.other.zType == "HasHeight" or event.other.tags == nil or table.contains(event.other.tags, "Wall") then return end
        if event.phase == "began" then
            table.insert(blockedObjects, event.other)
        else
            table.removeValue(blockedObjects, event.other)
        end
        blockedObjects = Iterable.filter(blockedObjects, function(o) return o.parent ~= nil end)
        frontView.alpha = (#blockedObjects > 0) and alpha or 1
    end
    frontView:addEventListener("collision")

    return {
        producedViews = isTest and { frontView } or { frontView, foundation }
    }
end
