-- A helper class to setup a valid context

local ObjectService = Instinct.Include "Services/ObjectService"

local Context = {}

function Context:SetLocation(rbxinstance)
	local o = ObjectService:GetObject(rbxinstance.Name)
	if o then 
		self.Location = o 
		self.RBXLocation = rbxinstance
	end
end

return Context




