print("Solving day 23")

local parsedCups = {}
for line in io.lines("Day23_small.txt") do
    for i = 1, #line do
        table.insert(parsedCups, tonumber(string.sub(line, i, i)))
    end
end

-- local function play(startingCups, count, moves)
--     local cups = {}
--     for i = 1, #startingCups do cups[i] = startingCups[i] end
--     for i = #startingCups + 1, count do cups[i] = i end

--     local min = 1
--     local max = count
--     local currentIndex = 1

--     for move = 1, moves do
--         if move % 100 == 0 then print(math.floor(move / 100)) end

--         -- print(table.concat(cups, " "))
--         local currentCup = cups[currentIndex]
--         local c1, c2, c3
--         if currentIndex < (count - 2) then
--             c1 = table.remove(cups, currentIndex + 1)
--             c2 = table.remove(cups, currentIndex + 1)
--             c3 = table.remove(cups, currentIndex + 1)
--         elseif currentIndex == (count - 2) then
--             c1 = table.remove(cups, currentIndex + 1)
--             c2 = table.remove(cups, currentIndex + 1)
--             c3 = table.remove(cups, 1)
--         elseif currentIndex == (count - 1) then
--             c1 = table.remove(cups, currentIndex + 1)
--             c2 = table.remove(cups, 1)
--             c3 = table.remove(cups, 1)
--         else
--             c1 = table.remove(cups, 1)
--             c2 = table.remove(cups, 1)
--             c3 = table.remove(cups, 1)
--         end
--         local nextCup = currentCup - 1
--         if nextCup < min then nextCup = max end
--         while c1 == nextCup or c2 == nextCup or c3 == nextCup do
--             nextCup = nextCup - 1
--             if nextCup < min then nextCup = max end
--         end

--         local nextIndex = 1
--         for i = 1, #cups do
--             if cups[i] == nextCup then
--                 nextIndex = i
--                 break
--             end
--         end

--         table.insert(cups, nextIndex + 1, c3)
--         table.insert(cups, nextIndex + 1, c2)
--         table.insert(cups, nextIndex + 1, c1)

--         for i = 1, #cups do
--             if cups[i] == currentCup then currentIndex = i break end
--         end
--         currentIndex = (currentIndex % count) + 1
--     end
--     return cups
-- end

local function play2(startingCups, count, moves)
    local cups = {}
    for i = 1, #startingCups do cups[i] = startingCups[i] end
    for i = #startingCups + 1, count do cups[i] = i end

    local min = 1
    local max = count
    local currentIndex = 1

    local function nextIndex(i)
        return i % max + 1
    end

    for move = 1, moves do
        if move % 100 == 0 then print(math.floor(move / 100)) end

        -- print(table.concat(cups, " "))
        local currentCup = cups[currentIndex]
        local sourceIndex = nextIndex(currentIndex)
        local targetIndex = sourceIndex
        local c1 = cups[sourceIndex]
        sourceIndex = nextIndex(sourceIndex)
        local c2 = cups[sourceIndex]
        sourceIndex = nextIndex(sourceIndex)
        local c3 = cups[sourceIndex]
        sourceIndex = nextIndex(sourceIndex)

        local nextCup = currentCup - 1
        if nextCup < min then nextCup = max end
        while c1 == nextCup or c2 == nextCup or c3 == nextCup do
            nextCup = nextCup - 1
            if nextCup < min then nextCup = max end
        end

        while true do
            cups[targetIndex] = cups[sourceIndex]
            if (cups[targetIndex] == nextCup) then
                targetIndex = nextIndex(targetIndex)
                cups[targetIndex] = c1
                targetIndex = nextIndex(targetIndex)
                cups[targetIndex] = c2
                targetIndex = nextIndex(targetIndex)
                cups[targetIndex] = c3
                break
            end
            sourceIndex = nextIndex(sourceIndex)
            targetIndex = nextIndex(targetIndex)
        end

        currentIndex = nextIndex(currentIndex)
    end
    return cups
end

local resultIndex = nil
local resultCups = play2(parsedCups, 9, 100)
for i = 1, #resultCups do
    if resultCups[i] == 1 then resultIndex = i break end
end
local result = ""
for i = resultIndex + 1, #resultCups do
    result = result .. resultCups[i]
end
for i = 1, resultIndex - 1 do
    result = result .. resultCups[i]
end
print(string.format("Final sequence is %s", result))

------

-- local bigResultCups = play2(parsedCups, 1000000, 10000000)
-- for i = 1, #bigResultCups do
--     if bigResultCups[i] == 1 then resultIndex = i break end
-- end
-- print(bigResultCups[resultIndex + 1], bigResultCups[resultIndex + 2])
-- print(table.concat(bigResultCups, " "))
