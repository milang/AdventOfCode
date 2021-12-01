print("Solving day 16")

local lines = {}
for line in io.lines("Day16.txt") do
    table.insert(lines, line)
end

local ticketLine = 0
local fields = {}
for i = 1, #lines do
    if #lines[i] == 0 then
        ticketLine = i + 2
        break
    end
    local name, range1min, range1max, range2min, range2max = string.match(lines[i], "^([^:]+): (%d+)-(%d+) or (%d+)-(%d+)$")
    table.insert(fields, {
        name = name,
        range1 = { min = tonumber(range1min), max = tonumber(range1max) },
        range2 = { min = tonumber(range2min), max = tonumber(range2max) }
    })
end

local function parseTicket(line)
    local ticket = {}
    for number in string.gmatch(line, "[^,]+") do
        table.insert(ticket, tonumber(number))
    end
    return ticket
end

local ourTicket = parseTicket(lines[ticketLine])

local otherTickets = {}
for i = ticketLine + 3, #lines do
    table.insert(otherTickets, parseTicket(lines[i]))
end

local function checkField(localFields, value)
    for _, field in ipairs(localFields) do
        if value >= field.range1.min and value <= field.range1.max then return true, 0 end
        if value >= field.range2.min and value <= field.range2.max then return true, 0 end
    end
    return false, value
end

local function checkTicket(localFields, ticket)
    local ticketSuccess = true
    local ticketErrorRate = 0
    for _, value in ipairs(ticket) do
        local fieldSuccess, fieldErrorRate = checkField(localFields, value)
        ticketSuccess = ticketSuccess and fieldSuccess
        ticketErrorRate = ticketErrorRate + fieldErrorRate
    end
    return ticketSuccess, ticketErrorRate
end

local errorRate = 0
local validTickets = {}
table.insert(validTickets, ourTicket)
for _, otherTicket in ipairs(otherTickets) do
    local ticketSuccess, ticketErrorRate = checkTicket(fields, otherTicket)
    if ticketSuccess then table.insert(validTickets, otherTicket)
    else errorRate = errorRate + ticketErrorRate end
end

print(string.format("Error rate is %d", errorRate))

------

local candidates = {}
for i = 1, #ourTicket do
    local candidateFields = {}
    for _, field in pairs(fields) do
        table.insert(candidateFields, field)
    end
    table.insert(candidates, candidateFields)
end

-- remove candidate fields that do not meet criteria
print(string.format("Found %d valid tickets", #validTickets))
for ticketNumber, ticket in ipairs(validTickets) do
    for i = 1, #ticket do
        if #candidates[i] > 1 then
            local candidateFields = candidates[i]
            local value = ticket[i]
            local j = 1
            while true do
                local field = candidateFields[j]
                local isValid = false
                if value >= field.range1.min and value <= field.range1.max then isValid = true
                elseif value >= field.range2.min and value <= field.range2.max then isValid = true end
                if not isValid then
                    table.remove(candidateFields, j)
                else
                    j = j + 1
                end
                if j > #candidateFields then break end
            end
        end
    end

    -- local summary = string.format("%03d:", ticketNumber)
    -- for i = 1, #ticket do
    --     summary = summary .. #candidates[i] .. ", "
    -- end
    -- print(summary)
end

local function collectFinalizedFieldNames(localCandidates)
    local names = {}
    for _, candidate in ipairs(localCandidates) do
        if #candidate == 1 then table.insert(names, candidate[1].name) end
    end
    return names
end

local function isIn(collection, value)
    for _, collectionValue in ipairs(collection) do
        if collectionValue == value then return true end
    end
    return false
end

print("Cleaning up")
while true do
    local namesToRemove = collectFinalizedFieldNames(candidates)
    if #namesToRemove == #ourTicket then break end
    for _, candidateFields in ipairs(candidates) do
        if #candidateFields > 1 then
            local i = 1
            while true do
                if isIn(namesToRemove, candidateFields[i].name) then
                    table.remove(candidateFields, i)
                else
                    i = i + 1
                end
                if i > #candidateFields then break end
            end
        end
    end
end

print("Calculating departure fields")
local departures = 1
for i = 1, #candidates do
    if string.match(candidates[i][1].name, "^departure") then
        departures = departures * ourTicket[i]
    end
end
print(string.format("Departure fields yield %d", departures))
