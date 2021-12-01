print("Solving day 22")

local lines = {}
for line in io.lines("Day22.txt") do
    table.insert(lines, line)
end

local parsedDecks = {}
local parsedDeck = nil
for i = 1, #lines do
    if lines[i] == "" then
        parsedDeck = nil
    else
        if not parsedDeck then
            parsedDeck = {}
            table.insert(parsedDecks, parsedDeck)
        else
            table.insert(parsedDeck, tonumber(lines[i]))
        end
    end
end

local function cloneTable(source, startIndex, endIndex)
    local target = {}
    if not startIndex then startIndex = 1 end
    if not endIndex then endIndex = #source end
    for i = startIndex, endIndex do
        target[i] = source[i]
    end
    return target
end

local function calculateScore(deck)
    local score = 0
    for i = 1, #deck do
        score = score + deck[i] * (#deck - i + 1)
    end
    return score
end

local decks = { cloneTable(parsedDecks[1]), cloneTable(parsedDecks[2]) }
while #decks[1] > 0 and #decks[2] > 0 do
    local p1Card = table.remove(decks[1], 1)
    local p2Card = table.remove(decks[2], 1)
    if p1Card > p2Card then
        table.insert(decks[1], p1Card)
        table.insert(decks[1], p2Card)
    else
        table.insert(decks[2], p2Card)
        table.insert(decks[2], p1Card)
    end
end

if #decks[1] > 0 then parsedDeck = decks[1] else parsedDeck = decks[2] end
print(string.format("Score of the winner is %d", calculateScore(parsedDeck)))

------

local function calculateSnapshot(deck1, deck2)
    return "1:" .. table.concat(deck1, ",") .. ";2:" .. table.concat(deck2, ",")
end

local function playGame(deck1, deck2)
    local history = {}
    while #deck1 > 0 and #deck2 > 0 do
        -- prevent infinite loops
        local snapshot = calculateSnapshot(deck1, deck2)
        if history[snapshot] then return 1, deck1 end
        history[snapshot] = true

        -- play top cards
        local p1Card = table.remove(deck1, 1)
        local p2Card = table.remove(deck2, 1)
        local winner = nil
        if p1Card <= #deck1 and p2Card <= #deck2 then
            -- recursive game
            winner, _ = playGame(cloneTable(deck1, 1, p1Card), cloneTable(deck2, 1, p2Card))
        else
            if p1Card > p2Card then winner = 1 else winner = 2 end
        end

        -- update card decks
        if winner == 1 then
            table.insert(deck1, p1Card)
            table.insert(deck1, p2Card)
        else
            table.insert(deck2, p2Card)
            table.insert(deck2, p1Card)
        end
    end

    if #deck1 > 0 then return 1, deck1
    else return 2, deck2 end
end

local _, winnerCards = playGame(parsedDecks[1], parsedDecks[2])
print(string.format("Recursive score of the winner is %d", calculateScore(winnerCards)))
