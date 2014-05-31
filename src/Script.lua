local Event = {}

local meta = {}
meta.__call = function()
	local new = {}	
	return setmetatable(new, meta)
end

meta.__index = Event

local Connection = {}

function Connection:disconnect()
	for i,v in pairs(self.Root.ConnectionList) do 
		if v == self.func then 
			self.Root.ConnectionList[i] = nil
			break
		end
	end
	
end



function Event:connect(func)
	if not self.ConnectionList then
		self.ConnectList = {}
	end
	table.insert(self.ConnectionList, func)
	local conn = {}
	setmetatable(conn, {__index = Connection})
	conn.Root = self
	conn.func = func
end

function Event:fire(...)
	if self.ConnectionList then 
		for i,v in pairs(self.ConnectionList) do 
			local args = {...}
			delay(0, function() 
				v(unpack(args))
			end)
		end
	end
end

return Event