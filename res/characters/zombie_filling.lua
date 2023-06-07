local options = {
    width = 32,
    height = 32,
    numFrames = 8,
    sheetContentWidth = 64,
    sheetContentHeight = 128
}

local sheet = graphics.newImageSheet("res/characters/zombie.png", options)

return {
    keyDefault = "unarmed",
    unarmed = {
        keyDefault = "idle",
        idle = {
            down = {
                type = "image",
                sheet = sheet,
                frame = 1,
                anchorX = 0.5
            },
            up = {
                type = "image",
                sheet = sheet,
                frame = 3,
                anchorX = 0.5
            },
            right = {
                type = "image",
                sheet = sheet,
                frame = 5,
                anchorX = 0.5
            },
            left = {
                type = "image",
                sheet = sheet,
                frame = 7,
                anchorX = 0.5
            }
        },
        attack = {
            down = {
                type = "image",
                sheet = sheet,
                frame = 2,
                anchorX = 0.5
            },
            up = {
                type = "image",
                sheet = sheet,
                frame = 4,
                anchorX = 0.5
            },
            right = {
                type = "image",
                sheet = sheet,
                frame = 6,
                anchorX = 0.5
            },
            left = {
                type = "image",
                sheet = sheet,
                frame = 8,
                anchorX = 0.5
            }
        }
    }
}
