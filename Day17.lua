print("Solving day 17")

local function calculateKey(x, y, z)
    return string.format("%d,%d,%d", x, y, z)
end

local cells = {}
local xParse = 0
local yParse = 0
local zParse = 0
for line in io.lines("Day17.txt") do
    xParse = #line
    for i = 1, #line do
        if string.sub(line, i, i) == "#" then cells[calculateKey(i - 1, yParse, zParse)] = true end
    end
    yParse = yParse + 1
end

local function countNeighbours(localCells, x, y, z)
    local neighbours = 0
    for zOffset = -1, 1 do
        for yOffset = -1, 1 do
            for xOffset = -1, 1 do
                if not (xOffset == 0 and yOffset == 0 and zOffset == 0) then
                    if localCells[calculateKey(x + xOffset, y + yOffset, z + zOffset)] then neighbours = neighbours + 1 end
                end
            end
        end
    end
    return neighbours
end

local function updateMinMax(localWorld, x, y, z)
    if x < localWorld.minX then localWorld.minX = x end
    if x > localWorld.maxX then localWorld.maxX = x end
    if y < localWorld.minY then localWorld.minY = y end
    if y > localWorld.maxY then localWorld.maxY = y end
    if z < localWorld.minZ then localWorld.minZ = z end
    if z > localWorld.maxZ then localWorld.maxZ = z end
end

local function tick(world)
    local newWorld = { minX = 999999999, maxX = -999999999, minY = 999999999, maxY = -999999999, minZ = 999999999, maxZ = -999999999, cells = {} }
    for z = world.minZ - 1, world.maxZ + 1 do
        for y = world.minY - 1, world.maxY + 1 do
            for x = world.minX - 1, world.maxX +1 do
                local neighbours = countNeighbours(world.cells, x, y, z)
                local key = calculateKey(x, y, z)
                -- print(string.format("Cell %d,%d,%d has %d neighbours (key %s)", x, y, z, neighbours, key))
                if world.cells[key] then -- cell is active
                    if neighbours == 2 or neighbours == 3 then
                        newWorld.cells[key] = true
                        updateMinMax(newWorld, x, y, z)
                    end
                else -- cell is inactive
                    if neighbours == 3 then
                        newWorld.cells[key] = true
                        updateMinMax(newWorld, x, y, z)
                    end
                end
            end
        end
    end
    return newWorld
end

local currentWorld = { minX = 0, maxX = xParse - 1, minY = 0, maxY = yParse - 1, minZ = 0, maxZ = 0, cells = cells }
for _ = 1, 6 do
    currentWorld = tick(currentWorld)
end

-- for z = currentWorld.minZ, currentWorld.maxZ do
--     print()
--     print(string.format("%d,%d,%d", currentWorld.minX, currentWorld.minY, z))
--     for y = currentWorld.minY, currentWorld.maxY do
--         local line = ""
--         for x = currentWorld.minX, currentWorld.maxX do
--             if currentWorld.cells[calculateKey(x, y, z)] then line = line .. "#"
--             else line = line .. "." end
--         end
--         print(line)
--     end
-- end

local count = 0
for _, _ in pairs(currentWorld.cells) do
    count = count + 1
end
print(string.format("Found %d active cells", count))

------

local function calculateKey4(x, y, z, w)
    return string.format("%d,%d,%d,%d", x, y, z, w)
end

cells = {}
xParse = 0
yParse = 0
for line in io.lines("Day17.txt") do
    xParse = #line
    for i = 1, #line do
        if string.sub(line, i, i) == "#" then cells[calculateKey4(i - 1, yParse, 0, 0)] = true end
    end
    yParse = yParse + 1
end

local function countNeighbours4(localCells, x, y, z, w)
    local neighbours = 0
    for wOffset = -1, 1 do
        for zOffset = -1, 1 do
            for yOffset = -1, 1 do
               for xOffset = -1, 1 do
                    if not (xOffset == 0 and yOffset == 0 and zOffset == 0 and wOffset == 0) then
                        if localCells[calculateKey4(x + xOffset, y + yOffset, z + zOffset, w + wOffset)] then neighbours = neighbours + 1 end
                    end
                end
            end
        end
    end
    return neighbours
end

local function updateMinMax4(localWorld, x, y, z, w)
    if x < localWorld.minX then localWorld.minX = x end
    if x > localWorld.maxX then localWorld.maxX = x end
    if y < localWorld.minY then localWorld.minY = y end
    if y > localWorld.maxY then localWorld.maxY = y end
    if z < localWorld.minZ then localWorld.minZ = z end
    if z > localWorld.maxZ then localWorld.maxZ = z end
    if w < localWorld.minW then localWorld.minW = w end
    if w > localWorld.maxW then localWorld.maxW = w end
end

local function tick4(world)
    local newWorld = { minX = 999999999, maxX = -999999999, minY = 999999999, maxY = -999999999, minZ = 999999999, maxZ = -999999999, minW = 999999999, maxW = -999999999, cells = {} }
    for w = world.minW - 1, world.maxW + 1 do
        for z = world.minZ - 1, world.maxZ + 1 do
            for y = world.minY - 1, world.maxY + 1 do
                for x = world.minX - 1, world.maxX +1 do
                    local neighbours = countNeighbours4(world.cells, x, y, z, w)
                    local key = calculateKey4(x, y, z, w)
                    -- print(string.format("Cell %d,%d,%d has %d neighbours (key %s)", x, y, z, neighbours, key))
                    if world.cells[key] then -- cell is active
                        if neighbours == 2 or neighbours == 3 then
                            newWorld.cells[key] = true
                            updateMinMax4(newWorld, x, y, z, w)
                        end
                    else -- cell is inactive
                        if neighbours == 3 then
                            newWorld.cells[key] = true
                            updateMinMax4(newWorld, x, y, z, w)
                        end
                    end
                end
            end
        end
    end
    return newWorld
end

local currentWorld4 = { minX = 0, maxX = xParse - 1, minY = 0, maxY = yParse - 1, minZ = 0, maxZ = 0, minW = 0, maxW = 0, cells = cells }
for _ = 1, 6 do
    currentWorld4 = tick4(currentWorld4)
end

count = 0
for _, _ in pairs(currentWorld4.cells) do
    count = count + 1
end
print(string.format("Found %d active cells", count))
