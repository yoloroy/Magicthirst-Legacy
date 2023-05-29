require "src.common.util.array"

--- @class ActionStateManipulator
--- @generic Owner : { actionName: string }
--- @field _owner Owner
--- @field _states table<string, { possibleTransformations: string[], isPossible: fun(owner: Owner): boolean }>
--- @field _previousState string
ActionStateManipulator = {}
ActionStateManipulator.__index = ActionStateManipulator

--- ActionStateManipulator:new
--- @generic Owner : { actionName: string }
--- @param stateOwner Owner
--- @param states table<string, { possibleTransformations: string[], isPossible: fun(owner: Owner): boolean }>
function ActionStateManipulator:new(stateOwner, states)
    --- @type ActionStateManipulator
    local obj = { _owner = stateOwner, _states = states, _previousState = stateOwner.actionName }
    setmetatable(obj, self)
    return obj
end

--- ActionStateManipulator:tryDoState
--- @param actionName string
--- @return boolean is the state has been changed
function ActionStateManipulator:tryChangeState(actionName)
    local currentState = self._states[self._owner.actionName]
    if not table.contains(currentState.possibleTransformations, actionName) then return false end
    local nextState = self._states[actionName]
    if not nextState.isPossible(self._owner) then return false end
    self._previousState = self._owner.actionName
    self._owner.actionName = actionName
    return true
end

function ActionStateManipulator:changeStateBack()
    self._owner.actionName = self._previousState
end
