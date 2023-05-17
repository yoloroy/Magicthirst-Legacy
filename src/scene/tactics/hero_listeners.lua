--- @class PlayerEventListener
--- @field player Hero
--- @field triggered fun(self: PlayerEventListener, otherView)
PlayerEventListener = {}
PlayerEventListener.__index = PlayerEventListener

--- @class PlayerSteppedOnFoodListener : PlayerEventListener
--- @field player Hero
--- @field _foodTag string
--- @field _inventory Inventory
--- @field _accumulator { unspentLevel: number }
--- @field _levelUpMenu LevelUpMenu
PlayerSteppedOnFoodListener = {}
PlayerSteppedOnFoodListener.__index = PlayerSteppedOnFoodListener
setmetatable(PlayerSteppedOnFoodListener, PlayerEventListener)

--- PlayerSteppedOnFoodListener constructor
--- @param player Hero
--- @param foodTag string
--- @param inventory Inventory
--- @param accumulator { unspentLevel: number }
--- @param levelUpMenu LevelUpMenu
function PlayerSteppedOnFoodListener:new(player, foodTag, inventory, accumulator, levelUpMenu)
    --- @type PlayerSteppedOnFoodListener
    local obj = {
        player = player,
        _foodTag = foodTag,
        _inventory = inventory,
        _accumulator = accumulator,
        _levelUpMenu = levelUpMenu
    }
    setmetatable(obj, self)
    return obj
end

--- event handler
--- @param foodView
function PlayerSteppedOnFoodListener:triggered(foodView)
    if foodView.tag ~= self._foodTag then return end
    self._inventory:insert { -- TODO
        name = "food",
        tag = self._foodTag,
        use = function()
            self._accumulator.unspentLevels = self._accumulator.unspentLevels + 1
            self._accumulator:updateScore() -- TODO refactor
            --self._levelUpMenu:show()
            return true
        end
    } -- TODO food item
    foodView:removeSelf()
end
