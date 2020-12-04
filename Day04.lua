print("Solving day 4")

local records = {}
local currentRecord = {}
for line in io.lines("Day04.txt") do
    if #line == 0 then
        table.insert(records, currentRecord)
        currentRecord = {}
    else
        for key, value in string.gmatch(line, "(%a+):(%g+)") do
            currentRecord[key] = value
        end
    end
end

local function isValid(record)
    return record.byr ~= nil and record.iyr ~= nil and record.eyr ~= nil and record.hgt ~= nil and record.hcl ~= nil and record.ecl ~= nil and record.pid ~= nil
end

local valid = 0
for _, record in ipairs(records) do
    if isValid(record) then valid = valid + 1 end
end

print(string.format("Found %d valid records", valid))

------

local function isYear(value, min, max)
    if string.match(value, "^%d%d%d%d$") then
        local year = tonumber(value)
        return year >= min and year <= max
    end
    return false
end

local function isHeight(value)
    local num = string.match(value, "^(%d+)cm$")
    if num then
        local cm = tonumber(num)
        return cm >= 150 and cm <= 193
    else
        num = string.match(value, "^(%d+)in$")
        if num then
            local inches = tonumber(num)
            return inches >= 59 and inches <= 76
        end
    end
end

local function isHex(value)
    return string.match(value, "^#[a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9]$")
end

local function isEyeColor(value)
    return value == "amb" or value == "blu" or value == "brn" or value == "gry" or value == "grn" or value == "hzl" or value == "oth"
end

local function isPassportNumber(value)
    return string.match(value, "^%d%d%d%d%d%d%d%d%d$")
end

local function isMoreValid(record)
    return isValid(record)
        and isYear(record.byr, 1920, 2002)
        and isYear(record.iyr, 2010, 2020)
        and isYear(record.eyr, 2020, 2030)
        and isHeight(record.hgt)
        and isHex(record.hcl)
        and isEyeColor(record.ecl)
        and isPassportNumber(record.pid)
end

local moreValid = 0
for _, record in ipairs(records) do
    if isMoreValid(record) then moreValid = moreValid + 1 end
end

print(string.format("Found %d more valid records", moreValid))
