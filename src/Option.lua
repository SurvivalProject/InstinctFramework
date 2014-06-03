--[[
	Option
	Purpose:
		Create Option functions
		Similiar to roblox enums
		The name "Option" is chosen in order to prevent confusion
		Roblox uses enums
		Instinct uses options
	
--]]

-- DEFINE ALL OPTIONS HERE!

local Options = {}

local opt_meta = {}

function opt_meta:__tostring()
	return "Option."..self[1]..self[2]
end

function Options.New(option_type, option_list)
	Options[option_type] = {}
	for i,v in pairs(option_list) do
		Options[option_type][v] = {option_type, v}
		Options[option_type][i] = Options[option_type][v]
		setmetatable(Options[option_type][v], opt_meta) -- tostring
	end
end

-- 

Options.New("ConsolePriority", {"Low", "Normal", "High", "Extreme"})

return true