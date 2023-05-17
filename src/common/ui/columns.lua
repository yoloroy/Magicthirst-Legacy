--- ## display.newColumns
--- Creates row of sequentially placed objects,
---  from left to right,
---  inserts [objects] into new group,
---  positions them and places this group into desired position
--- @param parent 'object' | nil
--- @param positionTopLeft XY
--- @param objects 'object'[]
--- @param background 'object'
--- @return table
function display.newRow(parent, positionTopLeft, objects, background)
    --- @type table
    local row = display.newGroup()
    if background ~= nil then
        row:insert(background)
    end

    local accX = 0
    for _, object in ipairs(objects) do
        row:insert(object)
        object.x = accX + object.width / 2
        object.y = object.height / 2
        accX = accX + object.width
    end

    if parent ~= nil then parent:insert(row) end
    row.x = positionTopLeft.x
    row.y = positionTopLeft.y

    if background ~= nil then
        background.width = row.width
        background.height = row.height
        background.x = background.width / 2
        background.y = background.height / 2
    end
    return row
end
