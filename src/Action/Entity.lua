-- An entity is any in-game object such as a building, like furnaces, which is not a resource

local Entity = {}

-- resources are instances;
-- for testing use strings with a .Name field 

function Entity:AddResource(resource)
	if not self.Contents then 
		self.Contents = {}
	end 
	table.insert(self.Contents, resource )
end 

function Entity:RemoveResource(resource)
	if not self.Contents then 
		self.Contents = {}
		throw 'An attempt has been made to remove a resource from never-filled entity'
	end 
	local index
	for i,v in pairs(self.Contents) do 
		if v == Resource then 
			index = i 
			break 
		end 
	end 
	if index then 
		table.remove(self.Contents, index)
	end
end 

return Entity 