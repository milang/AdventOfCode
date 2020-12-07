print("Solving day 7")

local function nextChildBag(value, bagsSoFar)
    if value == "no other bags." then
        return bagsSoFar
    else
        local quantity, color = string.match(value, "(%d+) ([%a ]+) bags?")
        bagsSoFar[color] = tonumber(quantity)

        local separator = string.find(value, ",")
        if separator then
            return nextChildBag(string.sub(value, separator + 2), bagsSoFar)
        end

        return bagsSoFar
    end
end

local parsedColors = {}
for line in io.lines("Day07.txt") do
    local color, childBagsSpec = string.match(line, "^([%a ]+) bags? contain (.+)$")
    parsedColors[color] = nextChildBag(childBagsSpec, {})
end

local function isIn(array, value)
    for _, valueInArray in ipairs(array) do
        if valueInArray == value then return true end
    end
    return false
end

local function hasChildBag(array, childBags)
    for _, foundColor in ipairs(array) do
        if childBags[foundColor] then return true end
    end
    return false
end

local function search(colors, foundSoFar)
    for color, childBags in pairs(colors) do
        if not isIn(foundSoFar, color) then
            if hasChildBag(foundSoFar, childBags) then
                table.insert(foundSoFar, color)
                return search(colors, foundSoFar)
            end
        end
    end
    return foundSoFar
end

local result = search(parsedColors, { "shiny gold" })
print(string.format("%d bag colors can contain at least one shiny gold bag", #result - 1))

------

local function count(colors, color)
    local result = 1
    local colorEntry = colors[color]
    for childColor, childQuantity in pairs(colorEntry) do
        result = result + (childQuantity * count(colors, childColor))
    end
    return result
end

print(string.format("Your bag requires %d additional bags inside", count(parsedColors, "shiny gold") - 1))
