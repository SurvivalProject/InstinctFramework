-- Instinct loading module

-- Should run as script, not as module

local LibraryManager = require("LibraryManager")
local Configuration = require ("Configuration")

local Libraries = {
	"Class", "Utilities",

}

function LoadAllLibraries() 
	for i,v in pairs(Libraries) do 
		LibraryManager:LoadLibrary(v)
	end
end 

LoadAllLibraries()