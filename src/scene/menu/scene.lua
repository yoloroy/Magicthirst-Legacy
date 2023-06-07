local composer = require "composer"
local level = require "src.scene.menu.level"

local scene = composer.newScene()

function scene:create()
    level.init(self)
end

scene:addEventListener("create", scene)

return scene
