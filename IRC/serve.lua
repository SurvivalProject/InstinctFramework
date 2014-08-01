irc = require "ircbot"

irc.Nick = "InstinctBot"
irc.OName = "InstinctBotService"

print("enter pwd")
irc.Pass = io.read()

function neweval()
	local opr = package.loaded 
	local alrd = {}
	for i,v in pairs(opr) do 
		alrd[i] = true 
	end 
	local op = print
	Instinct = nil 
	function print() end
	local _, err = pcall(function() 
		dofile("../Local/main.lua")
		end)
	print=op
	for i,v in pairs(package.loaded) do 
		if not alrd[i] then 
			package.loaded[i] = nil 
		end 
	end  

	return err 
end

function irc.EvalObjects()
	local err = neweval()
	if Instinct then 
	local out = ""
	local o = Instinct.Services.ObjectService:GetObjectList()
	return table.concat(o, ", ")
	else 
		return err 
	end 
end 

function irc.EvalOInfo(arg)
	local err = neweval()
	if Instinct then 
		local s = Instinct.Services.ObjectService 
		local l = s:GetInfo(arg) 
		if l then 
			local out = ""
			for i,v in pairs(l) do 
				out = out ..  tostring(i) .. ": "..tostring(v).."; "
			end 
			return out 
		else 
			return tostring(arg) .. " not found in OSLUT"
		end 
	else 
		return err
	end 
end 

function irc.EvalEval(arg)
	neweval()
	local func = loadfile("../Local/IRCReq.lua")
	if func then 
		return func(arg, irc )
	else 
		return "an error occured"
	end 
end 


if irc.Pass ~= "" then 
	while true do 
		irc:ReceiveData()
	end
end 