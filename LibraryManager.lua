local LibraryManager = {}

LibraryManager.Libraries = {}

function LibraryManager:GetLibraryData(LibraryName)
	if game:GetService("ReplicatedStorage"):FindFirstChild(LibraryName) then 
		return require(game.ReplicatedStorage[LibraryName])
	end 
end

function LibraryManager:LoadLibrary(LibraryName)
	local lib = self:GetLibraryData(LibraryName)
	if lib and not lib.LoadLib then 
		self.Libraries[LibraryName] = lib
	elseif lib.LoadLib then 
		lib.LoadLib()
	else 
		throw("error", "library manager", "Could not load library: ".. tostring(LibraryName))
	end
end  

