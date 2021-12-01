print("Solving day 1")

local parsedNumbers = {}
for line in io.lines("Day01.txt") do
    table.insert(parsedNumbers, tonumber(line))
end

local function countIncreases(array)
    local count = 0
    for i = 1, #array - 1, 1 do
        if array[i] < array[i + 1] then
            count = count + 1
        end
    end

    return count
end

local result1 = countIncreases(parsedNumbers)
print(string.format("Number of increases: %d", result1))

---------

local sums = {}
for i = 1, #parsedNumbers - 2, 1 do
    table.insert(sums, parsedNumbers[i] + parsedNumbers[i + 1] + parsedNumbers[i + 2])
end

local result2 = countIncreases(sums)
print(string.format("Number of sum increases: %d", result2))
