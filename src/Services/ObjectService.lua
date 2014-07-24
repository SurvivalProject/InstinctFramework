-- Resource service is a very specific high level service
-- It basically is a class system for objects
-- Objects can be everything:
-- Resources, tools, houses, etc.
-- It extends roblox parts and models by providing extra info 
-- on game entities 

-- Used on both server and client as LUT

local ObjectService = {}

-- x meters per studs; used for all kinds of calculations
ObjectService.StudsLength = 0.2 

function ObjectService:Constructor()
	self.ObjectData = {}
end

function ObjectService:AddObject(Object)
	-- if the resource has an extend field:
	--> check if extended resource is available
	--> not? throw error
	if Object.ExtendedBy then 
		if type(Object.ExtendedBy) == "string" then 
			if not self.ObjectData[Object.ExtendedBy] then 
				throw(Object.ExtendedBy .. " does not exist")
				return
			end 
		elseif type(Object.ExtendedBy) == "table" then 
			local ok = true 
			for i,v in pairs(Object.ExtendedBy) do 
				if not self.ObjectData[v] then 
					ok = false 
					throw(i .. " does not exist")
				end
			end
			if not ok then 
				return 
			end 
		end
	end 
	if self.ObjectData[Object.Name] then 
		throw (Object.Name .. " already exists")
	end 
	self.ObjectData[Object.Name] = Object 
end 

-- returns a resource from name
-- with handy functions yay
function ObjectService:GetObject(Object)
	return self.ObjectData[Object.Name]
end 

-- gets a studvolume from GetMass and returns "real" volume
function ObjectService:ConvertStudVolume(studvolume)
	local Real = studvolume * self.StudsLength ^ 3
	-- is m^3
	return Real * 1000 -- is dm^3
end 

