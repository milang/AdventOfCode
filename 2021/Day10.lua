print("Solving day 10")

local function findIllegalCharacter(line, index, stack)
    for i = index, #line, 1 do
        local character = string.sub(line, i, i)
        if character == "(" then
            table.insert(stack, ")")
        elseif character == "[" then
            table.insert(stack, "]")
        elseif character == "{" then
            table.insert(stack, "}")
        elseif character == "<" then
            table.insert(stack, ">")
        else
            if stack[#stack] == character then -- valid closing character
                table.remove(stack, #stack)
            else
                return character, nil
            end
        end
    end
    return nil, stack
end

local syntaxScore = 0
local completionScores = {}
for line in io.lines("Day10.txt") do
    local illegalCharacter, stack = findIllegalCharacter(line, 1, {})
    if illegalCharacter == ")" then syntaxScore = syntaxScore + 3
    elseif illegalCharacter == "]" then syntaxScore = syntaxScore + 57
    elseif illegalCharacter == "}" then syntaxScore = syntaxScore + 1197
    elseif illegalCharacter == ">" then syntaxScore = syntaxScore + 25137
    else
        local completionScore = 0
        for i = #stack, 1, -1 do
            completionScore = completionScore * 5;
            local c = stack[i]
            if c == ")" then completionScore = completionScore + 1
            elseif c == "]" then completionScore = completionScore + 2
            elseif c == "}" then completionScore = completionScore + 3
            elseif c == ">" then completionScore = completionScore + 4 end
        end
        table.insert(completionScores, completionScore)
    end
end

table.sort(completionScores)
print(syntaxScore, completionScores[math.floor(#completionScores / 2) + 1])
