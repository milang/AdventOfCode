print("Solving day 6")

local allFish = {}
for line in io.lines("Day06.txt") do
    for fish in string.gmatch(line, "([^,]+)") do
        table.insert(allFish, { daysLeft = tonumber(fish), count = 1 })
    end
end

local function countFish(collection)
    local totalFish = 0
    for _, fish in ipairs(collection) do
        totalFish = totalFish + fish.count
    end
    return totalFish
end

for day = 1, 256, 1 do
    local newFishCounter = 0
    for _, fish in ipairs(allFish) do
        if fish.daysLeft == 0 then
            fish.daysLeft = 6
            newFishCounter = newFishCounter + fish.count
        else
            fish.daysLeft = fish.daysLeft - 1
        end
    end
    if newFishCounter > 0 then
        table.insert(allFish, { daysLeft = 8, count = newFishCounter })
    end
    if day == 80 then
        print("After 80 days", countFish(allFish))
    end
end

print("After 256 days", countFish(allFish))
