print("Solving 2015, day 1")

local directions = nil
for line in io.lines("Day01.txt") do
    directions = line
end

local floor = 0
local basement = 0
for i = 1, #directions do
    -- print(string.byte(directions,i))
    -- open: 40
    -- closed: 41
    local isOpenParenthesis = string.byte(directions,i) == 40
    if isOpenParenthesis then
        floor = floor + 1
    else
        floor = floor - 1
    end

    if floor == -1 and basement == 0 then
        basement = i
    end
end

print(floor)
print(basement)
