-- Lightweight Lua class system 

--[[
	Goal: Create an efficient and fast Class system wich basic functionality
	Capable of creating and extending classes (with inheritance)

--]]

-- function throw
-- arg1: type (specify message type: warning, error, info, etc)
-- arg2: source (extra info where this error comes from, handy for debugging)
-- arg3..n: text to throw 
-- used later for visible output via several output GUIs to make this look pretty
function throw(type, source, ...)
	local text = {...}


end 


-- Readonly has some special values which we don't want to touch
local Readonly = {} 
local Classes = {}

local Class = {} 

function Class:__index(index)
	local ExtendClass = Classes[self.ClassName].Extends 
	return rawget(Classes[self.ClassName], index) or ExtendClass and rawget(Classes[ExtendClass], index)
end 

function Class:__newindex(index, value)
	if self.ClassName and not self == Classes[self.ClassName] then -- Trying to edit class base ? 
		rawset(self,index,value) -- OK
	else 
		if not self.ClassName then 
			throw("error", "instinct_core", "ClassName not specified in class!?")
		else 
			throw("warning", "instinct_core", "Reverted edit attempt to base class")
		end 
	end 
end 

function CreateClass(classname, base, extend)
	if classname and base then 
		base.ClassName = classname 
		Classes[classname] = base
		if extend then 
			base.Extends = extend 
		end 
		setmetatable(base, Class)
	else 
		if not classname then 
			throw("warning", "instinct_core", "ClassName not specified, cannot create class")
		end 
		if not base then 
			throw("warning", "instinct_core", "Base not specified, cannot create class")
		end 
	end 
end 

function Create(classname)
	-- the only thing a class should need is a ClassName, this points towards the right data in the registers
	local new = {}
	new.ClassName = classname 
	return setmetatable(new, Class)
end


-- extend food with fruit: Extend(food, fruit, base)
function Extend(extend_classname, new_classname, base) 
	CreateClass(new_classname, base, extend_classname)
end 

local CreateLib = {} 

CreateLib.Create = Create 
CreateLib.Extend = Extend 
CreateLib.CreateClass = CreateClass 

return CreateLib