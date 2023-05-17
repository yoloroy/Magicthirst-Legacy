require "src.common.util.iter"

--- Iterable.ofChildren
--- @generic T
--- @param group
--- @return Iterable
function Iterable.ofChildren(group)
    local result = Iterable:new {}
    for i = 1, group.numChildren do
        result[#result + 1] = group[i]
    end
    return result
end
