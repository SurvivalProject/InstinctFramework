-- setup rules

local RecipeService = Instinct.Include "Services/RecipeService"

RecipeService:AddCategory("Furnace")


local functemplate = function (RuleData, RuleSet, RuleType, 
	Context, List, Recipe) end 


-- amount only function to receive the whole list
-- hard list of possible ingredients
-- returns a list of useable ingredients!
local function checkamount(arg)
	local ingwant = arg.RuleType[2]
	local have = 0
	local ok = false 
	local skipd = {"Explicit", "AmountType", "Same"}
	print(ingwant)
	if arg.List[ingwant] then 

			ok = true 
			for i = 1, #(arg.List[ingwant]) do 
				arg.List.Used:Add(ingwant, arg.List[ingwant][i])
			end 	
		 
	elseif not arg.RuleSet.Explicit then 
		for _,idata in ipairs(arg.List) do 
			local obj = idata[2]
			if obj:HasConstant("Name", ingwant) then 
				
				arg.List.Used:Add(ingwant, idata[1])

			--[[	if have >= RuleData then 
					ok = true 
					break 
				end--]]
			end 
		end
	end 
	return ok, skipd
end

local function checktemp(arg) 
	local mode = arg.RuleData[1]
	local eq = arg.RuleData[2] 
	if mode == "L" then 
		for i,v in ipairs(arg.List) do

			if arg.Mode == 2 then 
				printm("RuleCheck", "info", "check " .. arg.RuleType[2])
			end 
			local temp =  arg.List.Object:GetContext(v, "Temperature")
			if not temp then 
				throw("no temp var  found ")
				return false 
			end 
			if arg.Mode == 2 then 
				printm("RuleCheck", "info", "t value found, is " .. temp)
			end 
			if temp  > arg.RuleData[2] then 

			else 
				arg.WholeList.Used:Delete(RuleType[2], v)
				printm("RuleCheck", "info", "Removed " .. arg.RuleType[2] )
			end 
		end 
		return true 
	end 
end 

local function chkloc(loc, what )
	return loc:HasConstant( what,true )
end 

local function checkfurnace(arg)
	if arg.Context.Location then 
		return chkloc(arg.Context.Location, "IsFurnace")
	end 
end 

function checkmix(arg)
	if arg.Context.Location then 
		return chkloc(arg.Context.Location, "IsMetalMixingDevice")
	end 
end 

RecipeService:AddRule("Amount", checkamount)
RecipeService:AddRule("Temperature", checktemp)
RecipeService:AddRule("Furnace", checkfurnace)
RecipeService:AddRule("MetalMixingDevice", checkmix)
