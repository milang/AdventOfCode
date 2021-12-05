print("Solving day 3")

-- "0" => 48, "1" => 49
local rates = {}
for line in io.lines("Day03.txt") do
    local bits = {}
    for i = 1, #line do
        table.insert(bits, string.byte(line, i) == 49)
    end
    table.insert(rates, bits)
end

local bitCounts = {}
for _, rate in ipairs(rates) do
    for index, bit in ipairs(rate) do
        if bit then
            bitCounts[index] = (bitCounts[index] or 0) + 1
        end
    end
end

local gamma = 0
local epsilon = 0
for i = 1, #bitCounts, 1 do
    gamma = gamma * 2
    epsilon = epsilon * 2
    if bitCounts[i] > (#rates - bitCounts[i]) then
        gamma = gamma + 1
    else
        epsilon = epsilon + 1
    end
end

print(string.format("Gamma: %d, Epsilon: %d, Product: %d", gamma, epsilon, gamma * epsilon))

---

local function countBit(values, index)
    local count = 0
    for _, value in ipairs(values) do
        if value[index] then count = count + 1 end
    end
    return count
end

local function filterRates(inputRates, index, value)
    local outputRates = {}
    for _, rate in ipairs(inputRates) do
        if rate[index] == value then
            table.insert(outputRates, rate)
        end
    end
    return outputRates
end

local function toDecimal(rate)
    local value = 0
    for _, bit in ipairs(rate) do
        value = value * 2
        if bit then value = value + 1 end
    end
    return value
end

local oxygenRates = rates
local co2Rates = rates
for filterIndex = 1, #(rates[1]), 1 do
    if #oxygenRates > 1 then
        local oxygenBitCount = countBit(oxygenRates, filterIndex)
        oxygenRates = filterRates(oxygenRates, filterIndex, oxygenBitCount >= (#oxygenRates - oxygenBitCount))
    end
    if #co2Rates > 1 then
        local co2BitCount = countBit(co2Rates, filterIndex)
        co2Rates = filterRates(co2Rates, filterIndex, co2BitCount < (#co2Rates - co2BitCount))
    end
end

local oxygenRateDecimal = toDecimal(oxygenRates[1])
local co2RateDecimal = toDecimal(co2Rates[1])
print(string.format("Oxygen: %d, CO2: %d, Product: %d", oxygenRateDecimal, co2RateDecimal, oxygenRateDecimal * co2RateDecimal))
