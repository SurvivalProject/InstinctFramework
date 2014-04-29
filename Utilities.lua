-- Sets up global vars

local Utilities = {}

function Utilities.throw(type, source, ...)
	local text = {...}
	print(type, source, ...)

end 

local function Utilities.get(where, what)
	return where:FindFirstChild(what)
end

local function Utilities.IsServer() 
	return script.ClassName == "Script"
end 

local function Utilities.IsClient() 
	return script.ClassName == "LocalScript"
end

local function Utilities.LoadLib()
	for i,v in pairs(self) do 
		if i ~= "Load" then 
			getfenv()[i] = v 
		end 
	end 
end

return Utilities