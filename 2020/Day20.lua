print("Solving day 20")

local lines = {}
for line in io.lines("Day20.txt") do
    table.insert(lines, line)
end

local tileList = {}
for i = 1, #lines, 12 do
    local id = tonumber(string.match(lines[i], "^Tile (%d+):$"))
    local tileRows = {}
    for j = i + 1, i + 10 do
        local tileRow = {}
        local tileLine = lines[j]
        for k = 1, #tileLine do
            if string.sub(tileLine, k, k) == "#" then tileRow[k] = 1
            else tileRow[k] = 0 end
        end
        table.insert(tileRows, tileRow)
    end
    table.insert(tileList, { id = id, variant = 1, rows = tileRows })
end

local function rotateRight(tile, variant, side)
    local rows = {}
    for _ = 1, side do table.insert(rows, {}) end
    for y = 1, side do
        for x = 1, side do
            rows[x][side - y + 1] = tile.rows[y][x]
        end
    end
    return { id = tile.id, variant = variant, rows = rows }
end

local function flipHorizontally(tile, variant, side)
    local rows = {}
    for _ = 1, side do table.insert(rows, {}) end
    for y = 1, side do
        for x = 1, side do
            rows[y][side - x + 1] = tile.rows[y][x]
        end
    end
    return { id = tile.id, variant = variant, rows = rows }
end

local function binToNumber(bin)
    local result = 0
    for i = 1, #bin do
        result = result * 2
        if bin[i] == 1 then result = result | 1 end
    end
    return result
end

local function calculateEdges(tile)
    tile.top = binToNumber(tile.rows[1])
    tile.bottom = binToNumber(tile.rows[10])
    tile.left = binToNumber({ tile.rows[1][1], tile.rows[2][1], tile.rows[3][1], tile.rows[4][1], tile.rows[5][1], tile.rows[6][1], tile.rows[7][1], tile.rows[8][1], tile.rows[9][1], tile.rows[10][1] })
    tile.right = binToNumber({ tile.rows[1][10], tile.rows[2][10], tile.rows[3][10], tile.rows[4][10], tile.rows[5][10], tile.rows[6][10], tile.rows[7][10], tile.rows[8][10], tile.rows[9][10], tile.rows[10][10] })
    return tile
end

