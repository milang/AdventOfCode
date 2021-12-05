print("Solving day 4")

local numbers = {}
local cards = {}
local partialCard = nil
for line in io.lines("Day04.txt") do
    if #numbers == 0 then
        for item in string.gmatch(line, "([^,]+)") do
            table.insert(numbers, tonumber(item))
        end
    elseif #line > 0 then
        if not partialCard then
            partialCard = { numbers = {}, matches = { false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false } }
        end
        for item in string.gmatch(line, "(%d+)") do
            table.insert(partialCard.numbers, tonumber(item))
        end
        if #partialCard.numbers == 25 then
            table.insert(cards, partialCard)
            partialCard = nil
        end
    end
end

local function indexOf(table, number)
    for index, value in ipairs(table) do
        if value == number then return index end
    end
    return nil
end

local function isSequence(card, startIndex, step)
    for i = startIndex, startIndex + (4 * step), step do
        if not card.matches[i] then return false end
    end
    return true
end

local function isWinningCard(card)
    -- check rows
    for i = 1, 21, 5 do
        if isSequence(card, i, 1) then return true end
    end

    -- check columns
    for i = 1, 5, 1 do
        if isSequence(card, i, 5) then return true end
    end
end

local function findWinningCard(candidateCards)
    for _, number in ipairs(numbers) do
        for cardIndex, card in ipairs(candidateCards) do
            local matchIndex = indexOf(card.numbers, number)
            if matchIndex then
                card.matches[matchIndex] = true
                if (isWinningCard(card)) then return number, card, cardIndex end
            end
        end
    end
    return nil, nil, nil
end

local function calculateUnmatchedSum(card)
    local sum = 0
    for i = 1, 25, 1 do
        if not card.matches[i] then sum = sum + card.numbers[i] end
    end
    return sum
end

local winningNumber, winningCard, winningCardIndex = findWinningCard(cards)
local unmatchedSum = calculateUnmatchedSum(winningCard)
print(winningNumber, unmatchedSum, winningNumber * unmatchedSum)

---

local function findLastWinningCard(candidateCards, lastWinningNumber, lastWinningCard, lastWinningCardIndex)
    while true do
        table.remove(candidateCards, lastWinningCardIndex)
        local newWinningNumber, newWinningCard, newWinningCardIndex = findWinningCard(candidateCards)
        if not newWinningCard then return lastWinningNumber, lastWinningCard, lastWinningCardIndex end
        lastWinningNumber = newWinningNumber
        lastWinningCard = newWinningCard
        lastWinningCardIndex = newWinningCardIndex
    end
end

winningNumber, winningCard, winningCardIndex = findLastWinningCard(cards, winningNumber, winningCard, winningCardIndex)
unmatchedSum = calculateUnmatchedSum(winningCard)
print(winningNumber, unmatchedSum, winningNumber * unmatchedSum)
