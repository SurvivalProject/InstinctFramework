--[[
	Create
	Purpose: 
		Return utilites	
	
	
--]]

local Create = {}

Create.__index = function(tab, index, value)
	return tab
end

Create.__call = function(tab, ...)
	if tab.Call then
		return tab.Call(...)
	end
end

Create.__newindex = function(tab, index, value)
	if index == "Parent" and type(value) == "table" then
		if tab.Parent then
			local id = tab.__childid
			value.__children[id] = nil
		end
		if not value.__children then 
			value.__children = {}
		end
		table.insert(value.__children, tab)
		rawset(tab, "Parent", value)
		rawset(tab, "__childid", #value.__children - 1)
	else
		rawset(tab,index,value)
	end
end

Create.__index = function(tab, index, value)
	local root = rawget(tab, "__root")
	if root then 
		local ri = root[index]
		if ri then
			return ri
		end
		local ext = root.__extend
		if ext then 
			return ext[value] -- Recursive
		end
	end
end

Create.Classes = {}

function Create.RegisterClassName(ClassName, data)
	if not Create.Classes[ClassName] then
		Create.Classes[ClassName] = data
	else
		print("[Instinct Error] Conflicting ClassNames: "..ClassName .. " (ClassName already registered)")
	end
end

function Create.Class() -- returns an empty class handler
	local new = {}
	return setmetatable(new, RegisterMeta)
end

function Create.Call(object)
	local new = {}
	local obj
	if type(object) == "string" then
		local cdata = Create.Classes[object]
		if cdata then
			obj = cdata
		end
	elseif type(object) == "table" then
		obj = object
	end
	if not obj then
		print("[Instinct Error] Could not load object: "..tostring(object))
		return nil
	end
	new.__root = obj
	setmetatable(new, Create)
	for i,v in pairs(obj) do
		print(i)
	end
	if new.Constructor then 
		new:Constructor()
	end
	return new
end

-- Instinct.Create.Extend(Fruit, Banana)
function Create.Extend(with, class)
	class.__extend = with
end

local RegisterMeta = {}

function RegisterMeta.__index(tab, index)
	local ext = rawget(tab, "__extend") 
	if ext then 
		return ext[index]
	end
end

function Create.Register(class) -- Needed to assign the metatables
	return setmetatable(class, RegisterMeta)
end

setmetatable(Create,Create)


return Create