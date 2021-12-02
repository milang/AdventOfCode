print("Solving day 2")

local instructions = {}
for line in io.lines("Day02.txt") do
    local instruction, value = string.match(line, "(%a+) (%d+)")
    if (instruction == "forward") then
        table.insert(instructions, { x = tonumber(value), y = 0 })
    elseif (instruction == "down") then
        table.insert(instructions, { x = 0, y = tonumber(value) })
    elseif (instruction == "up") then
        table.insert(instructions, { x = 0, y = -tonumber(value) })
    else
        error("Unknown instruction")
    end
end

local position = { x = 0, y = 0 }

for i = 1, #instructions, 1 do
    position.x = position.x + instructions[i].x
    position.y = position.y + instructions[i].y
end
print(position.x, position.y, position.x * position.y)

--------

local aimedPosition = { x = 0, y = 0, aim = 0 }
for i = 1, #instructions, 1 do
    if (instructions[i].x == 0) then
        aimedPosition.aim = aimedPosition.aim + instructions[i].y
    else
        aimedPosition.x = aimedPosition.x + instructions[i].x
        aimedPosition.y = aimedPosition.y + (aimedPosition.aim * instructions[i].x)
    end
end
print(aimedPosition.x, aimedPosition.y, aimedPosition.x * aimedPosition.y)

-- local function countIncreases(array)
--     local count = 0
--     for i = 1, #array - 1, 1 do
--         if array[i] < array[i + 1] then
--             count = count + 1
--         end
--     end

--     return count
-- end

-- local result1 = countIncreases(parsedNumbers)
-- print(string.format("Number of increases: %d", result1))

-- ---------

-- local sums = {}
-- for i = 1, #parsedNumbers - 2, 1 do
--     table.insert(sums, parsedNumbers[i] + parsedNumbers[i + 1] + parsedNumbers[i + 2])
-- end

-- local result2 = countIncreases(sums)
-- print(string.format("Number of sum increases: %d", result2))
