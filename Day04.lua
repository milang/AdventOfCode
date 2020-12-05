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

local function parseYear(value, min, max)
    if value and string.match(value, "^%d%d%d%d$") then
        local year = tonumber(value)
        if year >= min and year <= max then return year end
    end
    return nil
end

local function parseHeight(value)
    if value then
        local num = string.match(value, "^(%d+)cm$")
        if num then
            local cm = tonumber(num)
            if cm >= 150 and cm <= 193 then return { value = cm, isMetric = true } end
        else
            num = string.match(value, "^(%d+)in$")
            if num then
                local inches = tonumber(num)
                if inches >= 59 and inches <= 76 then return { value = inches, isMetric = false } end
            end
        end
    end
    return nil
end

local function parseHex(value)
    if value and string.match(value, "^#[a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9]$") then
        return {
            value = value,
            number = tonumber(string.sub(value, 2), 16),
            red = tonumber(string.sub(value, 2, 3), 16),
            green = tonumber(string.sub(value, 4, 5), 16),
            blue = tonumber(string.sub(value, 6, 7), 16)
        }
    end
    return nil
end

local function isEyeColor(value)
    return value == "amb" or value == "blu" or value == "brn" or value == "gry" or value == "grn" or value == "hzl" or value == "oth"
end

local function isPassportNumber(value)
    return value and string.match(value, "^%d%d%d%d%d%d%d%d%d$")
end

local function isMoreValid(record)
    local byr = parseYear(record.byr, 1920, 2002)
    local iyr = parseYear(record.iyr, 2010, 2020)
    local eyr = parseYear(record.eyr, 2020, 2030)
    local hgt = parseHeight(record.hgt)
    local hcl = parseHex(record.hcl)
    if byr and iyr and eyr and hgt and hcl and isEyeColor(record.ecl) and isPassportNumber(record.pid) then
        return { byr = byr, iyr = iyr, eyr = eyr, hgt = hgt, hcl = hcl, ecl = record.ecl, pid = record.pid }
    end
    return nil
end

local moreValid = 0
local found = {}
for _, record in ipairs(records) do
    local r = isMoreValid(record)
    if r then
        table.insert(found, r)
        moreValid = moreValid + 1
    end
end

print(string.format("Found %d more valid records", moreValid))
