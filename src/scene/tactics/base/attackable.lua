--- @class Attackable
--- @field tags table<string>
--- @field view AttackableView
Attackable = {
    tag = "Attackable"
}
Attackable.__index = Attackable

--- Attackable:sufferAttack
--- @param attacker Attackable
--- @param attack Attack
function Attackable:sufferAttack(attacker, attack)
    error("TODO: implement")
end

function Attackable:addDeathListener(listener)
    if self.deathListeners == nil then
        self.deathListeners = {}
    end
    table.insert(deathListeners, listener)
end
