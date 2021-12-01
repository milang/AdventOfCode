print("Solving day 15")

local parsed = {}
for line in io.lines("Day15.txt") do
    table.insert(parsed, tonumber(line))
end

local function play(initial, turns)
    local known = {}
    for i = 1, #initial - 1 do
        known[initial[i]] = i
    end

    local lastNumber = initial[#initial]
    for turn = #initial + 1, turns do
        local found = known[lastNumber]
        known[lastNumber] = turn - 1
        if found then
            lastNumber = turn - 1 - found
        else
            lastNumber = 0
        end
        -- print(string.format("In turn %d saying %d", turn, lastNumber))
    end

    return lastNumber
end

print(string.format("2020th number spoken is %d", play(parsed, 2020)))

print(string.format("30000000th number spoken is %d", play(parsed, 30000000)))
