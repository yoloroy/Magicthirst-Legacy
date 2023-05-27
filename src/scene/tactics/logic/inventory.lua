require "src.common.util.array"
require "src.scene.tactics.configs"

--- @class Inventory
--- @field _onUpdateItems (fun(items: InventoryItem[]): void)[]
--- @field items InventoryItem[]
Inventory = {}
Inventory.__index = Inventory

--- Inventory:new
--- @return Inventory
function Inventory:new()
    --- @type Inventory
    local obj = {
        items = {},
        _onUpdateItems = {}
    }
    setmetatable(obj, Inventory)
    return obj
end

--- Inventory:insert
--- @param item InventoryItem | string
function Inventory:insert(item)
    table.insert(self.items, item)
    self:_notifyItemsObservers()
end

--- Inventory:remove
--- @param i number
function Inventory:remove(i)
    table.remove(self.items, i)
    self:_notifyItemsObservers()
end

--- Inventory:remove
--- @param item InventoryItem
function Inventory:removeItem(item)
    table.removeValue(self.items, item)
    self:_notifyItemsObservers()
end

--- Inventory:update
--- @param newItems InventoryItem[]
function Inventory:update(newItems)
    self.items = newItems
    self:_notifyItemsObservers()
end

--- Inventory:use
--- @param i number
function Inventory:use(i)
    if i > #self.items then return end
    if self.items[i]:use() then
        self:remove(i)
    end
end

--- Inventory:observe
--- @param callback fun(items: InventoryItem[])
function Inventory:observe(callback)
    table.insert(self._onUpdateItems, callback)
    callback(self.items)
end

--- Inventory:stopObserving
--- @param callback fun(items: InventoryItem[])
function Inventory:stopObserving(callback)
    local i = table.indexOf(self._onUpdateItems, callback)
    table.remove(self._onUpdateItems, i)
end

--- Inventory:_notifyItemsObservers
function Inventory:_notifyItemsObservers()
    for _, onUpdateItems in pairs(self._onUpdateItems) do
        onUpdateItems(self.items)
    end
end

--- @class InventoryItem
--- @field name string
--- @field use fun(self: InventoryItem): boolean returns is item shall be removed from inventory after usage
