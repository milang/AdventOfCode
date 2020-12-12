print("Solving day 12")

local actions = {}
for line in io.lines("Day12.txt") do
    local action, value = string.match(line, "(%a)(%d+)")
    table.insert(actions, { action = action, value = tonumber(value) })
end

local function move(targetFerry, direction, value)
    if direction == "N" then targetFerry.y = targetFerry.y + value
    elseif direction == "S" then targetFerry.y = targetFerry.y - value
    elseif direction == "E" then targetFerry.x = targetFerry.x + value
    elseif direction == "W" then targetFerry.x = targetFerry.x - value
    else error("Unknown direction") end
end

local function turnRight(targetFerry, numberOfTurns)
    if numberOfTurns == 0 then return end
    if targetFerry.heading == "N" then targetFerry.heading = "E"
    elseif targetFerry.heading == "E" then targetFerry.heading = "S"
    elseif targetFerry.heading == "S" then targetFerry.heading = "W"
    elseif targetFerry.heading == "W" then targetFerry.heading = "N"
    else error("Unknown direction") end
    return turnRight(targetFerry, numberOfTurns - 1)
end

local ferry = { x = 0, y = 0, heading = "E" }
for _, action in ipairs(actions) do
    if action.action == "F" then move(ferry, ferry.heading, action.value)
    elseif action.action == "N" or action.action == "S" or action.action == "E" or action.action == "W" then move(ferry, action.action, action.value)
    elseif action.action == "L" then turnRight(ferry, math.floor((360 - action.value) / 90))
    elseif action.action == "R" then turnRight(ferry, math.floor(action.value / 90))
    else error("Uknown action") end
end

print(string.format("Manhattan distance is %d", math.abs(ferry.x) + math.abs(ferry.y)))

------

local function turnRightAdvanced(targetFerry, numberOfTurns)
    if numberOfTurns == 0 then return end
    local tempx = targetFerry.wx
    targetFerry.wx = targetFerry.wy
    targetFerry.wy = -tempx
    turnRightAdvanced(targetFerry, numberOfTurns - 1)
end

local advancedFerry = { x = 0, y = 0, wx = 10, wy = 1 }
for _, action in ipairs(actions) do
    if action.action == "F" then
        advancedFerry.x = advancedFerry.x + (advancedFerry.wx * action.value)
        advancedFerry.y = advancedFerry.y + (advancedFerry.wy * action.value)
    elseif action.action == "N" then advancedFerry.wy = advancedFerry.wy + action.value
    elseif action.action == "S" then advancedFerry.wy = advancedFerry.wy - action.value
    elseif action.action == "E" then advancedFerry.wx = advancedFerry.wx + action.value
    elseif action.action == "W" then advancedFerry.wx = advancedFerry.wx - action.value
    elseif action.action == "L" then turnRightAdvanced(advancedFerry, math.floor((360 - (action.value % 360)) / 90))
    elseif action.action == "R" then turnRightAdvanced(advancedFerry, math.floor((action.value % 360) / 90))
    else error("Uknown action") end
end

print(string.format("Advanced Manhattan distance is %d", math.abs(advancedFerry.x) + math.abs(advancedFerry.y)))
