require "src.common.util.structs"

--- @class PcKeysConfig
--- @field up string
--- @field down string
--- @field left string
--- @field right string
--- @field attack string
--- @field inventory string

isTest = false

baseTags = {
    container = "Container",
    item = "Item"
}

levelConfig = {
    size = Size:new(1000, 1000),
    backgroundFill = { 0.3, 0.3, 0.3, 1 },
    wallHeight = 48,
    wallAlpha = 0.4
}

obstacleConfig = {
    atLeastSize = Size:new(10, 10),
    atMostSize = Size:new(100, 100),
    fill = { 0.5, 0.5, 0.5, 1 }
}

foodConfig = {
    radius = 5,
    fill = { 1, 1, 0, 1 },
    tag = "Food"
}

chestConfig = {
    size = Size:new(24, 24),
    fill = { 0.58, 0.38, 0.19 },
    tag = "Chest",
    hp = 25
}

playerConfig = {
    maxHealth = 100,
    colliderSize = Size:new(14, 16),
    viewSize = Size:new(32, 32),
    fill = {
        type = "image",
        filename = "res/img/chel_vishel_na_svet.png"
    },
    speedPerSecond = 80,
    colliderOffset = XY:new(0, 8), -- offset from the center of the view
    attackOffset = XY:new(0, -16), -- offset from the center of the view
    meleeAttackDurationMillis = 200,
    attackIntervalSeconds = 0.5,
    tag = "Hero"
}
