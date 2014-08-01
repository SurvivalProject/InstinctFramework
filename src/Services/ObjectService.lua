-- Resource service is a very specific high level service
-- It basically is a class system for objects
-- Objects can be everything:
-- Resources, tools, houses, etc.
-- It extends roblox parts and models by providing extra info 
-- on game entities 

-- Used on both server and client as LUT

-- recipe user guide;
-- > figure out if recipe can be created, take Uselist
-- > pass uselist to CreationService
--  > figure out if multipel options; if so, 
-- 			provide user choices
--  > if not; make
-- > this service will convert UseList resources to an
-- > actual roblox instance
-- > this is then returned
-- > it is not parented, 
-- > as buildings will need a different placement than resources

local Property = Instinct.Include "Action/Property"


local ObjectService = {}

-- x meters per studs; used for all kinds of calculations
ObjectService.StudsLength = 0.2 

ObjectService.ObjectData = {}
ObjectService.PropertyData = {}
ObjectService.PWarned = {}

warn("Need a property class")

function ObjectService:Constructor()
	self.ObjectData = {} -- global lut
	self.PropertyData = {} -- possible props
	self.PWarned = {}
end

function ObjectService:AddProperty(Name, PropertyData)
	local pfields = {
	Static = true;
	Dynamic = true;
	PValuesLut= true;
	PValues = true;
	}
	if PropertyData then
		for i in pairs(PropertyData) do 
			if not pfield[i] then 
				throwt("ObjectService", i .. " is not a valid property, not registering "..Name)
				return 
			end
		end 
	end 	
	self.PropertyData[Name] = PropertyData or {}
end 

-- possible static value values setter function
function ObjectService:AddPropertyValues(Name, Values)
	if not self.PropertyData[Name] then 
		throwt("ObjectService", Name .. "Object " .. Name .. " not available")
		return 
	end 
	local o = self.PropertyData[Name] 
	if o.PValues and o.PValuesLut then 
		for i,v in pairs(Values) do 
			if not o.PValues[v] then 
				table.insert(o.PValuesLut, v)
				o.PValues[v] = true 
			end
		end 
	else 
		o.PValuesLut = Values 
		o.PValues = {}
		for i,v in pairs(Values) do 
			o.PValues[v] = true 
		end 
	end 
end 

function ObjectService:AddObjects(list)
	for _, obj in pairs(list) do 
		self:AddObject(obj)
	end 
end

function ObjectService:GetObjectList()
	local out = {}
	for i,v in pairs(self.ObjectData) do
		table.insert(out, i)
	end 
	return out 
end


function ObjectService:AddObject(Object)
	-- if the resource has an extend field:
	--> check if extended resource is available
	--> not? throw error

	-- first warn for non-props 

	local excl = {ExtendedBy = true, __root = true }

	for i,v in pairs(Object) do 
		if not excl[i] then 
			if not self.PropertyData[i] and not self.PWarned[i] then 
				warn("Property " .. i .. " does not exist")
				self.PWarned[i] = true 
			end 
		end 
	end 

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

function ObjectService:GetInfo(ObjectName)
	local out = {}
	local o = self:GetObject(ObjectName)
	if not o then
		return nil 
	end 
	-- yay 
	function r(o)
		for i,v in pairs(o) do 
			if not out[i] then 
				out[i] = v 
			end 
			if i == "ExtendedBy" and self:GetObject(i) then 
				r(self:GetObject(i))
			end 
		end 
	end 
	r(o)
	return out 
end 

-- gets volume from rbx instance 
function ObjectService:GetVolume(inst)
	print(inst)
	return 1 
end 

-- returns a resource from name
-- with handy functions yay
function ObjectService:GetObject(ObjectName)
	if type(ObjectName) ~= "string" then 
		throw("Provide a string for ObjectService")
		return
	end 
	return self.ObjectData[ObjectName]
end 

-- gets a studvolume from GetMass and returns "real" volume
function ObjectService:ConvertStudVolume(studvolume)
	local Real = studvolume * self.StudsLength ^ 3
	-- is m^3
	return Real * 1000 -- is dm^3
end 

return ObjectService