print("Solving day 13")

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

local found = nil
for _, bus in ipairs(buses) do
    if bus > 0 then
        local arrival = start + bus - (start % bus)
        if not found or (found.arrival > arrival) then
            found = { arrival = arrival, bus = bus }
        end
    end
end

print(string.format("Earliest bus %d arrived at %d, result is %d", found.bus, found.arrival, found.bus * (found.arrival - start)))

------

local function isValid(localBuses, timestamp)
    for i = 1, #localBuses do
        if localBuses[i] ~= 0 and ((timestamp + i - 1) % localBuses[i]) ~= 0 then return false end
    end
    return true
end

local maxBus = 0
local maxBusOffset = 0
for i = 1, #buses do
    if buses[i] > maxBus then
        maxBus = buses[i]
        maxBusOffset = i - 1
    end
end

print(string.format("Max busId is %d, offset %d", maxBus, maxBusOffset))

local base = 99999999749193
-- local base = 0
local candidate = 0
while true do
    base = base + maxBus
    candidate = base - maxBusOffset
    if isValid(buses, candidate) then break end
end

print(string.format("Found timestamp %d", candidate))
