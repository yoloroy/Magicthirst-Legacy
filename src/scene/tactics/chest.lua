require "src.scene.tactics.base.container"
require "src.scene.tactics.configs"
require "src.common.util.array"

local FILLING = require("res.img.chest_filling")

--- @class Chest : Container
--- @field _fill
--- @field _hp number
Chest = {}
setmetatable(Chest, Container)
Chest.__index = Chest

--- Chest:new
--- @param group
--- @param xy XY
--- @param items ContainerItem[]
--- @return Chest
function Chest:new(group, xy, items, physics)
    local view = display.newRect(group, xy.x, xy.y, chestConfig.size.width, chestConfig.size.height)
    physics.addBody(view, "dynamic")
    view.linearDamping = 10
    view.isFixedRotation = true
    view.fill = FILLING.forDamage(1)
    ---@type Chest
    local obj = Container:new(view, items, nil, randomCircularPlacementStrategy(1))
    table.insert(obj.tags, chestConfig.tag)
    view.tags = obj.tags
    obj._hp = chestConfig.hp
    setmetatable(obj, self)
    view.object = obj
    return obj
end

--- Chest:sufferAttack
--- @param attacker AttackableView
--- @param attack Attack
function Chest:sufferAttack(attacker, attack)
    self._hp = self._hp - attack.value
    self:_updateViewForHp()
    if self._hp <= 0 then
        self:destroy()
    end
end

function Chest:_updateViewForHp()
    self.view.fill = FILLING.forDamage(self._hp / chestConfig.hp)
end

--- @class OpenableChest : Chest
OpenableChest = {}
setmetatable(OpenableChest, Chest)
OpenableChest.__index = OpenableChest

function OpenableChest:new(group, xy, items, physics)
    local chest = Chest:new(group, xy, items, physics)
    chest.view:addEventListener("postCollision", function(event)
        if event.other.tags == nil or not table.contains(event.other.tags, playerConfig.tag) then return end
        chest:destroy()
    end)
end
