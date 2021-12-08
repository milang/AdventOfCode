print("Solving day 8")

local function countOccurences(collection)
    local result = {}
    for _, item in ipairs(collection) do
        for i = 1, #item, 1 do
            local letter = string.sub(item, i, i)
            local occurences = result[letter] or 0
            result[letter] = occurences + 1
        end
    end
    return result
end

local function findKeyForValue(map, value)
    for key, mappedValue in pairs(map) do
        if value == mappedValue then return key end
    end
    error("Could not find value")
end

local function unscramble(p2, p3, p4, p5List, p6List)
    local result = {}

    local o = countOccurences({ p2, p3 })
    result["a"] = findKeyForValue(o, 1) -- "a" segment will be the only one to have 1 occurence, "c" and "f" will have 2 occurences

    o = countOccurences({ p5List[1], p5List[2], p5List[3], p4 })
    o[result["a"]] = nil
    result["d"] = findKeyForValue(o, 4)
    result["e"] = findKeyForValue(o, 1)

    o = countOccurences(p5List)
    o[result["a"]] = nil
    o[result["d"]] = nil
    o[result["e"]] = nil
    result["b"] = findKeyForValue(o, 1)
    result["g"] = findKeyForValue(o, 3)

    o = countOccurences(p6List)
    o[result["a"]] = nil
    o[result["b"]] = nil
    o[result["d"]] = nil
    o[result["e"]] = nil
    o[result["g"]] = nil
    result["c"] = findKeyForValue(o, 2)

    o = countOccurences({ p2 })
    o[result["c"]] = nil
    result["f"] = findKeyForValue(o, 1)

    return result
end

local simpleCount = 0
local sum = 0
for line in io.lines("Day08.txt") do
    local input, output = string.match(line, "(.+) | (.+)")
    local p2, p3, p4 = nil, nil, nil
    local p5List = {}
    local p6List = {}
    for inputPattern in string.gmatch(input, "([^ ]+)") do
        if #inputPattern == 2 then p2 = inputPattern
        elseif #inputPattern == 3 then p3 = inputPattern
        elseif #inputPattern == 4 then p4 = inputPattern
        elseif #inputPattern == 5 then table.insert(p5List, inputPattern)
        elseif #inputPattern == 6 then table.insert(p6List, inputPattern) end
    end

    local outputValue = 0
    local mapping = unscramble(p2, p3, p4, p5List, p6List)
    for outputPattern in string.gmatch(output, "([^ ]+)") do
        local outputDigitValue = nil
        if #outputPattern == 2 then
            simpleCount = simpleCount + 1
            outputDigitValue = 1
        elseif #outputPattern == 3 then
            simpleCount = simpleCount + 1
            outputDigitValue = 7
        elseif #outputPattern == 4 then
            simpleCount = simpleCount + 1
            outputDigitValue = 4
        elseif #outputPattern == 7 then
            simpleCount = simpleCount + 1
            outputDigitValue = 8
        else
            local decodedOutputPatternList = {}
            for i = 1, #outputPattern, 1 do
                table.insert(decodedOutputPatternList, findKeyForValue(mapping, string.sub(outputPattern, i, i)))
            end
            table.sort(decodedOutputPatternList)
            local decodedOutputPattern = table.concat(decodedOutputPatternList)
            if decodedOutputPattern == "abcefg" then
                outputDigitValue = 0
            elseif decodedOutputPattern == "acdeg" then
                outputDigitValue = 2
            elseif decodedOutputPattern == "acdfg" then
                outputDigitValue = 3
            elseif decodedOutputPattern == "abdfg" then
                outputDigitValue = 5
            elseif decodedOutputPattern == "abdefg" then
                outputDigitValue = 6
            elseif decodedOutputPattern == "abcdfg" then
                outputDigitValue = 9
            else
                error("Unrecognized pattern")
            end
        end
        outputValue = outputValue * 10 + outputDigitValue
    end
    sum = sum + outputValue
end
print(simpleCount, sum)
