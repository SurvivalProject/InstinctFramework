local Event = {} 

local Class = require("Class")

Event.Disabled = false 

function Event:connect(func)
	if not self.CallList then 
		self.CallList = {}
	end 
	local Signal = {root = self}
	function Signal:disconnect()
		for i,v in pairs(self.root.CallList) do 
			if v == func then 
				table.remove(self.root.CallList, i)
				break 
			end 
		end 
	end 
	table.insert(self.CallList, func)
	OLDPRINT("CONNECTED")
	return Signal
end 

function Event:Disable()
	self.Disabled = true 
end 

function Event:Enable()
	self.Disabled = false 
end 

function Event:DisconnectAll()
	if self.CallList then 
		self.CallList = {}
	end 
end

function Event:Fire(...)
	--OLDPRINT("EVENT FIRE!")
	if not self.Disabled then 
		for i,v in pairs(self.CallList or {}) do
			local arglist = {...} -- What the heck lua syntax!? Y U NO PASS DEM
			delay(0, function() v(unpack(arglist)) end)
		end
	end 
end 

Event.fire = Event.Fire

local EVT = {Class = Event}

EVT.LoadLib = function() 
	Create.CreateClass("Event", EVT.Class)
end

return EVT
