local options = {
    width = 32,
    height = 32,
    numFrames = 3,
    sheetContentWidth = 96,
    sheetContentHeight = 32
}

local sheet = graphics.newImageSheet("res/img/chest.png", options)

local _100To70percent = {
    type = "image",
    sheet = sheet,
    frame = 1
}
local _70To40percent = {
    type = "image",
    sheet = sheet,
    frame = 2
}
local _40To0percent = {
    type = "image",
    sheet = sheet,
    frame = 3
}

return {
    forDamage = function(healthPercent)
        if healthPercent > 0.7 then return _100To70percent end
        if healthPercent > 0.4 then return _70To40percent end
        return _40To0percent
    end
}
