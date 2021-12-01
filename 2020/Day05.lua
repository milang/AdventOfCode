print("Solving day 5")

local function decodeNumber(value, startIndex, endIndex, charTrue)
    local result = 0
    for i = startIndex, endIndex, 1 do
        result = result * 2
        if string.sub(value, i, i) == charTrue then
            result = result + 1
        end
    end
    return result
end


local records = {}
local maxSeatId = 0
for line in io.lines("Day05.txt") do
    local row = decodeNumber(line, 1, 7, "B")
    local column = decodeNumber(line, 8, 10, "R")
    local seatId = row * 8 + column
    table.insert(records, { row = row, column = column, seatId = seatId })
    if maxSeatId < seatId then maxSeatId = seatId end
end

print(string.format("Maximum seat ID is %d", maxSeatId))

------

local seatIds = {}
for _, record in ipairs(records) do
    table.insert(seatIds, record.seatId)
end
table.sort(seatIds)

local lastSeatId = seatIds[1]
for i = 2, #seatIds do
    lastSeatId = lastSeatId + 1
    if seatIds[i] ~= lastSeatId then
        print(string.format("Your seat ID is %d", lastSeatId))
        break
    end
end
