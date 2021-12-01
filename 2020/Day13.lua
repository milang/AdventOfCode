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

local function isValid(localPairs, timestamp)
    for i = 3, #localPairs do
        if ((timestamp + localPairs[i].offset) % localPairs[i].bus) ~= 0 then return false end
    end
    return true
end

-- order (busID, offset) pairs from largest to smallest ID
local pairs = {}
for i = 1, #buses do
    if buses[i] > 0 then table.insert(pairs, { bus = buses[i], offset = i - 1 }) end
end
table.sort(pairs, function (a, b) return a.bus > b.bus end)

-- find the two largest bus IDs
local busA = (pairs[1]).bus
local busAOffset = (pairs[1]).offset
local busB = (pairs[2]).bus
local busBOffset = (pairs[2]).offset
print(string.format("Two largest busses are %d (offset %d) and %d (offset %d)", busA, busAOffset, busB, busBOffset))

local init = 0
if #arg > 0 then init = tonumber(arg[1]) end
local busAtime = (math.floor(init / busA) * busA) - busAOffset
local busBtime = (math.floor(init / busB) * busB) - busBOffset
local progress = 0
while true do
    if busAtime < busBtime then busAtime = busAtime + busA
    elseif busBtime < busAtime then busBtime = busBtime + busB
    else
        -- we found the first timestamp that satistfies the two
        -- largest bus IDs; from now on candidate timestamps repeat with
        -- period of "increment", try 'em all
        local increment = busA * busB
        while true do
            if isValid(pairs, busAtime) then break end
            busAtime = busAtime + increment
            local newProgress = math.floor(busAtime / 1000000000000)
            if newProgress > progress then
                progress = newProgress
                print(progress)
            end
        end
        break
    end
end

print(string.format("Found timestamp %d", busAtime))
