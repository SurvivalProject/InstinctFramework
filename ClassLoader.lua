-- Library utility to load all classes

local Class = require('Class')

local Classes = { 




}



Classes.LoadLib = function() 
	for i, ClassName in pairs(Classes) do 
		local class = require(game:GetService("ReplicatedStorage").Classes:FindFirstChild(ClassName))
		Class.CreateClass(ClassName, class)
	end
end 

return Classes