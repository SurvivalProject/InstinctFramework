--[[
	Instinct
		Loads the Framework
		
	Usage:
		require(Instinct).Load("Client" | "Server")
		This will setup the Instinct Framework environment
		in the Instinct namespace
--]]

-- Probe environment


local pre = _G.__InstinctPresets

local ltype
if pre then
	ltype = pre.LoadType
end

if not pre then
	error("[Instinct Master Error] Could not load Instinct, _G.__InstinctPresests is not defined.")
end

if not ltype then
	error("[Instinct Master Error] Could not find LoadType, Instinct cannot load.")
end

-- Define Instinct lib
_G.Instinct = {} 
local Instinct = _G.Instinct

Instinct.Global = [=[
Version
Option
Create
Services/Locale
Event
]=]

Instinct.Term = [=[
Local/rbxinstance
]=]

Instinct.Client = [=[
Console
Menu
Utilities/Palette
Gui/Window
Gui/SelectionMenu
]=]

Instinct.Server = [=[
Utilities/ColorTools
Utilities/Palette
]=]

local root
local lfs 

-- Define error throw function 

function throw(err, level)
	print(err)
end 

if ltype == "term" then 
	lfs = require "lfs"
	root = lfs.currentdir()
	lfs.chdir("../Translator")
	prettyprint = require "prettyprint"
	WARNINGS = {}
	function print(...)
		prettyprint.write("Instinct", "info", ...)
	end 
	function throw(err, level)
		prettyprint.write("Instinct", "error", err)
	end
	function throwfrom(title, err, level)
		prettyprint.write(tostring(title), "error", err)
	end
	function printm(title, subject, ...)
		prettyprint.write(title, subject, ...)
	end 
	function warn(warning)
		printm("Instinct", "warning", warning)
		table.insert(WARNINGS, warning)
	end
	lfs.chdir(root)
else 
	root = game:GetService("ReplicatedStorage").Instinct
end 

prettyprint.write("Instinct", "info", "Welcome to Instinct!")

--[[ Instinct.Load
	@arg1: List (newline seperated module load list)
--]]
function Instinct.Load(List, only)
	for ModuleName in List:gmatch("[^\n]+") do 
		local newroot = root
		local objpointer = Instinct -- pointer to the table 
		local previous = objpointer
		if ltype == "term" then 
			lfs.chdir(root)
		end
		local LastNameTry
		for NameMatch in ModuleName:gmatch("(%w+)/?") do
			LastNameTry = NameMatch
			if ltype ~= "term" then 
				try = newroot:FindFirstChild(NameMatch)
			else 
				lfs.chdir(NameMatch)
				try = lfs.currentdir()
			end 
			if try then
				newroot = try
				if ltype ~= "term" and try:IsA("Model") and not objpointer[try.Name] then 
					objpointer[try.Name] = {} 
					previous = objpointer
					objpointer = objpointer[try.Name]
					
				elseif ltype == "term" and lfs.attributes(".").mode == "directory" and not objpointer[NameMatch] then 
					objpointer[NameMatch] = {}
					previous = objpointer
					objpointer = objpointer[NameMatch]
					
				elseif ltype ~= "term" and  try:IsA("Model") then
					previous = objpointer
					objpointer = objpointer[try.Name]
					
				elseif ltype == "term" and lfs.attributes(".").mode == "directory" then 
					previous = objpointer
					objpointer = objpointer[NameMatch]
				
				end
			else 
				newroot = nil 
				break
			end	
		end
		if ltype ~= "term" then 
			if newroot and newroot:IsA("ModuleScript") and previous then 
				local Name = newroot.Name
				print("Info", "Load: "..Name, newroot:GetFullName())
				local out = require(newroot)
				if type(out) == "table" and Instinct.Create and not out.__noreg then
					Instinct.Create.Register(out)
					Instinct.Create.RegisterClassName(Name, out)
				end
				previous[Name] = out
				if only then 
					return out
				end
			else
				print("Error", "Load: Unable to load module: "..ModuleName..", module does not exist!")
			end
		else 
			print(newroot,LastNameTry)
			if newroot and lfs.attributes(newroot .. "/" .. LastNameTry..".lua").mode == "file" and previous then 
				
				print("Info", "Load: "..LastNameTry, newroot)
				lfs.chdir(newroot)
				local my, err = require(LastNameTry)

				previous[LastNameTry] = my
		

				if type(my) == "table" and Instinct.Create and not my.__noreg and not LastNameTry == "Create" then 
					Instinct.Create.Register(my)
					Instinct.Create.RegisterClassName(LastNameTry, my)
				end
				
				if only then 
						if ltype == "term" then 
							lfs.chdir(root)
						end 
					return my 
				end
			end
		end 
	end
	if ltype == "term" then 
		lfs.chdir(root)
	end 
end

function Instinct.Include(name)
	return Instinct.Load(name, true)
end

function Instinct.Initialize(mode)
	if mode == "Server" then
		Instinct.Client = nil
		Instinct.Load(Instinct.Global)
		Instinct.Load(Instinct.Server)
	elseif mode == "Client" then
		Instinct.Server = nil
		Instinct.Load(Instinct.Global)
		Instinct.Load(Instinct.Client)
	elseif mode == "term" then 
		Instinct.Load(Instinct.Global)
		Instinct.Load(Instinct.Term)
	end
end

Instinct.Initialize(ltype)

return Instinct