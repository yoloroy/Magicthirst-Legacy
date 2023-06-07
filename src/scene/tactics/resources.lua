require "src.scene.tactics.configs"

inventoryTileSideSize = 32
inventoryItemPlacementOffset = 16

function directionNameOf(degrees) -- priority for facing left and right
    local degrees = (degrees + 360) % 360 -- placing degrees in range from 0 to 360
    if degrees >= 50 and degrees < 130 then return "down" end
    if degrees >= 250 and degrees < 310 then return "up" end
    if degrees >= 130 and degrees < 250 then return "left" end
    return "right"
end

-- TODO replace functions with variables

function inventoryItemIconForTag(tag)
    if tag == foodConfig.tag then
        return {
            type = "image",
            filename = "res/img/inventory/item_icons/food.png"
        }
    end
    if tag == "spear" then
        return {
            type = "image",
            sheet = graphics.newImageSheet("res/img/inventory/item_icons/spear.png", {
                width = 5,
                height = 32,
                numFrames = 10
            }),
            frame = 1
        }
    end
    if tag == "magicPush" then
        return {
            type = "image",
            filename = "res/img/inventory/item_icons/magic_push.png"
        }
    end
    if tag == "key" then
        return {
            type = "image",
            filename = "res/img/inventory/item_icons/key.png"
        }
    end
    error("unknown tag: <"..tag..">")
end

function inventoryBackgroundItemCell()
    return {
        type = "image",
        filename = "res/img/inventory/cell_background.png"
    }
end

function inventoryBackgroundTiles()
    function tile(x, y)
        return { type = "image", filename = "res/img/inventory/background_9slice/row-"..y.."-column-"..x..".png" }
    end
    ---@type table<table>
    local tiles = {
        { tile(1, 1), tile(2, 1), tile(3, 1) },
        { tile(1, 2), tile(2, 2), tile(3, 2) },
        { tile(1, 3), tile(2, 3), tile(3, 3) },
    }
    return tiles
end

playerMeleeAttackAreaFilling = {
    type = "image",
    filename = "res/img/attack_swing.png"
}

playerMagicPushAreaFilling = {
    type = "image",
    filename = "res/img/magic_push.png"
}

testTurretImageFilling = {
    type = "image",
    filename = "res/img/test_turret.png"
}

skeletonFilling = {
    type = "image",
    filename = "res/img/skeleton.png"
}

hitSound = audio.loadSound("res/sound/hit1.mp3")
stepSound = audio.loadSound("res/sound/step2.mp3")
