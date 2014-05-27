print("\n\n / INSTINCT FRAMEWORK UTILITY SCRIPT \\")
print("Dependencies: LuaXml, LuaFileSystem")

-- Stupid escape sequence because LuaXML doesnt support tabs!? the fuck!?

local tabescape =  string.char(1)..string.char(2)..string.char(3).."___tab_"..string.char(1).."__"

require "LuaXML"
local lfs = require "lfs"

print("This lua script will update the src directory with the provided model")
print("Please make sure that the version string (format %d+.%d+.%d+) is updated")

local arg = {...}

if arg[1] ~= "-f" and arg[2] ~= "-f" then 
	print("Press any key to continue or q to quit")
	print("You can also call this with -f to disable this prompt!")
	local r = io.read()
	if r == "q" then 
		os.exit()
	end
end

lfs.chdir("../src")
local version, err = io.open("../src/Version.lua")

if not version then 
	print("Could not open ../src/Version.lua")
	print(err)
	
else 

local line = version:read("*all")
version = line:match("%d+%.%d+%.%d+")

if not version then 
	print("Could not read version")
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
	print(OLDVERSION, NEWVERSION)
	print(old_1 <= new_1 , old_2 <= new_2 , tonumber(old_3) < tonumber(new_3))
	if tonumber(old_1) <= tonumber(new_1) and tonumber(old_2) <= tonumber(new_2) and tonumber(old_3) < tonumber(new_3) then 
		return true 
	end 
	return false 
end 

-- LuaXML the fuck why don't you support newlines!?

local src = io.open("../source.rbxm")
local src = src:read("*all"):gsub("&#9;", tabescape)


local src = xml.eval(src)

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
			FILES = FILES + 1
			local s = getsrc(value)
			if s then 
				local n = getname(value)
				if n then 
					flush[n] = s
				end 
			end
		end
	end 
end
--print(src)
scan(src, data)

local newversion = data.Version 

if arg[1] == "-version" or arg[2] == "-version" then 
	local old = version 
	local new = newversion
	local old_1, old_2, old_3 = old:match("(%d+)%.(%d+)%.(%d+)")
	local new_1, new_2, new_3 = new:match("(%d+)%.(%d+)%.(%d+)")
	OLDVERSION = old_1.."."..old_2.."."..old_3
	NEWVERSION = new_1.."."..new_2.."."..new_3
	return OLDVERSION, NEWVERSION, IsNewVersion(old, new) 
end 

if not newversion then 
	print("Could not read Include.Version")
	os.exit()
end 

lfs.chdir("..")


function delete(dir)
	for file in lfs.dir(dir) do 
		if file ~= "." and file ~= ".." then 
			local path = dir .. "/" .. file 
			local attributes = lfs.attributes(path) 
			if attributes.mode == "directory" then 
				delete(path)
				os.remove(path)
			else 
				os.remove(path)
			end 
		end 
	end 
end

local cdirs = 1 
local cfiles = 0

function upd()
	print("Progress: Directories: "..cdirs.."/"..DIRECTORIES..", Files: "..cfiles.."/"..FILES.."!")
end

function convdir(table)
	for Name, Data in pairs(table) do 
		if type(Data) == "table" then 
			lfs.mkdir(Name)
			lfs.chdir("./"..Name)
			cdirs = cdirs + 1
			upd()
			convdir(Data)
			lfs.chdir("..")
		else 
			lfs.touch(Name..".lua")
			cfiles = cfiles + 1
			upd()
			local file = io.open(Name..".lua", "w")
			file:write(Data)
		end
	end
	upd()
end


if not IsNewVersion(version, newversion) then 
	print(version, newversion)
	print("Trying to update with old / same version, please update Include/Version.lua")
	os.exit()
else
	print("Is new version... starting update..")
	print("Removing old source ....")
	delete("./src")
	print("Deleted src")
	lfs.chdir("./src")
	convdir(data)
end

print(OLDVERSION.. " --> ".. NEWVERSION)
print("DONE")