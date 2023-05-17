require "src.common.util.structs"
require "src.common.ui.columns"
require "src.common.util.iter"
require "src.common.event.builder"

require "fonts"

LevelUpMenuConfig = {
    size = Size:new(display.contentWidth / 2, display.contentHeight / 2),
    fill = { 1, 1, 1, 0.3 }
}

--- @class LevelUpMenu
--- @field options Iterable<LevelUpOption>
--- @field _container
--- @field _view
--- @field _accumulator { unspentLevels: number }
LevelUpMenu = {}
LevelUpMenu.__index = LevelUpMenu

--- @class LevelUpOption
--- @field name string
--- @field onClickListener "function(event)"

--- # [LevelUpMenu]:new
--- @param options LevelUpOption[]
--- @param container
--- @param accumulator { unspentLevels: number }
--- @return LevelUpMenu
function LevelUpMenu:new(options, container, accumulator)
    --- @type LevelUpMenu
    obj = {
        options = Iterable:new(options),
        _container = container,
        _view = nil,
        _accumulator = accumulator
    }
    setmetatable(obj, self)
    return obj
end

function LevelUpMenu:show()
    if self._view ~= nil then return end

    local size = LevelUpMenuConfig.size
    local positionTopLeft = XY:new(display.contentCenterX - size.width / 2, display.contentCenterY - size.height / 2)

    local background = display.newRect(0, 0, 0, 0)
    background.fill = LevelUpMenuConfig.fill
    local optionViews = self.options:map(function(option)
        local view = display.newText {
            text = option.name,
            width = size.width / #(self.options),
            height = size.height,
            align = "center",
            font = commonFont
        }
        view:addEventListener("touch", eventBuilder.touch.ended(option.onClickListener))
        return view
    end)

    self._view = display.newRow(self._container, positionTopLeft, optionViews, background)
end

function LevelUpMenu:hide()
    if self._accumulator.unspentLevels > 0 then return end
    self._view:removeSelf()
    self._view = nil
end
