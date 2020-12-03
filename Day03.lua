print("Solving day 3")

-- ".": 46, "#": 35
local parsedLines = {}
for line in io.lines("Day03.txt") do
    local lineMap = {}
    for i = 1, #line do
        table.insert(lineMap, string.byte(line, i) == 35)
    end
    table.insert(parsedLines, lineMap)
end

local function countOuchies(lines, right, down)
    local x = 1
    local ouchy = 0
    for i = 1 + down, #lines, down do
        x = x + right
        local lineMap = lines[i]
        if (lineMap[((x - 1) % #lineMap) + 1]) then
            ouchy = ouchy + 1
        end
    end
    return ouchy
end

print(string.format("You smack into trees %d times.", countOuchies(parsedLines, 3, 1)))

---

local o1 = countOuchies(parsedLines, 1, 1)
local o2 = countOuchies(parsedLines, 3, 1)
local o3 = countOuchies(parsedLines, 5, 1)
local o4 = countOuchies(parsedLines, 7, 1)
local o5 = countOuchies(parsedLines, 1, 2)
print(o1, o2, o3, o4, o5)
print(string.format("Youre so bad at driving, you ouched yourself %d times!", o1 * o2 * o3 * o4 * o5))
