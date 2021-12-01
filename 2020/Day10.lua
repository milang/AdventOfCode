print("Solving day 10")

local adapters = {}
for line in io.lines("Day10.txt") do
    table.insert(adapters, tonumber(line))
end

table.sort(adapters)
table.insert(adapters, adapters[#adapters] + 3)

local ones = 0
local twos = 0
local threes = 0
local lastJoltage = 0
for i = 1, #adapters do
    local difference = adapters[i] - lastJoltage
    if difference == 1 then ones = ones + 1
    elseif difference == 2 then twos = twos + 1
    elseif difference == 3 then threes = threes + 1
    else error("Too different") end
    lastJoltage = adapters[i]
end

print(ones, twos, threes, string.format("Final number is %d", ones * threes))

------

-- first, count groups of consecutive numbers
local found = {}
local groupStart = 0
local lastNumber = 0
for i = 1, #adapters do
    lastNumber = lastNumber + 1
    if adapters[i] ~= lastNumber then
        -- end of group
        local groupLength = lastNumber - groupStart
        if groupLength > 2 then
            local foundItem = found[groupLength]
            if foundItem then found[groupLength] = foundItem + 1
            else found[groupLength] = 1 end
        end
        groupStart = adapters[i]
        lastNumber = adapters[i]
    end
end

-- by running the following I found that even the full
-- data set has only consecutive groups of 3, 4 and 5 numbers
-- group of 3 has only 2 combinations, group of 4 has 4 combinations
-- and group of 5 has 7 combinations; final number of combinations
-- is multiplication of combinations for each group, i.e.
-- if we have 3 groups of 3, it would be 2 * 2 * 2; for 3 groups
-- of 5 it would be 7 * 7 * 7
--
-- (also see Day10_notes.txt)
--
-- for key, value in pairs(found) do
--     print(key, value)
-- end
print(string.format("There are %d combinations", (2 ^ found[3]) * (4 ^ found[4]) * (7 ^ found[5])))
