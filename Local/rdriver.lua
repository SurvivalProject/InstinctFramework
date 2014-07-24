-- This driver checks if the services run correctly 
-- It is also a sample file to figure out what would be the 
-- best behaviour possible

-- WHAT IS NEEDED?

--> The Ruleset
--> A Rule OK checker 
--> A Context OK checker
--> A service to interact with systems to figure out if a change is wanted
--> A service to APPLY changes

-- Sample recipes: 
-- Copper and Tin in a furnace -> Termpature > 900

local Recipe = Instinct.Create "DataStructs/Recipe"

-- A category must be present
-- This is for a quick split of available recipes
-- a table MAY be used

Recipe.Category = "Furnace"



Recipe.Context = {
BuildingType = "Furnace",
CanMix = true,
}

-- Ingredients table is specified as following:
--> [Name] = Amount
-- OR
--> [Name] = {Amount=ItemAmount or 1, RULES}
--> Rules are evaluated via a RuleService which holds 
--> A ruleset for rules (yay)

Recipe.Ingredients = {
	Copper = {Amount = 10, Temperature = {"L", 900}},
	Tin = {Amount = 1, Temperature = {"L", 900}},
	["Metal Container"] = 1,
}

-- The creation funciton receives all used ingredients
-- If it returns true; autoclean
-- If it returns false; dont autoclean, done by script
-- A number returned is an error code

-- The default function returns the resource provided from ResourceService
-- If other behaviour is expected, define own function

function Recipe:Creation(rlist)

end






-- How would a knapping recipe work then 

