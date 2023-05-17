require "src.common.util.structs"
require "src.scene.tactics.resources"
local widget = require "widget"

--- @class InventoryUIItem : InventoryItem
--- @field name string
--- @field tag string
--- @field use fun(self: InventoryItem): boolean returns is item shall be removed from inventory after usage

--- @class InventoryUI
--- @field _inventory Inventory
--- @field _inventoryObserver fun(newItems: table<InventoryUIItem>): void
--- @field _layer any
--- @field _group any?
--- @field _itemsGroup any?
--- @field _scrollView any?
--- @field _showingIntervalMillis number
--- @field _lastShowingTimeMillis number
--- @field _size Size
--- @field _xy XY
InventoryUI = {}
InventoryUI.__index = InventoryUI

function InventoryUI:new(size, xy, layer, inventory, showingIntervalMillis)
    --- @type InventoryUI
    local obj = {
        _inventory = inventory,
        _layer = layer,
        _group = nil,
        _itemsGroup = nil,
        _scrollView = nil,
        _showingIntervalMillis = math.max(50, showingIntervalMillis or 50), -- this interval is required for work of scrollView widget
        _lastShowingTimeMillis = 0,
        _size = size,
        _xy = xy
    }
    setmetatable(obj, InventoryUI)
    return obj
end

function InventoryUI:toggle()
    if self._group == nil then
        self:show()
    else
        self:hide()
    end
end

function InventoryUI:show()
    local timeMillis = system.getTimer()
    if (timeMillis - self._lastShowingTimeMillis) < self._showingIntervalMillis then
        self._lastShowingTimeMillis = timeMillis
    end
    if self._group ~= nil then return end
    self._group = display.newGroup()
    self:_initBackground()
    self:_initItems(self._inventory.items)
    self._layer:insert(self._group)
    self._group.x = self._xy.x
    self._group.y = self._xy.y
    self._inventory:observe(function(items)
        -- TODO optimization, example: receiving in callback update type, if type is "insert" than just add another item icon without full recreating items group, maybe create reuse of views like in recyclerView in android
        if self._group == nil then return end
        self:_initItems(items)
    end)
end

function InventoryUI:hide()
    self._inventory:stopObserving(self._inventoryObserver)
    self._group:removeSelf()
    self._group = nil
    self._scrollView = nil
    self._itemsGroup = nil
    self._inventoryObserver = nil
end

function InventoryUI:_initItems(items)
    local size = self._size - Size:new(inventoryItemPlacementOffset, inventoryItemPlacementOffset) * 2
    local start = XY.of(0)

    local columnsCount = size.width / inventoryTileSideSize
    local shownRowsCount = math.floor(self._size.height / inventoryTileSideSize)
    local rowsCount = math.ceil((#items) / columnsCount) + shownRowsCount - 2
    local backgroundSize = Size:new(columnsCount * inventoryTileSideSize, rowsCount * inventoryTileSideSize)

    if self._scrollView == nil then
        self._scrollView = widget.newScrollView {
            x = start.x,
            y = start.y,
            width = size.width,
            height = size.height,
            scrollWidth = backgroundSize.width,
            scrollHeight = backgroundSize.height,
            hideBackground = true,
            listener = scrollListener
        }
    end
    if self._itemsGroup ~= nil then
        self._itemsGroup:removeSelf()
    end
    self._itemsGroup = display.newGroup()

    local background = display.newRect(0, 0, backgroundSize.width, backgroundSize.height)
    self._itemsGroup:insert(background)
    background.x, background.y = backgroundSize.width / 2, backgroundSize.height / 2
    background.fill = inventoryBackgroundItemCell()
    background.fill.x = 0.5 + columnsCount % 2 * 0.5
    background.fill.y = 0.5 + rowsCount % 2 * 0.5
    background.fill.scaleX = inventoryTileSideSize / backgroundSize.width
    background.fill.scaleY = inventoryTileSideSize / backgroundSize.height

    for i, item in ipairs(items) do
        local row = math.floor((i - 1) / columnsCount)
        local x = (i - 1) % columnsCount * inventoryTileSideSize + inventoryTileSideSize / 2
        local y = row * inventoryTileSideSize + inventoryTileSideSize / 2
        local itemView = display.newRect(x, y, inventoryTileSideSize, inventoryTileSideSize)
        self._itemsGroup:insert(itemView)
        itemView.fill = inventoryItemIconForTag(item.tag)
        itemView:addEventListener("tap", function() self._inventory:use(i) end)
    end

    self._scrollView:insert(self._itemsGroup)
    self._group:insert(self._scrollView)
end

function InventoryUI:_initBackground() -- TODO make universal 9 slice loader
    local tiles = inventoryBackgroundTiles()
    local tileSideSize = inventoryTileSideSize
    local halfTileSideSize = tileSideSize / 2
    local group = display.newGroup()

    local centerSize = self._size - Size:new(tileSideSize, tileSideSize) * 2
    local halfCenterSize = centerSize / 2

    local center = display.newRect(group, 0, 0, centerSize.width, centerSize.height)
    center.fill = tiles[2][2]
    center.fill.x = 0.5
    center.fill.scaleX = tileSideSize / centerSize.width
    center.fill.scaleY = tileSideSize / centerSize.height

    --region corners
    local topLeft = display.newRect(
        group,
        -halfCenterSize.width - halfTileSideSize, -halfCenterSize.height - halfTileSideSize,
        tileSideSize, tileSideSize
    )
    topLeft.fill = tiles[1][1]
    local topRight = display.newRect(
        group,
        halfCenterSize.width + halfTileSideSize, -halfCenterSize.height - halfTileSideSize,
        tileSideSize, tileSideSize
    )
    topRight.fill = tiles[1][3]
    local bottomLeft = display.newRect(
        group,
        -halfCenterSize.width - halfTileSideSize, halfCenterSize.height + halfTileSideSize,
        tileSideSize, tileSideSize
    )
    bottomLeft.fill = tiles[3][1]
    local bottomRight = display.newRect(
        group,
        halfCenterSize.width + halfTileSideSize, halfCenterSize.height + halfTileSideSize,
        tileSideSize, tileSideSize
    )
    bottomRight.fill = tiles[3][3]
    --endregion

    --region lines
    local top = display.newRect(group, 0, -halfCenterSize.height - halfTileSideSize, centerSize.width, tileSideSize)
    top.fill = tiles[1][2]
    top.fill.x = 0.5
    top.fill.scaleX = tileSideSize / centerSize.width
    local bottom = display.newRect(group, 0, halfCenterSize.height + halfTileSideSize, centerSize.width, tileSideSize)
    bottom.fill = tiles[3][2]
    bottom.fill.x = 0.5
    bottom.fill.scaleX = tileSideSize / centerSize.width
    local left = display.newRect(group, -halfCenterSize.width - halfTileSideSize, 0, tileSideSize, centerSize.height)
    left.fill = tiles[2][1]
    left.fill.y = 0.5
    left.fill.scaleY = tileSideSize / centerSize.height
    local right = display.newRect(group, halfCenterSize.width + halfTileSideSize, 0, tileSideSize, centerSize.height)
    right.fill = tiles[2][3]
    right.fill.y = 0.5
    right.fill.scaleY = tileSideSize / centerSize.height
    --endregion

    group.x, group.y = 0, 0

    self._group:insert(group)
end
