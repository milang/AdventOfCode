print("Solving day 2")

local records = {}
for line in io.lines("Day02.txt") do
    local min, max, char, password = string.match(line, "(%d+)%-(%d+) (%a)%: (%a+)")
    table.insert(records, {
        min = tonumber(min),
        max = tonumber(max),
        char = char,
        password = password
    })
end

local function isValid(record)
    local charCount = 0
    for _ in string.gmatch(record.password, record.char) do
        charCount = charCount + 1
    end
    return charCount >= record.min and charCount <= record.max
end

local valid = 0
for _, record in ipairs(records) do
    if isValid(record) then valid = valid + 1 end
end

print(string.format("There are %d valid passwords", valid))

------

local function isMoreValid(record)
    local isFirstValid = string.byte(record.char, 1) == string.byte(record.password, record.min)
    local isSecondValid = string.byte(record.char, 1) == string.byte(record.password, record.max)
    return (isFirstValid and not isSecondValid) or (not isFirstValid and isSecondValid)
end

valid = 0
for _, record in ipairs(records) do
    if isMoreValid(record) then valid = valid + 1 end
end

print(string.format("There are %d more valid passwords", valid))
