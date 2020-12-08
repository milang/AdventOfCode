print("Solving day 8")

local parsedProgram = {}
for line in io.lines("Day08.txt") do
    local instruction, value = string.match(line, "^(%a%a%a) ([+-]%d+)")
    table.insert(parsedProgram, { instruction = instruction, value = value })
end

local function isIn(array, value)
    for _, valueInArray in ipairs(array) do
        if valueInArray == value then return true end
    end
    return false
end

local function emulate(program, executed)
    local computer = { accumulator = 0, next = 1, executed = executed }
    while true do
        table.insert(computer.executed, computer.next)
        local i = program[computer.next]
        if i.instruction == "nop" then
            computer.next = computer.next + 1
        elseif i.instruction == "acc" then
            computer.accumulator = computer.accumulator + i.value
            computer.next = computer.next + 1
        elseif i.instruction == "jmp" then
            computer.next = computer.next + i.value
        else
            error("Unknown instruction " .. i.instruction)
        end

        -- is "computer.next" in "computer.executed"? (an instruction is going to be executed again)
        if isIn(computer.executed, computer.next) then
            break
        end
    end
    return computer
end

local part1Result = emulate(parsedProgram, {})
print(string.format("Accumulator is %d", part1Result.accumulator))

------

local function copyProgram(source, target)
    for _, value in ipairs(source) do
        table.insert(target, { instruction = value.instruction, value = value.value })
    end
    return target
end

local part2Result = nil
for i = 1, #parsedProgram do
    if parsedProgram[i].instruction == "nop" then
        local changedProgram = copyProgram(parsedProgram, {})
        changedProgram[i].instruction = "jmp"
        local copyResult = emulate(changedProgram, { #changedProgram + 1 })
        if copyResult.next == (#changedProgram + 1) then
            part2Result = copyResult
            break
        end
    elseif parsedProgram[i].instruction == "jmp" then
        local changedProgram = copyProgram(parsedProgram, {})
        changedProgram[i].instruction = "nop"
        local copyResult = emulate(changedProgram, { #changedProgram + 1 })
        if copyResult.next == (#changedProgram + 1) then
            part2Result = copyResult
            break
        end
    end
end

print(string.format("Accumulator is %d, next is %d, termination is %d", part2Result.accumulator, part2Result.next, #parsedProgram + 1))
