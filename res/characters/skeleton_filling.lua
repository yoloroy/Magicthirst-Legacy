local options = {
    width = 32,
    height = 32,
    numFrames = 12,
    sheetContentWidth = 96,
    sheetContentHeight = 128
}

local sheet = graphics.newImageSheet("res/characters/skeleton.png", options)

return {
    unarmed = {
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
                frame = 4,
                anchorX = 0.5
            },
            right = {
                type = "image",
                sheet = sheet,
                frame = 7,
                anchorX = 0.5
            },
            left = {
                type = "image",
                sheet = sheet,
                frame = 10,
                anchorX = 0.5
            }
        }
    },
    withTheSpear = {
        idle = {
            down = {
                type = "image",
                sheet = sheet,
                frame = 2,
                anchorX = 0.5
            },
            up = {
                type = "image",
                sheet = sheet,
                frame = 5,
                anchorX = 0.5
            },
            right = {
                type = "image",
                sheet = sheet,
                frame = 8,
                anchorX = 0.5
            },
            left = {
                type = "image",
                sheet = sheet,
                frame = 11,
                anchorX = 0.5
            }
        },
        attack = {
            down = {
                type = "image",
                sheet = sheet,
                frame = 3,
                anchorX = 0.5
            },
            up = {
                type = "image",
                sheet = sheet,
                frame = 6,
                anchorX = 0.5
            },
            right = {
                type = "image",
                sheet = sheet,
                frame = 9,
                anchorX = 9 / 32
            },
            left = {
                type = "image",
                sheet = sheet,
                frame = 12,
                anchorX = 23 / 32
            }
        }
    },
}
