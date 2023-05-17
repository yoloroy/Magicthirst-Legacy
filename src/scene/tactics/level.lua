local composer = require "composer"

require "src.common.util.iter"
require "src.common.util.array"
require "src.common.util.display"
require "src.scene.tactics.util.math_ext"
require "src.scene.tactics.hero_listeners"
require "src.scene.tactics.configs"
require "src.scene.tactics.hero"
require "src.scene.tactics.chest"
require "src.scene.tactics.attack"
require "src.scene.tactics.resources"
require "src.scene.tactics.ui.inventory"
require "src.scene.tactics.logic.inventory"
require "src.scene.tactics.ui.choice_menu"
require "src.scene.tactics.ui.health_bar"
require "src.scene.tactics.effects.distance_sort"
require "src.scene.tactics.effects.shadowing"
require "src.scene.tactics.units.skeleton"
require "src.scene.tactics.units.spitting_brazier"
require "src.scene.tactics.obstacles.wall"
require "src.scene.tactics.special_objects.teleporter"
require "fonts"

local physics = require "physics"
physics.start()
physics.setGravity(0, 0)

--region test food
--- @class Food
--- @field view
-- --- @field reward number

Food = {}
Food.__index = Food

function Food:new(container)
    local position = XY.randomInRange(levelConfig.size:toXY())
    local view = display.newCircle(container, position.x, position.y, foodConfig.radius)
    physics.addBody(view, "static", { isSensor = true })
    view.fill = foodConfig.fill
    view.tag = foodConfig.tag
    local obj = { view = view, tag = foodConfig.tag }
    setmetatable(obj, self)
    return obj
end

local function foodView(_, group, xy)
    local foodView = display.newCircle(group, xy.x, xy.y, foodConfig.radius)
    timer.performWithDelay(50, function()
        if foodView == nil then return end
        physics.addBody(foodView, "dynamic")
    end) -- TODO search more on this https://stackoverflow.com/questions/54293622/lua-corona-sdk-physics-addbody
    foodView.fill = foodConfig.fill
    foodView.tag = foodConfig.tag
    local obj = { view = foodView, tag = foodConfig.tag }
    setmetatable(obj, Food)
    return view
end
--endregion

local function init(scene, levelData)
    local objectsToRemove = {}
    local shadowing = Shadowing:new({}, 1, levelData.roomsGraph, { levelData.startLocation })
    local levelsAccumulator = { unspentLevels = 0 }

    local gameLayer = display.newGroup()
    local uiLayer = display.newGroup()
    scene.view:insert(gameLayer)
    scene.view:insert(uiLayer)
    table.insert(objectsToRemove, gameLayer)
    table.insert(objectsToRemove, uiLayer)

    local score = display.newText {
        text = levelsAccumulator.unspentLevels,
        x = 20, y = 30,
        font = commonFont,
        fontSize = 16
    }
    Runtime:addEventListener("resize", function()
        score.x, score.y = (display.viewableContentStartXY() + XY:new(20, 30)):unpack()
    end)
    uiLayer:insert(score)
    levelsAccumulator.updateScore = function(_)
        score.text = levelsAccumulator.unspentLevels
    end

    local inventory = Inventory:new()
    local inventoryUISize = Size:new(math.roundUpToDivisor(display.viewableContentWidth * 2 / 5, 32), display.viewableContentHeight)
    local inventoryUIXY = XY:new(display.viewableContentWidth - inventoryUISize.width / 2, display.contentCenterY)
    local inventoryUI = InventoryUI:new(inventoryUISize, inventoryUIXY, uiLayer, inventory)

    local playerMeleeAttackArea = AttackArea:new(
        Size:new(40, 40), -- height is length here
        function(size, xy, rotation)
            local view = display.newRect(gameLayer, xy.x, xy.y, size.width, size.height)
            view.fill = playerMeleeAttackAreaFilling
            view.rotation = rotation
            view.zType = "OnTop"
            return view
        end,
        physics
    )
    local hero = Hero:new(gameLayer, playerMeleeAttackArea, Attack:new(5), levelData.startPosition)
    table.insert(objectsToRemove, hero)
    hero:addHealthListener(function(newHealth, _, _) if newHealth <= 0 then composer.gotoScene("src.scene.death.scene") end end)
    hero:addCollisionListener(PlayerSteppedOnFoodListener:new(hero, foodConfig.tag, inventory, levelsAccumulator, levelUpMenu)) -- TODO replace food with any item

    --region level init
    for _, wallCharacteristics in ipairs(levelData.walls) do
        local startXY = XY.of(wallCharacteristics.startXY)
        local endXY = XY.of(wallCharacteristics.endXY)
        local fill = wallCharacteristics.fill
        local wallData = wall(gameLayer, physics, startXY, endXY, levelConfig.wallHeight, fill, levelConfig.wallAlpha)

        local viewsAndRooms = Iterable:new(wallCharacteristics.rooms):productWith(wallData.producedViews)
        for _, viewAndRoom in ipairs(viewsAndRooms) do
            shadowing:registerView(viewAndRoom[1], viewAndRoom[2])
        end
    end
    for id, floorCharacteristics in pairs(levelData.floors) do
        local center = floorCharacteristics.center
        local size = floorCharacteristics.size
        local fill = floorCharacteristics.fill
        local floor = display.newRect(gameLayer, center.x, center.y, size.width, size.height)
        floor.fill = fill
        physics.addBody(floor, "static", { isSensor = true })
        shadowing:registerView(id, floor)
        floor:addEventListener("collision", shadowing:collisionListenerForRegion(id))
    end
    for _, enemy in ipairs(levelData.enemies) do
        local position = XY.of(enemy.position)
        --- @type Attackable
        local obj
        if enemy.type == "skeleton" then
            local loot = Iterable:new(enemy.loot)
                :filter(function(type) return type == "food" end) -- FIXME
                :map(function(_) return ContainerItem:new(nil, foodView) end)
            obj = skeleton(gameLayer, physics, position, hero.view, loot)
        elseif enemy.type == "spitting_brazier" then
            obj = spittingBrazier(gameLayer, physics, position, hero.view)
        else
            error("Unknown enemy type")
        end
        table.insert(objectsToRemove, obj)
    end
    for _, chest in ipairs(levelData.chests) do
        local position = XY.of(chest.position)
        local loot = Iterable:new(chest.loot)
            :filter(function(type) return type == "food" end) -- TODO
            :map(function(_) return ContainerItem:new(nil, foodView) end)
        Chest:new(gameLayer, position, loot, physics)
    end
    for _, specialObject in ipairs(levelData.specialObjects) do
        local position = XY.of(specialObject.position)
        local exitXY = XY.of(specialObject.exitXY)
        teleporter(position, exitXY, physics, gameLayer)
    end
    --endregion

    HealthBarUI:new(uiLayer, hero):show()
    shadowing:onPlayerUpdateLocations { levelData.startLocation }

    local distanceSorter = {
        enterFrame = function(_, _) distanceSort(gameLayer) end,
        removeSelf = function(self) Runtime:removeEventListener("enterFrame", self) end
    }
    Runtime:addEventListener("enterFrame", distanceSorter)
    table.insert(objectsToRemove, distanceSorter)

    return {
        allToRemove = Iterable:new(objectsToRemove),
        player = hero,
        inventoryUI = inventoryUI
    }
end

return {
    init = init
}
