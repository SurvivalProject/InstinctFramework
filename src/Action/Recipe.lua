local Recipe = {} 

local RecipeService = Instinct.Include "Services/RecipeService"

Recipe.Category = "Creation"
Recipe.Context = {}
Recipe.Ingredients = {}

function Recipe:SetCategory(cat) 
	if RecipeService.Categories[cat] then 
		self.Category = cat 
	else 
		throw(cat .. " is not a valid category, register this first on RecipeService")
	end 
end 



return Recipe 