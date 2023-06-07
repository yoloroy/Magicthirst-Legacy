local composer = require "composer"
require "src.scene.common.parameters"
require "src.scene.tactics.configs"

display.setDefault("magTextureFilter", "nearest")
display.setDefault("minTextureFilter", "linear")
display.setDefault("textureWrapX", "repeat")
display.setDefault("textureWrapY", "repeat")

composer.setVariable(PC_KEYS_CONFIG_PARAMETER, { up = "w", down = "s", left = "a", right = "d", attack = "space", inventory = "i" })
composer.setVariable(OS_PARAMETER, OS_ENUM_PC)
composer.gotoScene("src.scene.menu.scene")
