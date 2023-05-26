local leftRoomFilling = { 0.2, 0.2, 0.2, 1 }
local leftRoomFloorFilling = { 0.1, 0.1, 0.1, 1 }
local centreRoomFilling = { 0.4, 0.4, 0.2, 1 }
local centreRoomFloorFilling = { 0.2, 0.2, 0.1, 1 }
local rightRoomFilling = { 0.4, 0.2, 0.2, 1 }
local rightRoomFloorFilling = { 0.2, 0.1, 0.1, 1 }
local corridorFilling = { 0.4, 0.3, 0.1, 1 }
local corridorFloorFilling = { 0.2, 0.15, 0.05, 1 }
local startRoomFilling = { 0.3, 0.5, 0.4, 1 }
local startRoomFloorFilling = { 0.1, 0.2, 0.15, 1 }

local testFilling = { 1, 0, 1, 1 }

local LEFT_ROOM_ID = 1
local NOOK_NEXT_TO_LEFT_ROOM_ID = 2
local CORRIDOR_ID = 3
local CENTRE_ROOM_ID = 4
local RIGHT_ROOM_ID = 5
local START_ROOM_ID = 6

return {
    size = { width = 1000, height = 800 },
    startPosition = { x = 850, y = 150 },
    startLocation = START_ROOM_ID,
    walls = {
        --region left room
        {
            startXY = { x = 315, y = 358 },
            endXY = { x = 321, y = 380 },
            fill = leftRoomFilling,
            rooms = { LEFT_ROOM_ID, CORRIDOR_ID }
        },
        {
            startXY = { x = 315, y = 158 },
            endXY = { x = 321, y = 358 },
            fill = leftRoomFilling,
            rooms = { LEFT_ROOM_ID }
        },
        {
            startXY = { x = 59, y = 158 },
            endXY = { x = 321, y = 168 },
            fill = leftRoomFilling,
            rooms = { LEFT_ROOM_ID }
        },
        {
            startXY = { x = 59, y = 158 },
            endXY = { x = 71, y = 434 },
            fill = leftRoomFilling,
            rooms = { LEFT_ROOM_ID }
        },
        {
            startXY = { x = 59, y = 428 },
            endXY = { x = 300, y = 434 },
            fill = leftRoomFilling,
            rooms = { LEFT_ROOM_ID, CORRIDOR_ID }
        },
        --endregion
        {
            startXY = { x = 159, y = 428 },
            endXY = { x = 165, y = 481 },
            fill = corridorFilling,
            rooms = { CORRIDOR_ID }
        },
        {
            startXY = { x = 159, y = 475 },
            endXY = { x = 206, y = 481 },
            fill = corridorFilling,
            rooms = { CORRIDOR_ID }
        },
        {
            startXY = { x = 200, y = 475 },
            endXY = { x = 206, y = 556 },
            fill = corridorFilling,
            rooms = { CORRIDOR_ID }
        },
        {
            startXY = { x = 200, y = 550 },
            endXY = { x = 700, y = 556 },
            fill = corridorFilling,
            rooms = { CORRIDOR_ID }
        },
        --region right room
        {
            startXY = { x = 693, y = 550 },
            endXY = { x = 761, y = 560 },
            fill = rightRoomFilling,
            rooms = { CORRIDOR_ID, RIGHT_ROOM_ID }
        },
        {
            startXY = { x = 693, y = 550 },
            endXY = { x = 700, y = 765 },
            fill = rightRoomFilling,
            rooms = { RIGHT_ROOM_ID }
        },
        {
            startXY = { x = 693, y = 759 },
            endXY = { x = 956, y = 765 },
            fill = rightRoomFilling,
            rooms = { RIGHT_ROOM_ID }
        },
        {
            startXY = { x = 950, y = 550 },
            endXY = { x = 956, y = 759 },
            fill = rightRoomFilling,
            rooms = { RIGHT_ROOM_ID }
        },
        {
            startXY = { x = 825, y = 550 },
            endXY = { x = 956, y = 560 },
            fill = rightRoomFilling,
            rooms = { RIGHT_ROOM_ID }
        },
        --endregion
        {
            startXY = { x = 825, y = 356 },
            endXY = { x = 831, y = 550-1 },
            fill = corridorFilling,
            rooms = { CORRIDOR_ID }
        },
        {
            startXY = { x = 556, y = 356 },
            endXY = { x = 831, y = 362 },
            fill = corridorFilling,
            rooms = { CORRIDOR_ID }
        },
        --region centre room
        {
            startXY = { x = 556, y = 330 },
            endXY = { x = 562, y = 362-1 },
            fill = centreRoomFilling,
            rooms = { CENTRE_ROOM_ID }
        },
        {
            startXY = { x = 556, y = 330 },
            endXY = { x = 650, y = 340 },
            fill = centreRoomFilling,
            rooms = { CENTRE_ROOM_ID }
        },
        {
            startXY = { x = 643, y = 81 },
            endXY = { x = 650, y = 340 },
            fill = centreRoomFilling,
            rooms = { CENTRE_ROOM_ID }
        },
        {
            startXY = { x = 393, y = 81 },
            endXY = { x = 650, y = 87 },
            fill = centreRoomFilling,
            rooms = { CENTRE_ROOM_ID }
        },
        {
            startXY = { x = 393, y = 81 },
            endXY = { x = 400, y = 340 },
            fill = centreRoomFilling,
            rooms = { CENTRE_ROOM_ID }
        },
        {
            startXY = { x = 393, y = 330 },
            endXY = { x = 500, y = 340 },
            fill = centreRoomFilling,
            rooms = { CENTRE_ROOM_ID }
        },
        {
            startXY = { x = 493, y = 330 },
            endXY = { x = 500, y = 362-1 },
            fill = centreRoomFilling,
            rooms = { CENTRE_ROOM_ID }
        },
        --endregion
        {
            startXY = { x = 321, y = 356 },
            endXY = { x = 500, y = 362 },
            fill = corridorFilling,
            rooms = { CORRIDOR_ID }
        },
        --region start room
        -- thickness: 20
        {
            startXY = { x = 750, y = 50 },
            endXY = { x = 950, y = 70 },
            fill = startRoomFilling,
            rooms = { START_ROOM_ID }
        },
        {
            startXY = { x = 750, y = 50 },
            endXY = { x = 770, y = 250 },
            fill = startRoomFilling,
            rooms = { START_ROOM_ID }
        },
        {
            startXY = { x = 750, y = 230 },
            endXY = { x = 950, y = 250 },
            fill = startRoomFilling,
            rooms = { START_ROOM_ID }
        },
        {
            startXY = { x = 930, y = 50 },
            endXY = { x = 950, y = 250 },
            fill = startRoomFilling,
            rooms = { START_ROOM_ID }
        },
        --endregion
    },
    floors = {
        [LEFT_ROOM_ID] = {
            center = { x = 190, y = 296 },
            size = { width = 262, height = 276 },
            fill = leftRoomFloorFilling
        },
        [RIGHT_ROOM_ID] = {
            center = { x = 825, y = 658 },
            size = { width = 265, height = 220 },
            fill = corridorFloorFilling
        },
        [CENTRE_ROOM_ID] = {
            center = { x = 522, y = 216 },
            size = { width = 260, height = 280 },
            fill = centreRoomFloorFilling
        },
        [CORRIDOR_ID] = {
            center = { x = 515.5, y = 456 },
            size = { width = 631, height = 200 },
            fill = corridorFloorFilling
        },
        [NOOK_NEXT_TO_LEFT_ROOM_ID] = {
            center = { x = 182.5, y = 454.5 },
            size = { width = 47, height = 53 },
            fill = rightRoomFloorFilling
        },
        [START_ROOM_ID] = {
            center = { x = 850, y = 150 },
            size = { width = 200, height = 200 },
            fill = startRoomFloorFilling
        }
    },
    roomsGraph = {
        [LEFT_ROOM_ID] = { NOOK_NEXT_TO_LEFT_ROOM_ID, CORRIDOR_ID, LEFT_ROOM_ID },
        [NOOK_NEXT_TO_LEFT_ROOM_ID] = { LEFT_ROOM_ID, CORRIDOR_ID, NOOK_NEXT_TO_LEFT_ROOM_ID },
        [CORRIDOR_ID] = { NOOK_NEXT_TO_LEFT_ROOM_ID, LEFT_ROOM_ID, CENTRE_ROOM_ID, RIGHT_ROOM_ID, CORRIDOR_ID },
        [CENTRE_ROOM_ID] = { CORRIDOR_ID, CENTRE_ROOM_ID },
        [RIGHT_ROOM_ID] = { CORRIDOR_ID, RIGHT_ROOM_ID },
        [START_ROOM_ID] = { START_ROOM_ID }
    },
    chests = {
        --region left room
        { position = { x = 190, y = 296 }, loot = { "food", "food", "food" } },
        --endregion
        --region centre room
        { position = { x = 412, y = 256 }, loot = { "food", "food", "food", "food", "food", "food" } },
        { position = { x = 632, y = 256 }, loot = { "food", "food", "food", "food", "food", "food" } },
        --endregion
        --region start room
        { position = { x = 920, y = 90 }, loot = { "spear" }, openable = true }
        --endregion
    },
    enemies = {
        --region nook next to the left room
        { type = "skeleton", position = { x = 182.5, y = 454.5 }, loot = {} },
        --endregion
        --region left room
        { type = "skeleton", position = { x = 150, y = 296 }, loot = { "food" } },
        { type = "skeleton", position = { x = 230, y = 296 }, loot = { "food" } },
        { type = "skeleton", position = { x = 190, y = 256 }, loot = { "food" } },
        { type = "skeleton", position = { x = 190, y = 336 }, loot = { "food" } },
        --endregion
        --region right room
        --region line1
        { type = "skeleton", position = { x = 775, y = 608 }, loot = { "food", "food" } },
        { type = "skeleton", position = { x = 825, y = 608 }, loot = { "food", "food" } },
        { type = "skeleton", position = { x = 875, y = 608 }, loot = { "food", "food" } },
        --endregion
        --region line2
        { type = "skeleton", position = { x = 775, y = 658 }, loot = { "food", "food" } },
        { type = "spitting_brazier", position = { x = 825, y = 658 } },
        { type = "skeleton", position = { x = 875, y = 658 }, loot = { "food", "food" } },
        --endregion
        --region line3
        { type = "skeleton", position = { x = 775, y = 708 }, loot = { "food", "food" } },
        { type = "skeleton", position = { x = 825, y = 708 }, loot = { "food", "food" } },
        { type = "skeleton", position = { x = 875, y = 708 }, loot = { "food", "food" } },
        --endregion
        --endregion
        { type = "spitting_brazier", position = { x = 522, y = 96 } }
    },
    specialObjects = {
        {
            type = "teleporter",
            position = { x = 850, y = 80 },
            exitXY = { x = 515.5, y = 506 }
        }
    }
}
