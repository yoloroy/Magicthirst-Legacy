local gameplayRuntime = require "src.scene.tactics.gameplay_runtime"

require "src.common.util.array"

--- pcKeyEventsListener
--- @param keysConfig PcKeysConfig
--- @param levelObjects { player: Hero, inventoryUI: InventoryUI, inventory: Inventory }
--- @return fun(event): boolean
function pcKeyEventsListener(keysConfig, levelObjects)
    local player = levelObjects.player
    local inventoryUI = levelObjects.inventoryUI
    local inventory = levelObjects.inventory

    local pressedKeys = {}

    function updateDirection()
        if not gameplayRuntime:isRunning() then
            player.isMoving = false
            return
        end
        player.isMoving = true
        if table.contains(pressedKeys, keysConfig.up) and table.contains(pressedKeys, keysConfig.left) then
            player:changeDirection(225)
        elseif table.contains(pressedKeys, keysConfig.down) and table.contains(pressedKeys, keysConfig.left) then
            player:changeDirection(135)
        elseif table.contains(pressedKeys, keysConfig.up) and table.contains(pressedKeys, keysConfig.right) then
            player:changeDirection(315)
        elseif table.contains(pressedKeys, keysConfig.down) and table.contains(pressedKeys, keysConfig.right) then
            player:changeDirection(45)
        elseif table.contains(pressedKeys, keysConfig.up) then
            player:changeDirection(270)
        elseif table.contains(pressedKeys, keysConfig.down) then
            player:changeDirection(90)
        elseif table.contains(pressedKeys, keysConfig.left) then
            player:changeDirection(180)
        elseif table.contains(pressedKeys, keysConfig.right) then
            player:changeDirection(0)
        else
            player.isMoving = false
        end
    end

    function movement(keyName, _)
        local movementKeys = { keysConfig.up, keysConfig.down, keysConfig.left, keysConfig.right }
        if table.contains(movementKeys, keyName) then
            updateDirection()
            return true
        end
        return false
    end

    function inventoryKeys(keyName, phase)
        if phase ~= "down" then return false end

        if keyName == keysConfig.inventory then
            inventoryUI:toggle()
            return true
        end
        local number = tonumber(keyName)
        if number ~= nil then
            print("pressedKeys: " .. table.concat(pressedKeys, ", "))
            if table.contains(pressedKeys, "leftCtrl") or table.contains(pressedKeys, "leftControl") then
                number = 10 + number
            end
            if number > 0 then
                inventory:use(number)
                return true
            end
        end

        return false
    end

    function action(keyName, phase)
        if phase ~= "down" then return false end
        if not gameplayRuntime:isRunning() then return end

        if keyName == keysConfig.attack then
            player:performAttack()
            return true
        end

        return false
    end

    return function(event)
        local keyName = event.keyName
        local phase = event.phase
        local somethingHappened = false
        if phase == "down" and not table.contains(pressedKeys, keyName) then
            table.insert(pressedKeys, keyName)
        elseif phase == "up" then
            table.removeValue(pressedKeys, keyName)
        end
        somethingHappened = somethingHappened or movement(keyName, phase)
        somethingHappened = somethingHappened or action(keyName, phase)
        somethingHappened = somethingHappened or inventoryKeys(keyName, phase)
        return somethingHappened
    end
end
