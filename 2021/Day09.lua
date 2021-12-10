print("Solving day 9")
local heightMap = {}
local heightMapWidth = nil
for line in io.lines("Day09.txt") do
    if not heightMapWidth then heightMapWidth = #line end
    for i = 1, #line, 1 do
        table.insert(heightMap, tonumber(string.sub(line, i, i)))
    end
end

local function findHeight(map, width, x, y)
    if x < 0 or x >= width or y < 0 then return 9, nil end
    local index = (y * width + x) + 1
    if index < 1 or index > #map then return 9, nil end
    return map[index], index
end

local function measureBasin(map, width, x, y, visited)
    local height, index = findHeight(map, width, x, y)
    if height == 9 or visited[index] then return 0 end
    -- print("Visiting", x, y, height, index)
    visited[index] = true
    local size = 1
    size = size + measureBasin(map, width, x - 1, y, visited)
    size = size + measureBasin(map, width, x + 1, y, visited)
    size = size + measureBasin(map, width, x, y - 1, visited)
    size = size + measureBasin(map, width, x, y + 1, visited)
    return size
end

local riskLevel = 0
local basinSizes = {}
local basinVisited = {}
for index, height in ipairs(heightMap) do
    if height < 9 then
        local x = (index - 1) % heightMapWidth
        local y = math.floor((index - 1) / heightMapWidth)
        if height < findHeight(heightMap, heightMapWidth, x - 1, y)
        and height < findHeight(heightMap, heightMapWidth, x + 1, y)
        and height < findHeight(heightMap, heightMapWidth, x, y - 1)
        and height < findHeight(heightMap, heightMapWidth, x, y + 1) then
            riskLevel = riskLevel + height + 1
            table.insert(basinSizes, measureBasin(heightMap, heightMapWidth, x, y, basinVisited))
        end
    end
end

table.sort(basinSizes)
print(riskLevel, basinSizes[#basinSizes] * basinSizes[#basinSizes - 1] * basinSizes[#basinSizes - 2])
