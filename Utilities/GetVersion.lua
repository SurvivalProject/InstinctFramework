
local tabescape =  string.char(1)..string.char(2)..string.char(3).."___tab_"..string.char(1).."__"

require "LuaXML"
local lfs = require "lfs"

local arg = {...}

lfs.chdir("../src")
local version, err = io.open("../src/Version.lua")

if not version then 
print(err)
	
else 

local line = version:read("*all")
version = line:match("%d+%.%d+%.%d+")
--print(version)
if not version then 

end
end 

if not version then 
	version = "0.0.0"
end

function IsNewVersion(old, new)
	local old_1, old_2, old_3 = old:match("(%d+)%.(%d+)%.(%d+)")
	local new_1, new_2, new_3 = new:match("(%d+)%.(%d+)%.(%d+)")
	OLDVERSION = old_1.."."..old_2.."."..old_3
	NEWVERSION = new_1.."."..new_2.."."..new_3
	if old_1 <= new_1 and old_2 <= new_2 and old_3 <= new_3 then 
		return true 
	end 
	return false 
end 

-- LuaXML the fuck why don't you support newlines!?

local src = io.open("../source.rbxm")
local src = src:read("*all"):gsub("&#9;", tabescape)


local src = xml.eval(src)
--print(src)

local data = {}


function getname(source)
	local try = xml.find(source, "Properties")
	if try then 
		local try2 = xml.find(try, "string", "name", "Name")
		return try2[1]
	end
end 

function getsrc(source)
	local try = xml.find(source, "Properties")

	if try then 
		local try2 = xml.find(try, "ProtectedString", "name", "Source")
		--print(tostring(try2[1]):gsub(tabescape,"\t"))
		return tostring(try2[1]):gsub(tabescape,"\t")
	end
end 

local gotroot = false

local DIRECTORIES = 0
local FILES = 0

function scan(rbxm, flush)
	for _, value in pairs(rbxm) do 
		if value.class == "Model" then 
			local name = getname(value)
			if name then 
				DIRECTORIES = DIRECTORIES + 1
				local current = flush
				if not gotroot then
					gotroot = true 
				else  
					flush[name] = {}
					current = flush[name]
				end 
				scan(value, current)
			end
		elseif value.class == "Script" then 
			--print(value)
			FILES = FILES + 1
			local s = getsrc(value)
			if s then 
				local n = getname(value):gsub(".lua", "")

				if n then 
					flush[n] = s
				end 
			end
		end
	end 
end

scan(src, data)
--print(data.Version)
local newversion = data.Version 


	local old = version or "0.0.0"
	local new = newversion or "0.0.0"
	local old_1, old_2, old_3 = old:match("(%d+)%.(%d+)%.(%d+)")
	local new_1, new_2, new_3 = new:match("(%d+)%.(%d+)%.(%d+)")
	OLDVERSION = old_1.."."..old_2.."."..old_3
	NEWVERSION = new_1.."."..new_2.."."..new_3
	return OLDVERSION, NEWVERSION, IsNewVersion(old, new) 
