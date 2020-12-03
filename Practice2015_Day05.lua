print("Solving 2015, day 5")

local function isNice(line)
    local vowels = 0
    local double = 0
    for i = 1, #line, 1 do
        local c = string.byte(line, i)
        if (c == 97) then -- a
            vowels = vowels + 1
            if i < #line and string.byte(line, i + 1) == 98 then -- b, forbidden
                return false
            end
        elseif (c == 99) then -- c
            if i < #line and string.byte(line, i + 1) == 100 then -- d, forbidden
                return false
            end
        elseif (c == 101) then -- e
            vowels = vowels + 1
        elseif (c == 105) then -- i
            vowels = vowels + 1
        elseif (c == 111) then -- o
            vowels = vowels + 1
        elseif (c == 112) then -- p
            if i < #line and string.byte(line, i + 1) == 113 then -- q, forbidden
                return false
            end
        elseif (c == 117) then -- u
            vowels = vowels + 1
        elseif (c == 120) then -- x
            if i < #line and string.byte(line, i + 1) == 121 then -- y, forbidden
                return false
            end
        end

        if i < #line and c == string.byte(line, i + 1) then
            double = double + 1
        end
    end
    return vowels >= 3 and double > 0
end

local niceCount = 0
for line in io.lines("Practice2015_Day05.txt") do
    if isNice(line) then niceCount = niceCount + 1 end
end

print(string.format("Found %d nice numbers", niceCount))

------

local function isNicer(line)
    local singleMatches = 0
    local doubleMatches = 0
    for i = 1, #line - 2, 1 do
        local c = string.byte(line, i)
        if c == string.byte(line, i + 2) then singleMatches = singleMatches + 1 end
        for j = i + 2, #line, 1 do
            if c == string.byte(line, j) and string.byte(line, i + 1) == string.byte(line, j + 1) then
                doubleMatches = doubleMatches + 1
            end
        end
    end
    return singleMatches > 0 and doubleMatches > 0
end

local nicerCount = 0
for line in io.lines("Practice2015_Day05.txt") do
    if isNicer(line) then nicerCount = nicerCount + 1 end
end

print(string.format("Found %d nicer numbers", nicerCount))
