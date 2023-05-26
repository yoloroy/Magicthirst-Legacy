require "src.common.util.structs"
require "src.common.util.iter"
require "src.scene.tactics.configs"
require "src.scene.tactics.base.attackable"

--- @class ContainerItem Item that can be displayed in menu or be thrown on the floor
--- @generic V
--- @field item V
--- @field viewCreator fun(item: V, group: any, xy: XY): any
ContainerItem = {}

--- @class Container : Attackable
--- @field tags table<string>
--- @field view any
--- @field items ContainerItem[]
--- @field _placementStrategy fun(itemsCount: number, placementSpacing: number): XY[]
--- @field _placementSpacing number
Container = {}
Container.__index = Container

--- Container:new
--- @param view any
--- @param items ContainerItem[]
--- @param placementStrategy (fun(itemsCount: number, placementSpacing: number): XY[])?
--- @param placementSpacing number
--- @return Container
function Container:new(view, items, placementSpacing, placementStrategy)
    if placementStrategy == nil then placementStrategy = quadGridPlacementStrategy end
    ---@type Container
    local obj = {
        view = view,
        tags = { baseTags.container, Attackable.tag },
        items = items,
        _placementStrategy = placementStrategy,
        _placementSpacing = placementSpacing
    }
    view.tags = obj.tags
    setmetatable(obj, self)
    view.object = obj
    return obj
end

--- Container:destroy
---
--- destroys container by removing view and placing contained items according to _placementStrategy
function Container:destroy()
    local positions = self._placementStrategy(#(self.items), self._placementSpacing)
    for i, item in ipairs(self.items) do
        item.viewCreator(item.item, self.view.parent, positions[i] + self.view)
    end
    self.view:removeSelf()
    self.view = nil
end

--- Container:sufferAttack
--- @param _ AttackableView
--- @param _ Attack
function Container:sufferAttack(_, _)
    self:destroy()
end

--- Container.Item:new
--- @generic V
--- @param item V
--- @param viewCreator fun(item: V, group: any, xy: XY): any
--- @return ContainerItem
function ContainerItem:new(item, viewCreator)
    ---@type ContainerItem
    local obj = {
        item = item,
        viewCreator = viewCreator
    }
    return obj
end

--- quadGridPlacementStrategy
--- @param itemsCount number
--- @param placementSpacing number
--- @return XY[]
function quadGridPlacementStrategy(itemsCount, placementSpacing)
    local sideCount = math.ceil(math.sqrt(itemsCount))
    local halfSideLength = placementSpacing * sideCount / 2
    ---@type XY[]
    local positions = {}
    for y = 0, sideCount - 1 do
        for x = 0, sideCount - 1 do
            local nextPos = XY:new(x * placementSpacing - halfSideLength, y * placementSpacing - halfSideLength)
            table.insert(positions, nextPos)
        end
    end
    return positions
end

--- randomCircularPlacementStrategy
--- @param maxDelta number
--- @return fun(itemsCount: number, placementSpacing: number): XY[]
function randomCircularPlacementStrategy(maxDelta)
    --- @param itemsCount number
    --- @param _ number
    --- @return XY[]
    return function(itemsCount, _)
        ---@type XY[]
        local positions = {}
        for _ = 0, itemsCount do
            table.insert(positions, math.vectorOf(math.random() * 360, math.random() * maxDelta))
        end
        return positions
    end
end
