local SE_EnumBase = {}

local EnumMetatable = {} -- Basic redirects

function EnumMetatable:__tostring()
	return self.Name
end

function CreateEnum(EnumName, EnumData)
	if type(EnumName) == "string" and type(EnumData) == "table" then
		SE_EnumBase[EnumName] = {}
		for i,v in pairs(EnumData) do
			print(v)
			local new = {Name = v, __se_type= "SE_Enum"}
			setmetatable(new, EnumMetatable)
			SE_EnumBase[EnumName][v] = new
		end
	end
end

SE_Enum = {}

-- Yay redirect functions

local Tracer = {} -- Enum tracer function - temporary
Tracer.__metatable = true -- NO we don't want you to getmetatable
function Tracer:__index(Index)
	return SE_EnumBase[self.root][Index]
end

function Tracer:__newindex()
	return
end

local Meta = {}
function Meta:__index(Index)
	local Get = SE_EnumBase[Index]
	local ETrace = {root=Index}
	return setmetatable(ETrace, Tracer)
end

Meta.__metatable = true
Meta.__newindex = function() return end

setmetatable(SE_Enum, Meta)

local RetLib = {} 

RetLib.LoadLib = function() 
	getfenv().CreateEnum = CreateEnum
end 