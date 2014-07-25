-- RecipeService only checks if the recipe can be made
-- If so, and the world / user wants to execute this recipe
-- The context + resources list should be passed to an
-- additional service which constructs the new object

-- In theory it should be possible that this thing
-- Creates dynamic objects! (damn)

local ObjectService = Instinct.Include "Services/ObjectService"
local Object = Instinct.Include "Action/Object"

local RecipeService = {}

RecipeService.Categories = {}

function RecipeService:Constructor()
	self.Categories = {}
	self.Rules = {}
end

function RecipeService:AddCategory(name)
	self.Categories[name] = true 
end 

RecipeService.UsedHelpers = {
	Add = function(self, ing, what)
		if not self[ing] then 
			self[ing] = {what}
			self[ing][what] = 1 
		else 
			table.insert(self[ing], what)
			self[ing][what] = #(self[ing])
		end 
	end, 
	Delete = function(self, ing, what)
		if self[ing] then 
			self[ing].Deleted = true -- notify that something is being deleted
			local i = self[ing][what]
			if i then 
				self[ing][i] = nil 
				self[ing][what] = nil 
			end 
		end
	end

}

-- Converts a list of Instances to WorkList
-- A WorkList should not be created a lot
-- It should be created before a recipe check round
-- It mainly consists of a linker object between the 
-- instance and the instinct object

-- preprocess the IL

-- contents
-- ipairs: {resource, obj}
-- [name] = {{res, obj}, {res2, obj}} etc



function RecipeService:CreateWorkList(InstanceList) 
	-- assertion is that instancelist 
	-- consists of roblox instances
	local out = {}
	local namelist = {}
	for i,v in pairs(InstanceList) do 
		local obj = ObjectService:GetObject(v)
		if not obj then 
			throw "object not available"
			return nil, 1
		end 
		table.insert(out, {v, obj})
		if not namelist[v.Name] then 
			namelist[v.Name] = {out[#out][1], [0] = out[#out][2]}
		else 
			table.insert(namelist[v.Name], out[#out][1])
		end
	end 
	for i,v in pairs(namelist) do 
		local o = v[0]
		v[#v + 1] = o 
		out[i] = v 
	end 
	setmetatable(out.Used, {__index = self.UsedHelpers})
	return out, 0 
end 



-- Checks if a recipe can be created;
-- Recipe is the recipe we want to create
-- Context is the context (backpack, in furnace, env temp, etc.)
-- List is a list of Objects provided to create the recipe
-- The Used field of this List should be filled
-- By the Rule functions with every INSTANCE which is used
-- To create the recipe

-- This service is a very complex service;
-- This function is the heart of it.
-- What does it do?
--> Check if the context exists
--> If so, figure out if the context is okay for this recipe
--> If nonexistant, okay too
--> Checkout the first rule.
--> EVERY RULE should test every ingredient


function RecipeService:CheckRecipe(Recipe, Context, List)
	-- Check if all rules are present
	-- The minimal recipe only checks for ingredients.
	-- First check if the Recipe has any Context rules
	-- LIST is auto-changed to a WL
	local rl, err = self:CreateWorkList(List)
	if err > 0 then 
		throw "Worklist creation error, aborting .. "
		return false, 4
	end 
	local List = rl 
	local skip = {}

	local function EvalRuleProcedure(RuleName, RuleSet, RuleType, List, WholeList, errmsg, errcode)
		local ok, err = self:EvaluateRule(RuleName, RuleData, RuleSet, RuleType, Context, List, Recipe, WholeList,)
		if not ok then
			if err > 0 then 
				throw(errmsg)
			end  
			return false ,errcode 
		elseif type(err) == "table" then 
			for _, skiprule in pairs(ok) do 
				skip[skiprule] = true 
			end 
		end
		return ok, err 
	end 

	if Recipe.Context then
		skip = {} 
		-- We must evaluate all Context rules
		for RuleName, RuleData in pairs(Recipe.Context) do
			if not skip[RuleName] then  
				local ok, err = EvalRuleProcedure(RuleName, Recipe.Context, {"Context", "NotAResource"}, List, List, "recipe check error clist", 3)
				if not ok then 
					return false, 9
				end 
			end 
		end
	end
	if Recipe.Ingredients then 
		for IngredientName, IngredientRules in pairs(Recipe.Ingredients) do 
			skip = {} -- clear skip cache 
			local ok, err = EvalRuleProcedure("Amount", IngredientRules,  {"Ingredient", IngredientName}, List, List, "recipe check error inglist", 2)
			if not ok then 
				return false, 7
			end 
			for RuleName, RuleData in pairs(IngredientRules) do 
				if RuleName ~= "Amount" then 
					if not skip[RuleName] then 
						local ok, err = EvalRuleProcedure(RuleName, IngredientRules, {"Ingredient", IngredientName}, List.Used[IngredientName], List, "recipe check error inglist", 2)
						if not ok then 
							return false, 8
						end 		
						
					end
				end 
			end
			-- still amount ok?
			if #List.Used[IngredientName] < IngredientRules.Amount then 
				return false, 6
			end 
		end 
	else 
		throw("recipe has no ingredients !?")
		return false, 1
	end 	
	if #List.Used == 0 then 
		throw "No ingredients usage defined... returning false."
		return false, 5
	end 
	return List.Used, 0
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
-- "Temperature", {"Larger", 900},  AllRulesForIngredient, {"Ingredient", IngredientName}, data.context, data.rlist, data
-- Second arg returned is 1: error, or 0: ok
-- first arg is if rule is ok or not (table or boolean, explained below)

-- Watch out! IngredientName can be misleading!
-- "Food" could be an ingredient name!
-- It is JUST to make recipes easier to read!

-- NOTE: 
-- A table may be returned: this holds a list of further rules 
-- for that current scope to ignore.
-- this is handy for an option list
-- be aware that these option may cause a rulename does not exist error
-- !
function RecipeService:EvaluateRule(RuleName, RuleData, RuleSet, RuleType, Context, List, Recipe)
	if not self.Rules[RuleName] then 
		throw(RuleName .. " a rulename does not exist")
		return false, 1
	end 

	return self.Rules[RuleName](RuleData, RuleType, RuleSet, Context, List, Recipe)

end 