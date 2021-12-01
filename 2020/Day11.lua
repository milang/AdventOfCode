print("Solving day 11")

local parsedArea = {}
for line in io.lines("Day11.txt") do
    local row = {}
    for i = 1, #line do
        row[i] = string.byte(line, i)
    end
    table.insert(parsedArea, row)
end

local function isOccupied(area, x, y, offsetX, offsetY, followFloor)
    local xx = x
    local yy = y
    while true do
        xx = xx + offsetX
        yy = yy + offsetY
        if xx < 1 or xx > #(area[y]) then return 0 end
        if yy < 1 or yy > #area then return 0 end
        if area[yy][xx] == 35 then return 1 end
        if area[yy][xx] == 76 then return 0 end
        if not followFloor then return 0 end
    end
end

local function countAdjacentOccupied(area, x, y, followFloor)
    return 0
        + isOccupied(area, x, y, -1, -1, followFloor)
        + isOccupied(area, x, y,  0, -1, followFloor)
        + isOccupied(area, x, y,  1, -1, followFloor)
        + isOccupied(area, x, y, -1,  0, followFloor)
        + isOccupied(area, x, y,  1,  0, followFloor)
        + isOccupied(area, x, y, -1,  1, followFloor)
        + isOccupied(area, x, y,  0,  1, followFloor)
        + isOccupied(area, x, y,  1,  1, followFloor)
end

local function tick(area, followFloor)
    local newArea = {}
    local occupiedLimit = 4
    if followFloor then occupiedLimit = 5 end

    for y = 1, #area do
        local row = area[y]
        local newRow = {}
        for x = 1, #row do
            local seat = row[x]
            if seat == 46 then -- floor
                newRow[x] = 46
            elseif seat == 76 then -- empty
                -- if no adjacent occupied seats, become occupied
                if countAdjacentOccupied(area, x, y, followFloor) == 0 then newRow[x] = 35
                else newRow[x] = 76 end
            else -- occupied
                -- if 4 (or 5 when following floor) or more adjacent occupied seats, become empty
                if countAdjacentOccupied(area, x, y, followFloor) >= occupiedLimit then newRow[x] = 76
                else newRow[x] = 35 end
            end
        end
        table.insert(newArea, newRow)
    end
    return newArea
end

local function areSame(area1, area2)
    for y = 1, #area1 do
        local row1 = area1[y]
        local row2 = area2[y]
        for x = 1, #row1 do
            if row1[x] ~= row2[x] then return false end
        end
    end
    return true
end

local function countOccupied(area)
    local count = 0
    for y = 1, #area do
        local row = area[y]
        for x = 1, #row do
            if row[x] == 35 then count = count + 1 end
        end
    end
    return count
end

local lastArea = parsedArea
while true do
    local newArea = tick(lastArea, false)
    if areSame(lastArea, newArea) then break end
    lastArea = newArea
end

print(string.format("There are %d occupied seats", countOccupied(lastArea)))

------

lastArea = parsedArea
while true do
    local newArea = tick(lastArea, true)

    -- print("---")
    -- for y = 1, #newArea do
    --     local line = ""
    --     for x = 1, #(newArea[1]) do
    --         line = line .. string.char(newArea[y][x])
    --     end
    --     print(line)
    -- end

    if areSame(lastArea, newArea) then break end
    lastArea = newArea
end

print(string.format("There are %d occupied seats when following floor", countOccupied(lastArea)))
