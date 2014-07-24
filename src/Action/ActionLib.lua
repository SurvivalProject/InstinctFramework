-- ActionLib is the general high level bindings for the actions 

local ActionLib = {} 

function ActionLib:GetActions(context)

end

function ActionLib:RegisterAction(action, contextcat)
	if self.Data[contextcat] then 
		table.insert(self.Data[contextcat], action)
	else 
		self.Data[contextcat] = {action}
	end 
end 

