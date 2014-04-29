-- Instinct loading module

-- Should run as script, not as module

--[[ 
	Usage: 
		Event: 
				Create Event (as class)
		Enum:
				CreateEnum
		Utilities are loaded in global environment


--]]


local LibraryManager = require("LibraryManager")
local Configuration = require ("Configuration")

local Libraries = {
	"Class", "Utilities", "Event", "Enum"

}

function LoadAllLibraries() 
	for i,v in pairs(Libraries) do 
		LibraryManager:LoadLibrary(v)
	end
end 

LoadAllLibraries()