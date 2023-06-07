require "src.common.util.array"

local GameplayRuntime = {}

function GameplayRuntime:init(runtime, isRunning, physics)
    self._runtime = runtime
    self._physics = physics
    self._isRunning = isRunning
    self._enterFrameListeners = {
        tables = {},
        functions = {}
    }
    runtime:addEventListener("enterFrame", self)
end

function GameplayRuntime:removeSelf()
    self._runtime:removeEventListener("enterFrame", self)
    self._enterFrameListeners = nil
end

--- GameplayRuntime:isRunning
--- @overload fun(): boolean
--- @param value boolean
--- @return void
function GameplayRuntime:isRunning(value)
    if value == nil then return self._isRunning end
    self._isRunning = value
    if self._isRunning then
        self._physics:start()
    else
        self._physics:pause()
    end
end

function GameplayRuntime:addEnterFrameListener(listener)
    if type(listener) == "function" then
        table.insert(self._enterFrameListeners.functions, listener)
    elseif type(listener) == "table" then
        table.insert(self._enterFrameListeners.tables, listener)
    else
        error("Invalid listener type: " .. type(listener) .. ", it must be either function or table")
    end
end

function GameplayRuntime:removeEnterFrameListener(listener)
    if type(listener) == "function" then
        table.removeValue(self._enterFrameListeners.functions, listener)
    elseif type(listener) == "table" then
        table.removeValue(self._enterFrameListeners.tables, listener)
    else
        error("Invalid listener type: " .. type(listener) .. ", it must be either function or table")
    end
end

function GameplayRuntime:enterFrame(event)
    if not self._isRunning then return end
    for _, table in ipairs(self._enterFrameListeners.tables) do
        table:enterFrame(event)
    end
    for _, listener in ipairs(self._enterFrameListeners.functions) do
        listener(event)
    end
end

return GameplayRuntime
