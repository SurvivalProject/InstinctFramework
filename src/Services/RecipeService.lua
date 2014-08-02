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

RecipeService.Rules = {}

function RecipeService:Constructor()
	self.Categories = {}
	self.Rules = {}
end

function RecipeService:AddCategory(name)
	self.Categories[name] = {}
end 

function RecipeService:AddRecipeToCategory(recipe, category)
	if not self.Categories[category] then 
		self:AddCategory(category)
	end 
	table.insert(self.Categories[category], recipe)
end 

RecipeService.UsedHelpers = {
	Add = function(self, ing, what)
		if not self[ing] then 
			self[ing] = {} 
		end 
		if not self[ing][what.Name] then 
			self[ing][what.Name] =  {what, Object = ObjectService:GetObject(what.Name)}
		else 
			table.insert(self[ing][what.Name], what)
		end
	end, 
	Delete = function(self, ing, what)
		if self[ing] then 
			self[ing].Deleted = true -- notify that something is being deleted
			if self[ing][what.Name] then 
				self[ing][what.Name].Deleted = true
				for i,v in pairs(self[ing][what.Name]) do 
					if v == what then 
						table.remove(self[ing][what.Name], i)
						break 
					end 
				end 
			end 
		end
	end,


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
	local out = {Used={}}
	local namelist = {}
	for i,v in pairs(InstanceList) do 
		local obj = ObjectService:GetObject(v.Name)
		if not obj then 
			throw("object " .. v.Name .. "not available")
			return nil, 1
		end 
		table.insert(out, {v, obj})
		if not namelist[v.Name] then 
			namelist[v.Name] = {out[#out][1], Object = out[#out][2]}
		else 
			table.insert(namelist[v.Name], out[#out][1])
		end
	end 
	for i,v in pairs(namelist) do 
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

--> Mode:
--> 1 -> Diagnostic (for helpers)
--> 2 -> debug (verbose output)

function RecipeService:CheckRecipe(Recipe, Context, List, Mode)
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

	local function EvalRuleProcedure(RuleName, RuleData,  RuleSet, RuleType, List, WholeList, errmsg, errcode)
		local ok, skipd, err = self:EvaluateRule(RuleName, RuleData, RuleSet, RuleType, Context, List, Recipe, WholeList, Mode )
		local err = err or 0
		if not ok then
			if Mode and Mode == 2 then 
				printm("RecipeService", "info", "rule not okay: " .. RuleName)
			end 
			if err > 0 then 
				throw(errmsg)
			end  
			return false ,errcode 
		elseif type(err) == "table" then 
			for _, skiprule in pairs(err) do 
				skip[skiprule] = true 
			end 
		end
		return ok, skipd, err 
	end 

	if Recipe.Context then
		skip = {} 
		-- We must evaluate all Context rules
		for RuleName, RuleData in pairs(Recipe.Context) do
			if not skip[RuleName] then  
				local ok, err = EvalRuleProcedure(RuleName, RuleData, Recipe.Context, {"Context", "NotAResource"}, List, List, "recipe check error clist", 3)
				if not ok then 
					return false, 9
				end 
			end 
		end
	end
	local nokrules = {}
	local gotnok = false 
	local function nok(ing, rule)
		gotnok =true
		if nokrules[ing] then 
			nokrules[ing][rule] = true 
		else 
			nokrules[ing] = {[rule] = true}
		end 
	end 
	if Recipe.Ingredients then 
		for IngredientName, IngredientRules in pairs(Recipe.Ingredients) do 
			skip = {} -- clear skip cache 
			if Mode == 2 then 
				printm("RecipeService", "info", "Checking rules for ".. IngredientName)
			end 
			local ok, err = EvalRuleProcedure("Amount", IngredientRules.Amount, IngredientRules,  {"Ingredient", IngredientName}, List, List, "recipe check error inglist", 2)
			if not ok and not Recipe.DelFunc then 
				return false, 7
			else 
				table.insert(nokrules, IngredientName)
			end 
			for RuleName, RuleData in pairs(IngredientRules) do 
				printm("RecipeService", "info", "Evaluating rule " .. RuleName )
				if RuleName ~= "Amount" then 
					if not skip[RuleName] then 
						local ok, err = EvalRuleProcedure(RuleName, RuleData, IngredientRules, {"Ingredient", IngredientName}, List.Used[IngredientName], List, "recipe check error inglist", 2)
						if not ok then 
							if Recipe.DelFunc then 
								nok(IngredientName, RuleName)
								Recipe.DelFunc(nokrules, List.Used)
							end
							return false, 8
						end
					end
				end 
			end
			-- still amount ok?
			local atotal = 0 
			local chk = nil 
			local chksame = IngredientRules.Same ~= nil 
			if IngredientRules.AmountType == "Volume" then 
				-- check for volume 
				chk = true 
			end 
			local rem 
			local cando 
			if chksame then 
				rem = {}
				cando = false 
			end 

			if List.Used[IngredientName] then 
				for i,v in pairs(List.Used[IngredientName]) do 
					-- add amount proc
					if chk then 
						for ind, val in pairs(v) do 
							atotal = atotal + ObjectService:GetVolume(v)
						end 
					else
						atotal = atotal + #v
					end
					-- chksame rulekit
					if chksame then 
						if atotal >= IngredientRules.Amount then 
							if chksame then 
								cando = true 
							end 
						else
							rem[i] = true 
						end 
						atotal = 0 
					end 

				end 
				if chksame then 
					for i,v in pairs(rem) do 
						List.Used[IngredientName][i] = nil 
					end 
				end 
				List.Used[IngredientName].AmountNeeded = IngredientRules.Amount
			end
			print(atotal)
		--	List.Used[IngredientName].AmountNeeded = IngredientRules.Amount
			if atotal < IngredientRules.Amount then 
				if Recipe.DelFunc then 
					nok(IngredientName, "AFAmountCheck")
					Recipe.DelFunc(nokrules, List.Used)
				end 
				return false, 6
			elseif chksame and not cando then 
				if Recipe.DelFunc then 
					nok(IngredientName, "AFAmountCheck")
					Recipe.DelFunc(nokrules, List.Used)
				end 
				return false, 9 -- NOPE recipe same check fail
			end
		end
		if Recipe.DelFunc and gotnok then 
			Recipe.DelFunc(nokrules, List.Used)
		end  
	else 
		throw("recipe has no ingredients !?")
		return false, 1
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
function RecipeService:EvaluateRule(RuleName, RuleData, RuleSet, RuleType, Context, List, Recipe, WholeList, Mode)
	if not self.Rules[RuleName] then 
		throw(RuleName .. " a rulename does not exist")
		return false, 1
	end 
	
	local arglist = {
	RuleName = RuleName,
	RuleData = RuleData, 
	RuleSet = RuleSet, 
	RuleType = RuleType, 
	Context = Context, 
	List = List, 
	WholeList = WholeList, 
	Recipe = Recipe, 
	Mode = Mode 
}

	return self.Rules[RuleName](arglist)

end

return RecipeService 