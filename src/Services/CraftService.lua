-- CraftService is a library to provide all kind of Craft helper functions

-- Has a lot of dependencies of low - level structures 
-- such as Resource, Recipe


local CraftService = {} 


-- Returns a list of possible recipes with reslist
function CraftService:GetPossibleRecipes(reslist)

end

-- Server-sided recipe is known check
-- Arguments: player (instance) and recipe (recipe ID tracker)
function CraftService:RecipeIsKnown(player, recipe)

end 

-- Add a recipe to memory; use a recipe structure
function CraftService:AddRecipe(recipe)

end 

return CraftService

