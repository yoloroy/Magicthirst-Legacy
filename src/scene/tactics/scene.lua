local composer = require "composer"

require "src.scene.common.parameters"
require "src.common.util.structs"
require "src.scene.tactics.controller"

local level = require "src.scene.tactics.level"

local os = composer.getVariable(OS_PARAMETER)

local scene = composer.newScene()
local levelObjects
local keysListener

function scene:show()
    if levelObjects ~= nil then return end
    levelObjects = level.init(self, require(composer.getVariable(CURRENT_LEVEL_PARAMETER)))
    if os == OS_ENUM_PC then
        keysListener = pcKeyEventsListener(composer.getVariable(PC_KEYS_CONFIG_PARAMETER), levelObjects)
        Runtime:addEventListener("key", keysListener)
    end --TODO other variants
end

function scene:hide()
    if levelObjects == nil then return end
    levelObjects.allToRemove:onEach(function(o) o:removeSelf() end)
    levelObjects = nil
    if os == OS_ENUM_PC then
        Runtime:removeEventListener("key", keysListener)
    end --TODO other variants
end

scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene
