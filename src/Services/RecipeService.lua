local RecipeService = {}

RecipeService.Categories = {}

function RecipeService:Constructor()
	self.Categories = {}
	self.Rules = {}
end

function RecipeService:AddCategory(name)
	self.Categories[name] = true 
end 

-- Checks if a recipe can be created;
-- Recipe is the recipe we want to create
-- Context is the context (backpack, in furnace, env temp, etc.)
-- List is a list of Objects provided to create the recipe

function RecipeService:CheckRecipe(Recipe, Context, List)
	-- Check if all rules are present
	-- The minimal recipe only checks for ingredients.
	-- First check if the Recipe has any Context rules
	if Recipe.Context then 
		-- We must evaluate all Context rules
		for RuleName, RuleData in pairs(Recipe.Context) do 
			local ok, err = self:EvaluateRule(RuleName, RuleData, {"Context", "NotAResource"}, Context, List, Recipe)
			if not ok then
				if err > 0 then 
					throw("recipe check error clist")
				end  
				return false 
			end 
		end
	end
	if Recipe.Ingredients then 
		for IngredientName, IngredientRules in pairs(Recipe.Ingredients) do 
			for RuleName, RuleData in pairs(IngredientRules) do 
				local ok, err = self:EvaluateRule(RuleName, RuleData, {"Ingredient", IngredientName}, Context, List, Recipe)
				if not ok then 
					if err > 0 then 
						throw("recipe check err inglist")
					end 
					return false 
				end
			end
		end 
	else 
		throw("recipe has no ingredients !?")
		return false, 1
	end 	
	return true, 0
end 

-- passed: 
function RecipeService:AddRule(name, rulefunc)
	if not self.Rules[name] then 
		self.Rules[name] = rulefunc 
	else 
		throw(name .. " rule already exists")
	end 
end 

-- Evaluate a Rule
-- Please create a default EQ checker for general rules
-- A good helper function to use is Object:HasConstant
-- EX pass:
-- {Temperature = {"Larger", 900}}
--> pass:
-- "Temperature", {"Larger", 900},  {"Ingredient", IngredientName}, data.context, data.rlist, data
-- Second arg returned is 1: error, or 0: ok
-- first arg is if rule is ok or not (should be boolean)
function RecipeService:EvaluateRule(RuleName, RuleData, RuleType, Context, List, Recipe)
	if not self.Rules[RuleName] then 
		throw(RuleName .. " a rulename does not exist")
		return false, 1
	end 

	return self.Rules[RuleName](RuleData, RuleType, Context, List, Recipe), 0

end 