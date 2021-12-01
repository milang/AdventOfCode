print("Solving day 9")

local parsedNumbers = {}
for line in io.lines("Day09.txt") do
    table.insert(parsedNumbers, tonumber(line))
end

local function isValid(numbers, preamble, start)
    local searchingFor = numbers[start + preamble]
    for i = start, start + preamble - 2 do
        for j = i + 1, start + preamble - 1 do
            if numbers[i] + numbers[j] == searchingFor then return true end
        end
    end
    return false
end

local preamble = 25
local found = nil
for i = 1, #parsedNumbers do
    if not isValid(parsedNumbers, preamble, i) then
        found = parsedNumbers[i + preamble]
        break
    end
end

print(string.format("Found %d", found))

------

local weakness = nil
for i = 1, #parsedNumbers do
    local sum = 0
    local min = 99999999999999
    local max = -99999999999999
    local j = i
    while true do
        local n = parsedNumbers[j]
        if (n < min) then min = n end
        if (n > max) then max = n end
        sum = sum + n
        if sum == found then
            weakness = min + max
            break
        elseif sum > found then
            break
        end
        j = j + 1
    end
    if weakness then break end
end

print(string.format("Found weakness %d", weakness))
