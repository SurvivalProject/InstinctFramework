local CreationService = {}

local Object = Instinct.Include "Action/Object"
local ObjectService = Instinct.Include "Services/ObjectService"

function CreationService:Create(UsageList, Recipe)

end 

CreationService.CodeMap = {
	[1] = "The recipe can only be created in one way: no leftovers",
	[2] = "The recipe has more ways to be created (more ingredient names)",
	[3] = "The recipe has only one way to be created in terms of the name of the ingredients, however, there are leftovers. This should be harmless in most cases, except if some items are better than one another.",
}

function CreationService:GetStatusInfo(code)
	return self.CodeMap[code] or "no info found on this status code"
end 

function CreationService:DeleteFromUsageListIfExist(NOKLIST, used, IfExist)
	if NOKLIST[IfExist] then 
		for UseName, Data in pairs(used) do 
			print("usename", UseName)
			for RealName, List in pairs(Data) do 
				print("rn", Realname)
				if type(List) == "table" then 
					for i, ActualItem in ipairs(List) do 
						print("World has to delete " .. RealName .. " from the world as there is not Metal Container available!!")
					end
				end
			end 
		end 
	end
end 


-- figures out if there is only one way to create the item, (1)
-- or more ways (2)
-- or, more ways, but no other objnames found (3) (in most cases this results in a good output, so this could lead to same behaviour as with (1) )
-- returns a list for every IngredientName which could be created

-- listobjects = {o = sizeused}

-- name = {listobjects, OnlyOneName = false/true, LeftOvers = 0}
-- name = {objname1 = {listobjects}, objname2 = {listobjects}}

-- in the last case the "same" rule is applied
-- for instance, use the same types of wood
-- then let user chose which wood;
-- for 

function CreationService:CanCreateImmediate(UsageList, Recipe)
	local out = {} 
	local HasMoreNames = false 
	local HasLeftoverResources = false 

	print("Checking for CCI ")

	local skip = {
		AmountNeeded = true, 
	}

	for IngredientName, IData in pairs(UsageList) do 
		--hastobesame
		local HTBS = Recipe.Ingredients[IngredientName].Same
		local VCheck = Recipe.Ingredients[IngredientName].AmountType == "Volume"
		local need = IData.AmountNeeded
		local current = 0 
		local leftovers = 0 -- amount leftover
		local use = {}
		local puse = use 
		local got = false 
		local ing = 0 
		print("chk", IngredientName)
		out[IngredientName] = use
		for IName, IOtherData in pairs(IData) do 
			print("check variation", IName, IngredientName)
			if not skip[IName] then 
				print(IName)
				ing = ing + 1
				if HTBS then 
					current = 0 
					use[IName] = {}
					puse = use[IName]
					got = false 
					leftovers = 0
				end  
				puse.LeftoverAmount = 0
				for i, RBXInstance in pairs(IOtherData) do 
					print(i)
					if type(i) == "number" then 
						local cvol = 1 
						if VCheck then 
							cvol = ObjectService:GetVolume(RBXInstance)
							current = current + cvol 
						else 
							current = current + 1
						end 			

						if current >= need then 	

							if not got then 
								leftovers = leftovers + current - need 
								got = true 
							else 
								print(need, current, "HL")
								leftovers = leftovers + cvol 
								HasLeftoverResources = true 
								puse.LeftoverAmount = puse.LeftoverAmount + 1 
							end 
						end 
					end 
					table.insert(puse, {RBXInstance, cvol})
				end 

				puse.LeftOvers = leftovers
				use.MoreTypes = ing > 1 
				HasMoreNames = HasMoreNames or ing > 1
			end
		end 
		use.Needed = need 
	end 
	-- well lets return a status then
	local status = 1 
	if HasMoreNames then 
		status = 2 
	elseif HasLeftoverResources then 
		status = 3 
	end 
	return use, status 
end


return CreationService 