print("Solving day 23")

local parsedCups = {}
for line in io.lines("Day23.txt") do
    for i = 1, #line do
        table.insert(parsedCups, tonumber(string.sub(line, i, i)))
    end
end

local function play3(startingCups, count, moves)
    local min = 1
    local max = count

    local sequence = {}
    for i = 2, #startingCups do
        sequence[startingCups[i - 1]] = startingCups[i]
    end
    if count > #startingCups then
        sequence[startingCups[#startingCups]] = #startingCups + 1
        for i = #startingCups + 2, count do
             sequence[i - 1] = i
        end
        sequence[count] = startingCups[1] -- loop the sequence to the beginning
    else
        sequence[startingCups[#startingCups]] = startingCups[1] -- loop the sequence to the beginning
    end

    local currentCup = startingCups[1]
    for _ = 1, moves do
        local c1 = sequence[currentCup]
        local c2 = sequence[c1]
        local c3 = sequence[c2]
        sequence[currentCup] = sequence[c3]

        local insertionCup = currentCup
        while true do
            insertionCup = insertionCup - 1
            if insertionCup < min then insertionCup = max end
            if c1 ~= insertionCup and c2 ~= insertionCup and c3 ~= insertionCup then break end
        end

        local postInsertionCup = sequence[insertionCup]
        sequence[insertionCup] = c1
        sequence[c3] = postInsertionCup

        currentCup = sequence[currentCup]
    end
    return sequence
end

local resultSequence = play3(parsedCups, 9, 10)
local resultCup = resultSequence[1]
local result = ""
while true do
    result = result .. resultCup
    resultCup = resultSequence[resultCup]
    if resultCup == 1 then break end
end
print(string.format("Final sequence is %s", result))

------

local bigResultSequence = play3(parsedCups, 1000000, 10000000)
local a = bigResultSequence[1]
local b = bigResultSequence[a]
print(string.format("Product of cups-with-stars labels is %d", a * b))
