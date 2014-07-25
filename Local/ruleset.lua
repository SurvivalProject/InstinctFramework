-- setup rules

local RecipeService = Instinct.Include "Services/RecipeService"

RecipeService:AddCategory("Furnace")


local functemplate = function (RuleData, RuleSet, RuleType, 
	Context, List, Recipe) end 


-- amount only function to receive the whole list
local function checkamount(RuleData, RuleSet, RuleType, 
	Context, List, Recipe, wl)
	local ingwant = RuleType[2]
	local have = 0
	local ok = false 
	local skipd = {"Explicit"}
	if List[ingwant] then 
		if #(List[ingwant]) >= RuleData then 
			ok = true 
			for i = 1, RuleData do 
				List.Used:Add(List[ingwant][i])
			end 	
		end 
	elseif not RuleData.Explicit then 
		for _,idata in ipairs(List) do 
			local obj = idata[2]
			if obj:HasConstant("Name", ingwant) then 
				have = have + 1 
				List.Used:Add(idata[1])

				if have >= RuleData then 
					ok = true 
					break 
				end
			end 
		end
	end 
	return ok, skipd
end

local function checktemp(RuleData, RuleSet, RuleType, 
	Context, List, Recipe, WholeList )
	local mode = RuleData[1]
	local eq = RuleData[2] 
	if mode == "L" then 
		for i,v in ipairs(List) do 
			if v:GetConstant("Temperature") > RuleData then 

			else 
				WholeList.Used:Delete(v)
			end 
		end 
		return true 
	end 
end 

local function chkloc(loc, what )
	return loc:HasConstant( what,true )
end 

local function checkfurnace(RuleData, RuleSet, RuleType, 
	Context, List, Recipe, WholeList)
	if Context.Location then 
		return chkloc(Context.Location, "IsFurnace")
	end 
end 

function checkmix(RuleData, RuleSet, RuleType, 
	Context, List, Recipe, WholeList)
	if Context.Location then 
		return chkloc(Context.Location, "IsMetalMixingDevice")
	end 
end 

RecipeService:AddRule("Amount", checkamount)
RecipeService:AddRule("Temperature", checktemp)
RecipeService:AddRule("Furnace", checkfurnace)
RecipeService:AddRule("MetalMixingDevice", checkmix)
