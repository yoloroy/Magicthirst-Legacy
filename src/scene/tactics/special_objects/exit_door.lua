function exitDoor(position, filling, area, predicate, exit, inventory, hero, physics, layer)
    local view = display.newRect(layer, position.x, position.y, filling.width, filling.height)
    view.fill = filling
    view.anchorX, view.anchorY = filling.anchor:unpack()
    view.zType = "HasHeight"
    physics.addBody(view, "static", {
        isSensor = true,
        halfWidth = area.width / 2,
        halfHeight = area.height / 2
    })
    view:addEventListener("collision", function(event)
        local other = event.other
        if other.tags == nil or not table.contains(other.tags, playerConfig.tag) then return end
        if predicate.inventory ~= nil and not predicate.inventory(inventory) then return end
        if predicate.hero ~= nil and not predicate.hero(hero) then return end
        timer.performWithDelay(50, exit)
    end)
end