local side = math.floor(math.sqrt(#tileList))
local tileVariants = {}
for i = 1, #tileList do
    local tile = tileList[i]
    local variants = { calculateEdges(tile) }
    for j = 2, 4 do
        tile = rotateRight(tile, j, 10)
        table.insert(variants, calculateEdges(tile))
    end
    for j = 5, 8 do
        tile = flipHorizontally(variants[j - 4], j, 10)
        table.insert(variants, calculateEdges(tile))
    end
    tileVariants[tile.id] = variants
end

local function cloneTable(source)
    local target = {}
    for key, value in pairs(source) do
        target[key] = value
    end
    return target
end

local function key(x, y)
    return string.format("%d,%d", x, y)
end

-- local function printImageIds(image, side)
--     print("~~~")
--     for y = 1, side do
--         local out = ""
--         for x = 1, side do
--             local tile = image[key(x, y)]
--             if tile then
--                 out = out .. string.format("%d,%d | ", tile.id, tile.variant)
--             else
--                 out = out .. "----,- | "
--             end
--         end
--         print(out)
--     end
-- end

local function fit(candidates, index, x, y, side, image)
    local variants = tileVariants[candidates[index]]
    local nextCandidates = cloneTable(candidates)
    table.remove(nextCandidates, index)
    local nextX = x + 1
    local nextY = y
    if nextX > side then
        nextX = 1
        nextY = nextY + 1
    end

    -- try each variant
    for i = 1, #variants do
        local variant = variants[i]
        local variantMatches = true
        local tileToTheLeft = image[key(x - 1, y)]
        if tileToTheLeft then
            variantMatches = tileToTheLeft.right == variant.left
        end
        if variantMatches then
            local tileAbove = image[key(x, y - 1)]
            if tileAbove then
                variantMatches = tileAbove.bottom == variant.top
            end
        end
        if variantMatches then
            local nextImage = cloneTable(image)
            nextImage[key(x, y)] = variant
            -- printImageIds(nextImage, side)
            if #nextCandidates == 0 then return nextImage end
            for j = 1, #nextCandidates do
                local result = fit(nextCandidates, j, nextX, nextY, side, nextImage)
                if result then return result end
            end
        end
    end

    return nil
end

local candidates = {}
for i = 1, #tileList do
    table.insert(candidates, tileList[i].id)
end

print(string.format("Solving side %d, candidates count %d", side, #candidates))
local result = nil
for i = 1, #candidates do
    result = fit(candidates, i, 1, 1, side, {})
    if result then break end
end

-- printImageIds(result, side)
-- print("~~~")

local topLeft = result["1,1"]
local topRight = result["1,"..side]
local bottomLeft = result[side..",1"]
local bottomRight = result[side..","..side]
print(string.format("Corner multiple is %d", topLeft.id * topRight.id * bottomLeft.id * bottomRight.id))

local image = {}
for _ = 1, side * 8 do table.insert(image, {}) end
for y = 1, side do
    for x = 1, side do
        local tile = result[key(x, y)]
        local baseY = (y - 1) * 8
        local baseX = (x - 1) * 8
        for subY = 2, 9 do
            for subX = 2, 9 do
                image[baseY + subY - 1][baseX + subX - 1] = tile.rows[subY][subX]
            end
        end
    end
end

local imageVariants = { image }
for j = 2, 4 do
    image = rotateRight({ rows = image }, j, #image).rows
    table.insert(imageVariants, image)
end
for j = 5, 8 do
    image = flipHorizontally({ rows = imageVariants[j - 4] }, j, #image).rows
    table.insert(imageVariants, image)
end

print(string.format("Image side is %d", #imageVariants[1]))
-- local function printImage(source)
--     print("~~~")
--     for y = 1, #source do
--         local out = ""
--         for x = 1, #source do
--             if source[y][x] == 1 then out = out .. "#"
--             else out = out .. "." end
--         end
--         print(out)
--     end
-- end

-- for i = 1, #imageVariants do
--     printImage(imageVariants[i])
-- end

local function countMonsters(bitmap)
    local monsters = 0
    for y = 1, #bitmap - 3 + 1 do
        for x = 1, #bitmap - 20 + 1 do
            if bitmap[y][x+18] == 1 and
                bitmap[y+1][x] == 1 and bitmap[y+1][x+5] == 1 and bitmap[y+1][x+6] == 1 and bitmap[y+1][x+11] == 1 and bitmap[y+1][x+12] == 1 and bitmap[y+1][x+17] == 1 and bitmap[y+1][x+18] == 1 and bitmap[y+1][x+19] == 1 and
                bitmap[y+2][x+1] == 1 and bitmap[y+2][x+4] == 1 and bitmap[y+2][x+7] == 1 and bitmap[y+2][x+10] == 1 and bitmap[y+2][x+13] == 1 and bitmap[y+2][x+16] == 1
            then
                monsters = monsters + 1
            end
        end
    end
    return monsters
end

local maxMonsters = 0
for i = 1, #imageVariants do
    local monsters = countMonsters(imageVariants[i])
    print(string.format("Image variant %d has %d monsters", i, monsters))
    if monsters > maxMonsters then maxMonsters = monsters end
end

local totalOnes = 0
for y = 1, #imageVariants[1] do
    for x = 1, #imageVariants[1] do
        if imageVariants[1][y][x] == 1 then totalOnes = totalOnes + 1 end
    end
end

print(string.format("Water roughness is %d", totalOnes - (maxMonsters * 15)))
