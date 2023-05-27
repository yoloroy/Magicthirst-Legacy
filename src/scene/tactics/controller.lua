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

    function movement(keyName, phase)
        local somethingHappened = false
        local movementKeys = { keysConfig.up, keysConfig.down, keysConfig.left, keysConfig.right }
        if phase == "down" and table.contains(movementKeys, keyName) then
            if not table.contains(pressedKeys, keyName) then
                table.insert(pressedKeys, keyName)
            end
            somethingHappened = true
        elseif phase == "up" and table.contains(movementKeys, keyName) then
            table.remove(pressedKeys, table.indexOf(pressedKeys, keyName))
            somethingHappened = true
        end
        if somethingHappened then
            updateDirection()
        end
        return somethingHappened
    end

    function inventoryKeys(keyName, phase)
        if phase ~= "down" then return false end

        if keyName == keysConfig.inventory then
            inventoryUI:toggle()
            return true
        end
        if tonumber(keyName) ~= nil and tonumber(keyName) > 0 then
            inventory:use(tonumber(keyName))
            return true
        end

        return false
    end

    function other(keyName, phase)
        if phase ~= "down" then return false end

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
        somethingHappened = somethingHappened or movement(keyName, phase)
        somethingHappened = somethingHappened or other(keyName, phase)
        somethingHappened = somethingHappened or inventoryKeys(keyName, phase)
        return somethingHappened
    end
end
