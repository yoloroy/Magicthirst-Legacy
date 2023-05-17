require "src.common.util.structs"
require "src.common.util.array"
require "src.common.util.display"

HealthBarUIConfig = {
    size = Size:new(156, 8),
    offset = XY:new(10, 10),
    outlineOffset = XY:new(1, 1),
    healthFilling = { 0.7, 0.1, 0.1, 1 },
    backgroundFilling = { 0.2, 0.2, 0.2, 1 }
}
HealthBarUIConfig.groupOffset = (HealthBarUIConfig.size / 2):toXY() + HealthBarUIConfig.offset

--- @class HealthBarUI
--- @field _layer
--- @field _group
--- @field _healthProvider HealthProvider
--- @field _onResize fun()
HealthBarUI = {}
HealthBarUI.__index = HealthBarUI

--- HealthBarUI:new
--- @param layer
--- @param healthProvider HealthProvider
function HealthBarUI:new(layer, healthProvider)
    --- @type HealthBarUI
    local obj = {
        _layer = layer,
        _group = nil,
        _healthProvider = healthProvider,
    }
    setmetatable(obj, self)
    obj._onResize = function() obj:onResize() end
    return obj
end

function HealthBarUI:show()
    local healthSize = HealthBarUIConfig.size - (HealthBarUIConfig.outlineOffset * XY.of(2)):toSize()

    function calculateHealthFillerSize(healthPercent)
        local coerced = (healthPercent <= 0) and 0 or healthPercent
        return healthSize * Size:new(coerced, 1)
    end

    local group = display.newGroup()
    local background = display.newRect(group, 0, 0, HealthBarUIConfig.size:unpack())
    background.fill = HealthBarUIConfig.backgroundFilling

    local healthFiller = display.newRect(group, -healthSize.width / 2, 0, healthSize:unpack())
    healthFiller.anchorX = 0
    healthFiller.fill = HealthBarUIConfig.healthFilling

    self._layer:insert(group)
    group.x, group.y = (HealthBarUIConfig.groupOffset + display.viewableContentStartXY()):unpack()

    self._listener = function(newHealth, _, maxHealth)
        healthFiller.width = calculateHealthFillerSize(newHealth / maxHealth).width
    end
    self._healthProvider:addHealthListener(self._listener)
    Runtime:addEventListener("resize", self._onResize)
    self._group = group
end

function HealthBarUI:hide()
    if self._group == nil then return end
    Runtime:removeEventListener("resize", self._onResize)
    self._group:removeSelf()
    self._group = nil
    table.remove(self._healthProvider.healthListeners, table.indexOf(self._healthProvider.healthListeners, self._listener))
end

function HealthBarUI:onResize()
    if self._group == nil then return end
    self._group.x, self._group.y = (HealthBarUIConfig.groupOffset + display.viewableContentStartXY()):unpack()
end
