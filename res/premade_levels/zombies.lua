local corridorFilling = {
    type = "image",
    filename = "res/img/stone_wall.png",
    tileWidth = 64,
    tileHeight = 64
}
local corridorFloorFilling = { 0.15, 0.15, 0.15, 1 }

local CORRIDOR1_ID = 1
local CORRIDOR2_ID = 2
local CORRIDOR3_ID = 3
local CORRIDOR4_ID = 4
local CORRIDOR5_ID = 5

return {
    size = { width = 500, height = 500 },
    startPosition = { x = 225, y = 100 },
    startLocation = CORRIDOR1_ID,
    walls = {
        --region corridor 1
        {
            startXY = { x = 50, y = 50 },
            endXY = { x = 450, y = 60 },
            fill = corridorFilling,
            rooms = { CORRIDOR1_ID }
        },
        {
            startXY = { x = 440, y = 50 },
            endXY = { x = 450, y = 150 },
            fill = corridorFilling,
            rooms = { CORRIDOR1_ID }
        },
        {
            startXY = { x = 50, y = 50 },
            endXY = { x = 60, y = 150 },
            fill = corridorFilling,
            rooms = { CORRIDOR1_ID }
        },
        {
            startXY = { x = 50, y = 140 },
            endXY = { x = 350, y = 150 },
            fill = corridorFilling,
            rooms = { CORRIDOR1_ID }
        },
        --endregion
        --region corridor 2
        {
            startXY = { x = 350, y = 140 },
            endXY = { x = 360, y = 350 },
            fill = corridorFilling,
            rooms = { CORRIDOR2_ID }
        },
        {
            startXY = { x = 440, y = 140 },
            endXY = { x = 450, y = 350 },
            fill = corridorFilling,
            rooms = { CORRIDOR2_ID }
        },
        --endregion
        --region corridor 3
        {
            startXY = { x = 150, y = 440 },
            endXY = { x = 450, y = 450 },
            fill = corridorFilling,
            rooms = { CORRIDOR3_ID }
        },
        {
            startXY = { x = 150, y = 350 },
            endXY = { x = 350, y = 350 },
            fill = corridorFilling,
            rooms = { CORRIDOR3_ID }
        },
        {
            startXY = { x = 440, y = 350 },
            endXY = { x = 450, y = 450 },
            fill = corridorFilling,
            rooms = { CORRIDOR3_ID }
        },
        {
            startXY = { x = 150, y = 350 },
            endXY = { x = 160, y = 450 },
            fill = corridorFilling,
            rooms = { CORRIDOR3_ID }
        }
        --endregion
    },
    floors = {
        [CORRIDOR1_ID] = {
            center = { x = 250, y = 100 },
            size = { width = 400, height = 100 },
            fill = corridorFloorFilling
        },
        [CORRIDOR2_ID] = {
            center = { x = 400, y = 250 },
            size = { width = 100, height = 400 },
            fill = corridorFloorFilling
        },
        [CORRIDOR3_ID] = {
            center = { x = 300, y = 400 },
            size = { width = 300, height = 100 },
            fill = corridorFloorFilling
        }
    },
    roomsGraph = {
        [CORRIDOR1_ID] = { CORRIDOR1_ID, CORRIDOR2_ID },
        [CORRIDOR2_ID] = { CORRIDOR1_ID, CORRIDOR2_ID, CORRIDOR3_ID },
        [CORRIDOR3_ID] = { CORRIDOR2_ID, CORRIDOR3_ID, CORRIDOR4_ID },
        [CORRIDOR4_ID] = { CORRIDOR3_ID, CORRIDOR4_ID, CORRIDOR5_ID },
        [CORRIDOR5_ID] = { CORRIDOR4_ID, CORRIDOR5_ID }
    },
    chests = {},
    enemies = {
        { type = "zombie", position = { x = 150, y = 120 }, loot = {} },
        { type = "zombie", position = { x = 125, y = 100 }, loot = {} },
        { type = "zombie", position = { x = 100, y = 100 }, loot = {} },
        { type = "zombie", position = { x = 100, y = 80 }, loot = {} },
        { type = "zombie", position = { x = 100, y = 120 }, loot = {} },
        { type = "zombie", position = { x = 123, y = 120 }, loot = {} },

        { type = "zombie", position = { x = 150, y = 80 }, loot = {} },
        { type = "zombie", position = { x = 175, y = 80 }, loot = {} },
        { type = "zombie", position = { x = 200, y = 80 }, loot = {} },
        { type = "zombie", position = { x = 225, y = 80 }, loot = {} },
        { type = "zombie", position = { x = 250, y = 80 }, loot = {} },
        { type = "zombie", position = { x = 275, y = 80 }, loot = {} },
        { type = "zombie", position = { x = 300, y = 80 }, loot = {} },
        { type = "zombie", position = { x = 325, y = 80 }, loot = {} },
        { type = "zombie", position = { x = 350, y = 80 }, loot = {} },
        { type = "zombie", position = { x = 375, y = 80 }, loot = {} },
        { type = "zombie", position = { x = 400, y = 80 }, loot = {} },
        { type = "zombie", position = { x = 425, y = 80 }, loot = {} },
        { type = "zombie", position = { x = 425, y = 80 }, loot = {} },

        { type = "zombie", position = { x = 425, y = 80 }, loot = {} },
        { type = "zombie", position = { x = 425, y = 100 }, loot = {} },
        { type = "zombie", position = { x = 425, y = 125 }, loot = {} },
        { type = "zombie", position = { x = 425, y = 150 }, loot = {} },
        { type = "zombie", position = { x = 425, y = 175 }, loot = {} },
        { type = "zombie", position = { x = 425, y = 200 }, loot = {} },
        { type = "zombie", position = { x = 425, y = 250 }, loot = {} },
        { type = "zombie", position = { x = 425, y = 300 }, loot = {} },
        { type = "zombie", position = { x = 425, y = 350 }, loot = {} },
        { type = "zombie", position = { x = 425, y = 400 }, loot = {} },
        { type = "zombie", position = { x = 425, y = 425 }, loot = {} },

        { type = "zombie", position = { x = 360, y = 80 }, loot = {} },
        { type = "zombie", position = { x = 360, y = 100 }, loot = {} },
        { type = "zombie", position = { x = 360, y = 125 }, loot = {} },
        { type = "zombie", position = { x = 360, y = 150 }, loot = {} },
        { type = "zombie", position = { x = 360, y = 175 }, loot = {} },
        { type = "zombie", position = { x = 360, y = 200 }, loot = {} },
        { type = "zombie", position = { x = 360, y = 250 }, loot = {} },
        { type = "zombie", position = { x = 360, y = 300 }, loot = {} },
        { type = "zombie", position = { x = 360, y = 350 }, loot = {} },
        { type = "zombie", position = { x = 360, y = 400 }, loot = {} },
        { type = "zombie", position = { x = 360, y = 425 }, loot = {} },
    },
    specialObjects = {
        {
            type = "exit door",
            position = { x = 200, y = 360 },
            filling = {
                type = "image",
                filename = "res/img/exit_door.png",
                width = 48,
                height = 64,
                anchor = { x = 0.5, y = 1 }
            },
            predicate = {},
            area = { width = 32, height = 24 }
        }
    }
}
