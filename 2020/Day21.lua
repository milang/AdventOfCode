print("Solving day 21")

local function split(value, separator)
    local found = {}
    local index = 1
    while index <= #value do
        local indexStart, indexEnd = string.find(value, separator, index)
        if indexStart then
            table.insert(found, string.sub(value, index, indexStart - 1))
            index = indexEnd + 1
        else
            table.insert(found, string.sub(value, index))
            break
        end
    end
    return found
end

local function isIn(collection, value)
    for _, collectionValue in ipairs(collection) do
        if collectionValue == value then return true end
    end
    return false
end

local ingredients = {}
local allergens = {}
for line in io.lines("Day21.txt") do
    local allergensStart = string.find(line, "%(")
    if not allergensStart then error("Failed to find allergens start") end
    local currentIngredients = split(string.sub(line, 1, allergensStart - 2), " ")
    for _, currentIngredient in ipairs(currentIngredients) do
        local count = ingredients[currentIngredient]
        if not count then ingredients[currentIngredient] = 1
        else ingredients[currentIngredient] = count + 1 end
    end

    local currentAllergens = split(string.sub(line, allergensStart + 10, #line - 1), ", ")
    for _, currentAllergen in ipairs(currentAllergens) do
        local knownIngredientsForAllergen = allergens[currentAllergen]
        if not knownIngredientsForAllergen then allergens[currentAllergen] = currentIngredients
        else
            local intersection = {}
            for _, knownIngredient in ipairs(knownIngredientsForAllergen) do
                if isIn(currentIngredients, knownIngredient) then table.insert(intersection, knownIngredient) end
            end
            allergens[currentAllergen] = intersection
        end
    end
end

local candidates = {}
for key, _ in pairs(ingredients) do
    candidates[key] = true
end

local allergensCount = 0
for _, ingredientsForAllergen in pairs(allergens) do
    allergensCount = allergensCount + 1
    for _, ingredientForAllergen in ipairs(ingredientsForAllergen) do
        candidates[ingredientForAllergen] = false
    end
end

local sum = 0
for ingredient, ingredientHasNoAllergens in pairs(candidates) do
    if ingredientHasNoAllergens then sum = sum + ingredients[ingredient] end
end

print(string.format("Ingredients without known allergens appear %d times", sum))

------

local knownIngredients = {}
local keepIterating = true
while keepIterating do
    keepIterating = false
    for allergen, ingredientsForAllergen in pairs(allergens) do
        if #ingredientsForAllergen == 1 then
            if not isIn(knownIngredients, ingredientsForAllergen[1]) then table.insert(knownIngredients, ingredientsForAllergen[1]) end
        else
            keepIterating = true
            if #knownIngredients > 0 then
                local filteredIngredients = {}
                for _, ingredientForAllergen in ipairs(ingredientsForAllergen) do
                    if not isIn(knownIngredients, ingredientForAllergen) then table.insert(filteredIngredients, ingredientForAllergen) end
                end
                allergens[allergen] = filteredIngredients
            end
        end
    end
end

local canonicalAllergens = {}
for allergen, allergenIngredients in pairs(allergens) do
    table.insert(canonicalAllergens, { allergen = allergen, ingredient = allergenIngredients[1] })
end

table.sort(canonicalAllergens, function (a, b) return a.allergen < b.allergen end)
local canonicalIngredients = {}
for _, canonicalAllergen in ipairs(canonicalAllergens) do
    table.insert(canonicalIngredients, canonicalAllergen.ingredient)
end

print(string.format("Canonical dangerous ingredients list: %s", table.concat(canonicalIngredients, ",")))
