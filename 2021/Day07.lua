print("Solving day 7")

local positions = {}
local min = nil
local max = nil
for line in io.lines("Day07.txt") do
    for position in string.gmatch(line, "([^,]+)") do
        local p = tonumber(position)
        table.insert(positions, p)
        if not min or p < min then min = p end
        if not max or p > max then max = p end
    end
end

local function calculateFuelNeeded(positions, index, costFunction)
    local fuel = 0
    for _, position in ipairs(positions) do
        fuel = fuel + costFunction(math.abs(index - position))
    end
    return fuel
end

local function findMinimum(positions, costFunction)
    local minimum = nil
    for i = min, max, 1 do
        local fuel = calculateFuelNeeded(positions, i, costFunction)
        if not minimum or minimum.fuel > fuel then
            minimum = { fuel = fuel, index = i }
        end
    end
    return minimum
end

local function linearCost(distance)
    return distance
end

local minimum = findMinimum(positions, linearCost)
print(string.format("Linear cost has optimal index %d, needs %d fuel", minimum.index, minimum.fuel))

---

local costs = { 1 }
costs[0] = 0
for i = 2, max, 1 do
    costs[i] = costs[i-1] + i
end

local function nonLinearCost(distance)
    return costs[distance]
end

minimum = findMinimum(positions, nonLinearCost)
print(string.format("Non-linear cost has optimal index %d, needs %d fuel", minimum.index, minimum.fuel))
