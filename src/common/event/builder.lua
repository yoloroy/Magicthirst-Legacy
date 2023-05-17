local touch = {}

--- @module eventBuilder
eventBuilder = {
    touch = touch
}

--- [eventBuilder].[touch].ended
--- @param listener function('event': any): boolean
--- @return function('event': any): boolean
function touch.ended(listener)
    return function(event)
        if event.phase == "ended" then return listener(event) end return false
    end
end
