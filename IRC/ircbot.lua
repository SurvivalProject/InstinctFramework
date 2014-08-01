local socket = require "socket"

local client = socket.tcp()
local status, err = client:connect("chat.freenode.net", 6667)
client:settimeout(1)

local IRC = {}

IRC.Client = client

IRC.SendBuffer = {}

function IRC:SendData(data)
local client = self.Client 
--print(" >>>>> "..data)
client:send(data.."\n\r")
end
IRC.Client = client
IRC.DidUSER = false
IRC.Received = 0

recvt = {server, client}
sendt = {server, client}

local Receiver = {}

Receiver.SendBuffer = {}

Receiver.JobToName = {}
Receiver.NameToJob = {}
Receiver.ServerCounter = 1

function IRC:CheckPING(msg)
	if msg and msg:match("^PING") then 
		local PONG = string.gsub(msg, "^PING", "PONG")
		self:SendData(PONG)
	end
end

function IRC:GetChat(msg) -- returns chan and text
	if msg:match("PRIVMSG") then 
		local chan = msg:match("PRIVMSG (#?[%S]+)")
		local rest = msg:match("PRIVMSG #?[%S]+%s*:(.*)")
		local user = msg:match(":([^!]*)")
		if chan and user and rest then 
			local clen = chan:len()
			local replen = 30 - clen 
			local rep = "  --  " .. chan .. "  --  "
			print(rep)
			print(user..": "..rest)
			print( "  --  " .. (string.rep(" ", chan:len())) .. "  --  " )
		end 

		return chan, rest, user
	end
end

function IRC:Chat(chan, msg )
	self:SendData("PRIVMSG "..chan.." :"..msg)

end

IRC.Version = "Minimal Lua Uplink V1.0"


function IRC:CheckChanMSG(msg)
	local chan, rest, user = self:GetChat(msg)
	if rest and rest:match("%$") then 
		local cmd, arg = rest:match("%$([%S]*)%s*(.*)")
		print("split", cmd,arg)
		if cmd then 
			pcall(function() 
			local rep = self["Eval"..cmd] and self["Eval"..cmd](arg)
			if rep then  
				self:Chat(chan, user..": "..tostring(rep))
			end
			end)
		end
	end
end


function IRC:CheckMSG(msg) -- all check functions for msg here
	if not msg then return end
	self:CheckPING(msg)
	self:CheckChanMSG(msg)
end 

function IRC:JoinChannel(chan_name)
	self:SendData("JOIN "..chan_name)
end

function IRC:ReceiveData()
	--self.Client:send("PING test\n\r")
	if not self.DidUSER then 
	self:SendData("PASS " .. self.Pass)
	self:SendData("NICK " .. self.Nick)
	self:SendData("USER " .. self.Nick .. " . . :" .. self.OName)
	end

	local msg = self.Client:receive()
	if msg then 
		self.Received = self.Received + 1
	end 
	if msg then 
		print(msg)
	--	print(msg)
		if msg then 
			 self.Received = self.Received + 1
		end
		self:CheckMSG(msg)
		repeat 
			msg = self.Client:receive()
			if msg then 
			print(msg)
			end
			self:CheckMSG(msg)
			if msg then 
				self.Received = self.Received + 1
			end
		until msg == nil
	end
	--print(self.Received)

	if not self.DidUSER and self.Received >= 3 then
		self:SendData("PASS " .. self.Pass)
		self:SendData("NICK " .. self.Nick)
		self:SendData("USER " .. self.Nick .. " . . :" .. self.OName)
		self.DidUSER = true
	elseif self.Received > 10 and not self.DidInit then 
		self.DidInit = true
		self:Chat("NickServ", "IDENTIFY " .. self.Pass)
		self:JoinChannel("#Stranded")
		self:JoinChannel("#SurvivalGames")
	end
end

return IRC 
