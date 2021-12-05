print("Solving day 5")

local lines = {}
for line in io.lines("Day05.txt") do
    local x1, y1, x2, y2 = string.match(line, "(%d+),(%d+) .> (%d+),(%d+)")
    table.insert(lines, { x1 = tonumber(x1), y1 = tonumber(y1), x2 = tonumber(x2), y2 = tonumber(y2) })
end

local function calculateGridIndex(x, y)
    return y * 10000 + x
end

local function drawVertical(line, grid)
    local step = 1
    if line.y1 > line.y2 then step = -1 end
    for y = line.y1, line.y2, step do
        local gridIndex = calculateGridIndex(line.x1, y)
        grid[gridIndex] = (grid[gridIndex] or 0) + 1
    end
end

local function drawHorizontal(line, grid)
    local step = 1
    if line.x1 > line.x2 then step = -1 end
    for x = line.x1, line.x2, step do
        local gridIndex = calculateGridIndex(x, line.y1)
        grid[gridIndex] = (grid[gridIndex] or 0) + 1
    end
end

local function countOverlaps(grid)
    local count = 0
    for _, value in pairs(grid) do
        if value > 1 then count = count + 1 end
    end
    return count
end

local grid = {}
for _, line in ipairs(lines) do
    if line.x1 == line.x2 then
        drawVertical(line, grid)
    elseif line.y1 == line.y2 then
        drawHorizontal(line, grid)
    end
end

print("Overlaps for vertical & horizontal lines\t", countOverlaps(grid))

--------

local function drawDiagonal(line, grid)
    local stepX = 1
    if line.x1 > line.x2 then stepX = -1 end

    local stepY = 1
    if line.y1 > line.y2 then stepY = -1 end

    local y = line.y1
    for x = line.x1, line.x2, stepX do
        local gridIndex = calculateGridIndex(x, y)
        grid[gridIndex] = (grid[gridIndex] or 0) + 1
        y = y + stepY
    end
end

grid = {}
for _, line in ipairs(lines) do
    if line.x1 == line.x2 then
        drawVertical(line, grid)
    elseif line.y1 == line.y2 then
        drawHorizontal(line, grid)
    else
        drawDiagonal(line, grid)
    end
end

print("Overlaps for vertical, horizontal & diagonal lines", countOverlaps(grid))
