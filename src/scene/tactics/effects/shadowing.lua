local animation = require "plugin.animation"

require "src.common.util.array"
require "src.common.util.iter"

local transitionDurationSeconds = 1

--- @class ObjectWithAlpha
--- @field alpha number

--- @class Shadowing
--- @field _belongings table<any, ObjectWithAlpha[]> { [location id] = ObjectWithAlpha[], ... }
--- @field _range number displaying range
--- @field _roomsGraph table<any, any[]>
--- @field _visibleLocations Iterable
--- @field _playerLocations any[]
Shadowing = {}
Shadowing.__index = Shadowing

--- Shadowing:new
--- @param belongings table<any, ObjectWithAlpha[]> { [location id] = ObjectWithAlpha[], ... }
--- @param range number
--- @param roomsGraph table<any, any[]>
--- @return Shadowing
function Shadowing:new(belongings, range, roomsGraph, startLocations)
    --- @type Shadowing
    local obj = {
        _belongings = belongings,
        _range = range,
        _roomsGraph = roomsGraph,
        _visibleLocations = Iterable:new(keysOf(roomsGraph)),
        _playerLocations = startLocations
    }
    setmetatable(obj, Shadowing)
    return obj
end

--- Shadowing:addObject
--- @param belonging any
--- @param view ObjectWithAlpha
function Shadowing:registerView(belonging, view)
    view.__shadowing = {
        shadowedStage = Visible,
        storedAlpha = view.alpha,
        storedIsHitTestable = view.isHitTestable
    }
    local belongings = self._belongings[belonging]
    if belongings == nil then
        self._belongings[belonging] = { view }
    else
        table.insert(self._belongings[belonging], view)
    end
    if not table.contains(self._visibleLocations, belonging) then
        self:_hide(view)
    end
end

--- Shadowing:removeObject
--- @param belonging any
--- @param view ObjectWithAlpha
function Shadowing:unregisterView(belonging, view)
    table.removeValue(self._belongings[belonging] or {}, view)
    self:_show(view)
end

function Shadowing:onPlayerUpdateLocations()
    for _, location in pairs(self._visibleLocations) do
        self:_hideLocation(self._belongings[location] or {})
    end
    self._visibleLocations = Iterable:new(self._playerLocations)
        :map(function(location) return self._roomsGraph[location] end)
        :flatten()
        :append(self._playerLocations)
        :onEach(function(location) self:_showLocation(self._belongings[location] or {}) end)
end

function Shadowing:collisionListenerForRegion(id)
    return function(event)
        if event.other.tags == nil then return end
        if table.contains(event.other.tags, playerConfig.tag) then
            if event.phase == "began" then
                table.insert(self._playerLocations, id)
            else
                table.removeValue(self._playerLocations, id, true)
            end
            self:onPlayerUpdateLocations()
        elseif not table.contains(event.other.tags, wallTag) then
            if event.phase == "began" then
                self:registerView(id, event.other)
            else
                self:unregisterView(id, event.other)
            end
        end
    end
end

function Shadowing:_hideLocation(objects, location)
    for _, view in pairs(objects) do
        if view.parent == nil then
            self:unregisterView(location, view)
            return
        end
        self:_hide(view) end
end

function Shadowing:_showLocation(objects, location)
    for _, view in pairs(objects) do
        if view.parent == nil then
            self:unregisterView(location, view)
            return
        end
        self:_show(view)
    end
end

function Shadowing:_hide(view)
    local shadowing = view.__shadowing
    if shadowing.shadowedStage == Shadowed or shadowing.shadowedStage == Shading then return end
    shadowing.shadowedStage = Shading
    if shadowing.tween ~= nil then shadowing.tween:cancel() end
    shadowing.tween = animation.to(view, { alpha = 0 }, {
        time = transitionDurationSeconds * 1000 * view.alpha,
        onComplete = function()
            shadowing.tween = nil
            shadowing.shadowedStage = Shadowed
        end
    })
    view.isHitTestable = false
end

function Shadowing:_show(view)
    local shadowing = view.__shadowing
    if shadowing.shadowedStage == Visible or shadowing.shadowedStage == Deshading then return end
    shadowing.shadowedStage = Deshading
    view.isHitTestable = shadowing.storedIsHitTestable
    if shadowing.tween ~= nil then shadowing.tween:cancel() end
    shadowing.tween = animation.to(view, { alpha = shadowing.storedAlpha }, {
        time = transitionDurationSeconds * 1000 * shadowing.storedAlpha,
        onComplete = function()
            shadowing.tween = nil
            shadowing.shadowedStage = Visible
        end
    })
end

--- @class ShadowingStage : number
--- @class Shadowed : ShadowingStage
Shadowed = 1
--- @class Visible : ShadowingStage
Visible = 2
--- @class Shading : ShadowingStage
Shading = 3
--- @class Deshading : ShadowingStage
Deshading = 4
