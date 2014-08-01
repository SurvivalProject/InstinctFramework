-- Property provides a small context helper class
-- It can be used to serialize properties!

local Property = {}

Property.Type = "string" 
Property.Supported = {
	string=true,
	Vector3=false
}

function Property:Serialize(value)
	if not self.Supported[self.Type] then 
		throw("Serializing of " .. self.Type .. " is not suppored")
	end 
	if self.Type == "string" then
		return value 
	end 
end 

return Property