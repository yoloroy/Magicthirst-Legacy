--- table.insertAll
--- @generic T
--- @param a T[]
--- @param b T[]
function table.insertAll(a, b)
    for _, v in pairs(b) do
        table.insert(a, v)
    end
end

--- table.contains
--- @generic T
--- @param array T[]
--- @param value T
function table.contains(array, value)
    return table.indexOf(array, value) ~= nil
end

--- table.removeValue
--- @overload fun(array: T[], value: T)
--- @generic T
--- @param array T[]
--- @param value T
--- @param all boolean
function table.removeValue(array, value, all)
    if all then
        local index = table.indexOf(array, value)
        while index ~= nil do
            table.remove(array, index)
            index = table.indexOf(array, value)
        end
    else
        table.remove(array, table.indexOf(array, value))
    end
end

--- table.indexOf
--- @generic T
--- @param array T[]
--- @param value T
function table.indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

--- table.intersects
--- @generic T
--- @param a T[]
--- @param b T[]
--- @return boolean true if a contains any of values from b
function table.isIntersects(a, b)
    for _, v in ipairs(a) do
        if table.indexOf(b, v) ~= nil then
            return true
        end
    end
    return false
end

--- keysOf
--- @param _table table
function table.keysOf(_table)
    local result = {}
    for k, _ in pairs(_table) do
        table.insert(result, k)
    end
    return result
end

--- table.containsKey
--- @param a table
--- @param key
function table.containsKey(a, key)
    return table.contains(table.keysOf(a), key)
end
