print("Solving day 14")

local parsedProgram = {}
for line in io.lines("Day14.txt") do
    table.insert(parsedProgram, line)
end

local function convert(bits)
    local result = 0
    for _, value in ipairs(bits) do
        result = result * 2
        if value == 1 then result = result + 1 end
    end
    return result
end

local function createFloatingBit(index)
    local additions = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
    local removals =  { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }
    additions[index] = 1
    removals[index] = 0
    return { on = convert(additions), off = convert(removals) }
end

local function readMask(line)
    local additions = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
    local removals =  { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }
    local floating = {}
    for i = 8, #line do
        local char = string.sub(line, i, i)
        if char == "1" then additions[i - 7] = 1
        elseif char == "0" then removals[i - 7] = 0
        else table.insert(floating, createFloatingBit(i - 7)) end
    end
    return convert(additions), convert(removals), floating
end

local memory = {}
local additions = 0
local removals = 0
for i = 1, #parsedProgram do
    local line = parsedProgram[i]
    if string.match(line, "^mask = ") then additions, removals = readMask(line)
    else
        local address, value = string.match(line, "^mem%[(%d+)%] = (%d+)")
        value = (tonumber(value) | additions) & removals
        memory[tonumber(address)] = value
    end
end

local sum = 0
for _, value in pairs(memory) do
    sum = sum + value
end

print(string.format("Sum is %d", sum))

------

local function applyFloatingBits(localMemory, address, value, localFloating, index)
    if index > #localFloating then localMemory[address] = value return end
    address = address & localFloating[index].off
    applyFloatingBits(localMemory, address, value, localFloating, index + 1)
    address = address | localFloating[index].on
    applyFloatingBits(localMemory, address, value, localFloating, index + 1)
end

memory = {}
additions = 0
local floating = nil
for i = 1, #parsedProgram do
    local line = parsedProgram[i]
    if string.match(line, "^mask = ") then
        additions, _, floating = readMask(line)
        if #floating == 0 then error("No floating bits") end
    else
        local address, value = string.match(line, "^mem%[(%d+)%] = (%d+)")
        value = tonumber(value)
        address = tonumber(address) | additions
        applyFloatingBits(memory, address, value, floating, 1)
    end
end

sum = 0
for _, value in pairs(memory) do
    sum = sum + value
end

print(string.format("Advanced sum is %d", sum))
