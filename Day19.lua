print("Solving day 19")

local function split(value, separator)
    local found = {}
    local index = 1
    while index <= #value do
        local indexStart, indexEnd = string.find(value, separator, index)
        if indexStart then
            table.insert(found, string.sub(value, index, indexStart - 1))
            index = indexEnd + 1
        else
            table.insert(found, string.sub(value, index))
            break
        end
    end
    return found
end

local lines = {}
for line in io.lines("Day19.txt") do
    table.insert(lines, line)
end

local rules = {}
local index = 1
while true do
    local line = lines[index]
    if line == "" then break end
    local id, rest = string.match(line, "^(%d+): (.*)$")
    if string.sub(rest, 1, 1) == '"' then
        rules[tonumber(id)] = { value = string.sub(rest, 2, 2) }
    else
        local children = {}
        for _, section in ipairs(split(rest, " | ")) do
            local child = {}
            for _, sectionNumber in ipairs(split(section, " ")) do
                table.insert(child, tonumber(sectionNumber))
            end
            table.insert(children, child)
        end
        rules[tonumber(id)] = { children = children }
    end
    index = index + 1
end

local function concatTables(targetTable, extensionTable)
    for i = 1, #extensionTable do
        table.insert(targetTable, extensionTable[i])
    end
end

local match = nil

local function matchSequence(line, current, sequence, sequenceIndex, depth)
    if sequenceIndex == #sequence then
        return match(line, current, sequence[sequenceIndex], depth + 1)
    else
        local matches = {}
        for _, matchEnd in ipairs(match(line, current, sequence[sequenceIndex], depth + 1)) do
            concatTables(matches, matchSequence(line, matchEnd, sequence, sequenceIndex + 1, depth))
        end
        return matches
    end
end

match = function (line, current, ruleId, depth)
    if depth > 50 then return {} end

    local rule = rules[ruleId]
    if rule.value then
        if string.sub(line, current, current) == rule.value then return { current + 1 }
        else return {} end
    end

    local matches = {}
    for childIndex = 1, #rule.children do
        concatTables(matches, matchSequence(line, current, rule.children[childIndex], 1, depth))
    end
    return matches
end

local matches = 0
for i = index + 1, #lines do
    for _, matchEnd in ipairs(match(lines[i], 1, 0, 1)) do
        if matchEnd and matchEnd == #lines[i] + 1 then matches = matches + 1 end
    end
end

print(string.format("Found %d matches", matches))

------

rules[8] = { children = { { 42 }, { 42, 8 } } }
rules[11] = { children = { { 42, 31 }, { 42, 11, 31 } } }

local loopMatches = 0
for i = index + 1, #lines do
    for _, matchEnd in ipairs(match(lines[i], 1, 0, 1)) do
        if matchEnd and matchEnd == #lines[i] + 1 then loopMatches = loopMatches + 1 end
    end
end

print(string.format("Found %d loop matches", loopMatches))
