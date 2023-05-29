require "src.common.util.iter"

return {
    name = "spear",
    tag = "spear",
    isEquipment = true,
    fillingData = {
        sheet = graphics.newImageSheet("res/img/inventory/item_icons/spear.png", {
            frames = Iterable.ofCount(10):map(function(i)
                return {
                    x = 5 * i,
                    y = 0,
                    width = 5,
                    height = 32
                }
            end)
        }),
        sequenceData = {
            name = "idle",
            start = 1,
            count = 10,
            time = 1000
        }
    }
}
