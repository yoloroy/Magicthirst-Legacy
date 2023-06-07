local arenaFilling = { 0.3, 0.25, 0.0, 1 }
local arenaFloorFilling = { 0.8, 0.7, 0.45, 1 }

local MAIN_ID = 1
local START_ID = 2

return {
    size = { width = 500, height = 750 },
    startPosition = { x = 225, y = 100 },
    startLocation = MAIN_ID,
    walls = {
        {
            startXY = { x = 0, y = 0 },
            endXY = { x = 500, y = 10 },
            fill = arenaFilling,
            rooms = { START_ID }
        },
        {
            startXY = { x = 0, y = 0 },
            endXY = { x = 10, y = 750 },
            fill = arenaFilling,
            rooms = { MAIN_ID, START_ID }
        },
        {
            startXY = { x = 490, y = 0 },
            endXY = { x = 500, y = 750 },
            fill = arenaFilling,
            rooms = { MAIN_ID, START_ID }
        },
        {
            startXY = { x = 0, y = 240 },
            endXY = { x = 500, y = 250 },
            fill = arenaFilling,
            rooms = { MAIN_ID, START_ID }
        },
        {
            startXY = { x = 0, y = 740 },
            endXY = { x = 500, y = 750 },
            fill = arenaFilling,
            rooms = { MAIN_ID, START_ID }
        }
    },
    floors = {
        [MAIN_ID] = {
            center = { x = 250, y = 500 },
            size = { width = 500, height = 500 },
            fill = arenaFloorFilling
        },
        [START_ID] = {
            center = { x = 250, y = 125 },
            size = { width = 500, height = 250 },
            fill = arenaFloorFilling
        }
    },
    roomsGraph = {
        [START_ID] = { MAIN_ID, START_ID },
        [MAIN_ID] = { MAIN_ID }
    },
    chests = {
        { position = { x = 300, y = 250 }, loot = { "spear" }, openable = true }
    },
    enemies = {
        { type = "zombie", position = { x = 20, y = 260 }, loot = {} },
        { type = "zombie", position = { x = 20, y = 280 }, loot = {} },
        { type = "zombie", position = { x = 20, y = 300 }, loot = {} },
        { type = "zombie", position = { x = 20, y = 320 }, loot = {} },
        { type = "zombie", position = { x = 20, y = 350 }, loot = {} },
        { type = "zombie", position = { x = 20, y = 370 }, loot = {} },
        { type = "zombie", position = { x = 20, y = 390 }, loot = {} },

        { type = "zombie", position = { x = 480, y = 260 }, loot = {} },
        { type = "zombie", position = { x = 480, y = 280 }, loot = {} },
        { type = "zombie", position = { x = 480, y = 300 }, loot = {} },
        { type = "zombie", position = { x = 480, y = 320 }, loot = {} },
        { type = "zombie", position = { x = 480, y = 350 }, loot = {} },
        { type = "zombie", position = { x = 480, y = 370 }, loot = {} },
        { type = "zombie", position = { x = 480, y = 390 }, loot = {} },

        { type = "zombie", position = { x = 130, y = 400 }, loot = {} },
        { type = "zombie", position = { x = 150, y = 400 }, loot = {} },
        { type = "zombie", position = { x = 170, y = 400 }, loot = {} },
        { type = "zombie", position = { x = 190, y = 400 }, loot = {} },
        { type = "zombie", position = { x = 210, y = 400 }, loot = {} },
        { type = "zombie", position = { x = 230, y = 400 }, loot = {} },
        { type = "zombie", position = { x = 250, y = 400 }, loot = {} },
        { type = "zombie", position = { x = 270, y = 400 }, loot = {} },
        { type = "zombie", position = { x = 290, y = 400 }, loot = {} },
        { type = "zombie", position = { x = 310, y = 400 }, loot = {} },
        { type = "zombie", position = { x = 330, y = 400 }, loot = {} },
        { type = "zombie", position = { x = 350, y = 400 }, loot = {} },
        { type = "zombie", position = { x = 370, y = 400 }, loot = {} },

        { type = "big skeleton", position = { x = 250, y = 450 }, loot = { "key" } },
    },
    specialObjects = {
        {
            type = "exit door",
            position = { x = 250, y = 255 },
            filling = {
                type = "image",
                filename = "res/img/exit_door.png",
                width = 48,
                height = 64,
                anchor = { x = 0.5, y = 1 }
            },
            predicate = {
                --- @param inventory Inventory
                inventory = function(inventory)
                    for _, i in ipairs(inventory.items) do
                        if i.name == "key" then return true end
                    end
                    return false
                end
            },
            area = { width = 32, height = 24 }
        },
        {
            type = "teleporter",
            position = { x = 250, y = 15 },
            exitXY = { x = 250, y = 265 }
        }
    }
}
