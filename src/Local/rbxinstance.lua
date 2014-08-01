local Instance = {}

-- for local testing.

function Instance:new(classname)
	return setmetatable({ClassName = classname}, {__index=self})
end 

function Instance:FindFirstChild(what)
	--printm("RBX-TestInstance", "info", "FFC call: " .. what )
	if self.Children and self.Children[what] then 
		return self.Children[what][1]
	end 
end 

function Instance:GetChildren() 
	local my = {}
	if not self.Children then 
		return my 
	end 
	for i,v in pairs(self.Children) do 
		for ind, val in pairs(v) do 
			table.insert(my, val) 
		end 
	end 
	return my
end 

function Instance:SetParent(parent)
	-- haxy 
	if parent == nil then 
		throw (" provide a parent ")
	end 
	rawset(self, "Parent", parent)
	if not parent.Children then 
		parent.Children = {} 
	end 
	if not parent.Children[self.Name] then 
		parent.Children[self.Name] = {self} 
	else 
		table.insert(parent.Children[self.Name], self)
	end 
end 

return Instance