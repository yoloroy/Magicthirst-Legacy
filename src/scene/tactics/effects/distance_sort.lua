--- distanceSort
---
--- sorts
--- @param layer
function distanceSort(layer) -- TODO refactor using Iterable class (required Iterable:groupBy method, just by filters it will not be effective)
    local bottom = {}
    local onTop = {}
    local hasHeight = {}
    for i = 1, layer.numChildren do
        if layer[i].zType == HasHeight then
            hasHeight[#hasHeight + 1] = layer[i]
        elseif layer[i].zType == OnTop then
            onTop[#onTop + 1] = layer[i]
        elseif layer[i].zType == Bottom then
            bottom[#bottom + 1] = layer[i]
        end
    end
    table.sort(hasHeight, function(a, b) return a.y < b.y end)
    for i = 1, #bottom do layer:insert(hasHeight[i]) end
    for i = 1, #hasHeight do layer:insert(hasHeight[i]) end
    for i = 1, #onTop do layer:insert(onTop[i]) end
end

--- @class ZType : string
--- @class HasHeight : ZType
HasHeight = "HasHeight"
--- @class OnTop : ZType
OnTop = "OnTop"
--- @class Bottom : ZType
Bottom = "Bottom"
