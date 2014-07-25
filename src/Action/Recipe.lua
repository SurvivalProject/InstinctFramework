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

function Recipe:CheckRecipe(Context, List)
	if Context and List then 
		return RecipeService:CheckRecipe(self, Context, List), 0
	else 
		if not Context then 
			throw("no context provided")
			return false, 1 
		end 
		if not List then 
			throw("no recipe list provided")
			return false, 2 
		end 
	end
end

return Recipe 