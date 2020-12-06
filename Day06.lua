print("Solving day 6")

local groups = {}
local currentGroup = {}
local currentGroupLines = 0
for line in io.lines("Day06.txt") do
    if #line == 0 then
        currentGroup.lines = currentGroupLines
        table.insert(groups, currentGroup)
        currentGroup = {}
        currentGroupLines = 0
    else
        currentGroupLines = currentGroupLines + 1
        for i = 1, #line do
            local character = string.sub(line, i, i)
            local count = currentGroup[character]
            if count then
                currentGroup[character] = count + 1
            else
                currentGroup[character] = 1
            end
        end
    end
end

local overallCount = 0
for _, group in ipairs(groups) do
    for _, _ in pairs(group) do
        overallCount = overallCount + 1
    end
end

print(string.format("Overall count is %d", overallCount))

------

local overallBetterCount = 0
for _, group in ipairs(groups) do
    for character, characterCount in pairs(group) do
        if character ~= "lines" and characterCount == group.lines then
            overallBetterCount = overallBetterCount + 1
        end
    end
end

print(string.format("Overall better count is %d", overallBetterCount))
