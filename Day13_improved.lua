print("Solving day 13, part 2 improved")

local lines = {}
for line in io.lines("Day13.txt") do
    table.insert(lines, line)
end

local start = tonumber(lines[1])
local buses = {}
for bus in string.gmatch(lines[2], "[^,]+") do
    if bus == "x" then table.insert(buses, 0)
    else table.insert(buses, tonumber(bus)) end
end

-- order (busID, offset) pairs from largest to smallest ID
local pairs = {}
for i = 1, #buses do
    if buses[i] > 0 then table.insert(pairs, { bus = buses[i], offset = i - 1 }) end
end
table.sort(pairs, function (a, b) return a.bus > b.bus end)

-- we rely on the fact that all "bus IDs" are prime numbers,
-- thus there are no shared factors between them
local delta = pairs[1].bus
local candidate = delta - pairs[1].offset
local nextIndex = 2
while true do
    if (candidate + pairs[nextIndex].offset) % pairs[nextIndex].bus == 0 then
        if nextIndex == #pairs then break end
        delta = delta * pairs[nextIndex].bus
        nextIndex = nextIndex + 1
    else
        candidate = candidate + delta
    end
end

print(string.format("Found timestamp %d", candidate))
