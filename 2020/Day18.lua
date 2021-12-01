print("Solving day 18")

local function parseNumber(value, index)
    local char = string.sub(value, index, index)
    if char >= "0" and char <= "9" then
        local number = 0
        while char >= "0" and char <= "9" and index <= #value do
            number = number * 10 + string.byte(char) - 48
            index = index + 1
            char = string.sub(value, index, index)
        end
        return number, index
    end
    return nil, index
end

local parseExpression = nil

local function parseParenthesis(line, index)
    if string.sub(line, index, index) == "(" then
        local result
        result, index = parseExpression(line, index + 1)
        if string.sub(line, index, index) ~= ")" then error("Expected space at position " .. index) end
        return result, index + 1
    end
    return nil
end

local function parseItem(line, index, operator)
    local result
    result, index = parseNumber(line, index)
    if result ~= nil then return { operator = operator, value = result }, index end

    result, index = parseParenthesis(line, index)
    if result ~= nil then return { operator = operator, child = result }, index end

    error("Unexpected token")
end

parseExpression = function (line, index)
    local items = {}
    local item
    item, index = parseItem(line, index, "+")
    table.insert(items, item)

    while index <= #line do
        if string.sub(line, index, index) == ")" then break end
        if string.sub(line, index, index) ~= " " then error("Expected space at position " .. index) end
        local operator = string.sub(line, index + 1, index + 1)
        if string.sub(line, index + 2, index + 2) ~= " " then error("Expected space at position " .. index + 2) end
        item, index = parseItem(line, index + 3, operator)
        table.insert(items, item)
    end

    return items, index
end

local function evaluateExpression(expression)
    local result = 0
    for _, item in ipairs(expression) do
        local value = nil
        if item.child then
            value = evaluateExpression(item.child)
        else
            value = item.value
        end

        if item.operator == "+" then result = result + value
        else result = result * value end
    end

    return result
end

local function advancedEvaluateExpression(expression, result, index)
    for i = index, #expression do
        local item = expression[i]
        local value = nil
        if item.child then
            value = advancedEvaluateExpression(item.child, 0, 1)
        else
            value = item.value
        end

        if item.operator == "+" then result = result + value
        else
            result = result * advancedEvaluateExpression(expression, value, i + 1)
            break
        end
    end

    return result
end

local sum = 0
local advancedSum = 0
for line in io.lines("Day18.txt") do
    local expression, _ = parseExpression(line, 1)
    sum = sum + evaluateExpression(expression)
    advancedSum = advancedSum + advancedEvaluateExpression(expression, 0, 1)
    -- print(evaluateExpression(expression))
    -- print(advancedEvaluateExpression(expression, 0, 1))
end

print(string.format("Simple sum is %d", sum))
print(string.format("Advanced sum is %d", advancedSum))
