require "src.common.util.iter"
require "src.common.util.array"

--- @class Observable
--- @field _value
--- @field _observers Iterable<fun(newValue, oldValue)>
Observable = {}
Observable.__index = Observable

--- Observable:new
--- @param initialValue
--- @return Observable
function Observable:new(initialValue)
    local obj = {
        _value = initialValue,
        _observers = Iterable:new {}
    }
    setmetatable(obj, Observable)
    return obj
end

--- Observable:get
--- @return any
function Observable:get()
    return self._value
end

--- Observable:set
--- @param value any
function Observable:set(value)
    local oldValue = self._value
    self._value = value
    self._observers:callAll(self._value, oldValue)
end

--- Observable:observe
--- @param fun fun(newValue, oldValue)
function Observable:observe(fun)
    table.insert(self._observers, fun)
end

--- Observable:stopObserving
--- @param fun fun(newValue, oldValue)
function Observable:stopObserving(fun)
    table.removeValue(self._observers, fun)
end
