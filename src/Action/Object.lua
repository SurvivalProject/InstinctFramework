-- An object is a very abstract class
-- It holds info on game objects
-- Game objects are anything;
--> Tools
--> Resources
--> Buildings

--> WARNING
--> DO NOT CREATE NEW OBJECTS FOR EVERY ROBLOX INSTANCE
--> THE OBJECT INSTINCT INSTANCE SHOULD BE USED
--> TO LOOK UP INFO ON THE OBJECT CONTEXT

-- context and properties are basically the same
-- easire to branch between 

-- NOTE
-- For some objects we want a general "object"
-- such as a Crucible
-- but multiple "tiers" of it
-- ex: Bronze Crucible
-- In order to manage to do this use the following:
--> The in game identifier should be Crucible
--> A context variable should be set: the tier
--> This is of course derived from the bronze "object"
--> Which is a helper object to figure out the properties for
-- bronze
--> The in game name should be stored in a variable to 
-- make sure it shows correctly on GUIs

local Object = {}

local ObjectService = Instinct.Include( "Services/ObjectService" )

Object.InfoName = 'objinfo'
Object.ContextName = "contextinfo"
Object.InfoClassName = "Configuration"

-- ExtendedBy: 
--> string (extend one object)
--> table (extend more objects)

Object.ExtendedBy = nil 

function Object:CreateExtension(name)
	if self.Name ~= "Object" then 
		local new = Instinct.Create(self)
		new.ExtendedBy = self.Name 
		new.Name = name or "Object"
		return new 
	else 
		throw "rename object first"
	end
end 

local IsServer = _G.__InstinctPresets.LoadType == "Server"
local IsTerm = _G.__InstinctPresets.LoadType == "term"

-- We will first define some helper functions
-- These make an easy Instinct <-> Roblox transition

function Object:SetPropertyCat(Instance, PropertyName, Value, Cat)
	if Instance:FindFirstChild(Cat) == nil then 
		if IsServer then 
			-- Okay to create
			local new = Instance.new(self.InfoClassName, Instance)
			new.Name = Cat
		elseif IsTerm then 
			local new = Instinct.Local.rbxinstance:new(self.InfoClassName)
			new.Name = Cat
			new:SetParent(Instance)
		else 
			throw("No server contact rule defined yet - no action taken")
			return 1
		end
	end	

	local typeof = type(Value)
	local make
	if typeof == "number" then 
		make = "NumberValue"
	elseif typeof == "string" then 
		make = "StringValue"
	end

	if IsServer and make then 
		local my = Instance.new(make, Instance[Cat])
		my.Value = Value 
		my.Name = PropertyName
	elseif IsTerm and make then 
		local my = Instinct.Local.rbxinstance:new(make)
		my.Name = PropertyName
		my.Value = Value 
		my:SetParent(Instance:FindFirstChild(Cat))
	end
end 

function Object:SetProperty(Instance, PropertyName, Value)
 	self:SetPropertyCat(Instance, PropertyName, Value, self.InfoName)
end 

function Object:SetContext(Instance, ContextName, Value)
	self:SetPropertyCat(Instance, ContextName, Value, self.ContextName)
end 

function Object:GetProperty(Instance, PropertyName)
	if Instance:FindFirstChild(self.InfoName) then 
		local this = Instance:FindFirstChild(self.InfoName):FindFirstChild(PropertyName)
		if this then 
			return this.Value
		end 
	end
end 

function Object:GetContext(Instance, PropertyName)
	if Instance:FindFirstChild(self.ContextName) then 
		local this = Instance:FindFirstChild(self.ContextName):FindFirstChild(PropertyName)
		if this then 
			return this.Value
		end 
	end
end 

-- contact objservice to figure out all possible constants
-- returns a table with these constants
-- we must recurse (dammit)
function Object:GetConstant(const)
	local out = {}
	if self[const] then 
		table.insert(out, self[const])
	end 
	if self.ExtendedBy then 
		if type(self.ExtendedBy) == "string" then 
			local other = ObjectService:GetObject(self.ExtendedBy)
			if not other then 
				throw(self.ExtendedBy .. " is not a valid object")
				return 
			end 
			local data = other:GetConstant(const)
			for _,c in pairs(data) do 
				table.insert(out, c)
			end 
		elseif type(self.ExtendedBy) == "table" then 
			for _, obj in pairs(self.ExtendedBy) do 
				local other = ObjectService:GetObject(obj)
				local data = other:GetData(const) 
				for _,c in pairs(data) do 
					table.insert(out, c)
				end 
			end 
		end 
	end 
	return out 
end 

-- figures out if the object has a ceratin constant 
function Object:HasConstant(const, val)
	-- figuring out if value is ok
	printm("Object", "info", "checking for constant " .. const )
	local values = self:GetConstant(const)
	for _, value in pairs(values) do 
		if value == val then 
			return true 
		end 
	end 
	return false 
end 

return Object