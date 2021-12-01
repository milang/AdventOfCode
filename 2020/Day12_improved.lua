print("Solving day 12")

local actions = {}
for line in io.lines("Day12.txt") do
    local action, value = string.match(line, "(%a)(%d+)")
    table.insert(actions, { action = action, value = tonumber(value) })
end

local function turnRight(targetFerry, numberOfTurns)
    if numberOfTurns == 0 then return end
    local tempx = targetFerry.wx
    targetFerry.wx = targetFerry.wy
    targetFerry.wy = -tempx
    turnRight(targetFerry, numberOfTurns - 1)
end

local ferry = { x = 0, y = 0, wx = 1, wy = 0 }
for _, action in ipairs(actions) do
    if action.action == "F" then
        ferry.x = ferry.x + ferry.wx * action.value
        ferry.y = ferry.y + ferry.wy * action.value
    elseif action.action == "S" then ferry.y = ferry.y - action.value
    elseif action.action == "N" then ferry.y = ferry.y + action.value
    elseif action.action == "E" then ferry.x = ferry.x + action.value
    elseif action.action == "W" then ferry.x = ferry.x - action.value
    elseif action.action == "L" then turnRight(ferry, math.floor((360 - action.value) / 90))
    elseif action.action == "R" then turnRight(ferry, math.floor(action.value / 90))
    else error("Uknown action") end
end

print(string.format("Manhattan distance is %d", math.abs(ferry.x) + math.abs(ferry.y)))

------

local advancedFerry = { x = 0, y = 0, wx = 10, wy = 1 }
for _, action in ipairs(actions) do
    if action.action == "F" then
        advancedFerry.x = advancedFerry.x + (advancedFerry.wx * action.value)
        advancedFerry.y = advancedFerry.y + (advancedFerry.wy * action.value)
    elseif action.action == "N" then advancedFerry.wy = advancedFerry.wy + action.value
    elseif action.action == "S" then advancedFerry.wy = advancedFerry.wy - action.value
    elseif action.action == "E" then advancedFerry.wx = advancedFerry.wx + action.value
    elseif action.action == "W" then advancedFerry.wx = advancedFerry.wx - action.value
    elseif action.action == "L" then turnRight(advancedFerry, math.floor((360 - action.value) / 90))
    elseif action.action == "R" then turnRight(advancedFerry, math.floor(action.value / 90))
    else error("Uknown action") end
end

print(string.format("Advanced Manhattan distance is %d", math.abs(advancedFerry.x) + math.abs(advancedFerry.y)))
