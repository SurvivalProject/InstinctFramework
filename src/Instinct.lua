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

Instinct.Client = [=[
Menu
Utilities/Palette
Gui/Window
Gui/SelectionMenu
]=]

Instinct.Server = [=[
Utilities/ColorTools
Utilities/Palette
]=]

local root = game:GetService("ReplicatedStorage").Instinct

--[[ Instinct.Load
	@arg1: List (newline seperated module load list)
--]]
function Instinct.Load(List, only)
	for ModuleName in List:gmatch("[^\n]+") do 
		local newroot = root
		local objpointer = Instinct -- pointer to the table 
		local previous = objpointer
		for NameMatch in ModuleName:gmatch("(%w+)/?") do
			local try = newroot:FindFirstChild(NameMatch)
			if try then
				newroot = try
				if try:IsA("Model") and not objpointer[try.Name] then 
					objpointer[try.Name] = {} 
					objpointer = objpointer[try.Name]
					previous = objpointer
				elseif try:IsA("Model") then
					objpointer = objpointer[try.Name]
					previous = objpointer
				end
			else 
				newroot = nil 
				break
			end	
		end
		if newroot and newroot:IsA("ModuleScript") and previous then 
			local Name = newroot.Name
			print("[Instinct Info] Load: "..Name, newroot:GetFullName())
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
			print("[Instinct Error] [Load]: Unable to load module: "..ModuleName..", module does not exist!")
		end
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
	end
end

Instinct.Initialize(ltype)

return Instinct