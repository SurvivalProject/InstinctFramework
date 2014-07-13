local server = {}

local copas = require "copas"
local socket = require "socket"
local prettyprint = require "prettyprint"
local http = require "http"
local lfs = require "lfs"
local event = require "event"

local html = require "lhtml"

-- I heard you didnt like PHP
-- So we use lau


server.IP = "127.0.0.1"
server.Port = 80 

server.RQs = 0

server.webdir = "./web"

function server:new()
	return setmetatable({}, {__index=self})
end 

function server:Initialize()

	self.socket = socket.tcp()
	prettyprint.write("server", "info", "Starting server...")
	local ok, err = self.socket:bind("127.0.0.1",80)
	if ok then 
		prettyprint.write("server", "info", "Server online!")
	else 
		prettyprint.write("server", "error", "Server error: "..tostring(err))
		os.exit()
	end 
	local listen = self.socket:listen()
	if listen then 
		prettyprint.write("server", "info", "Server is listening.")
	end 
	copas.addserver(self.socket, function(...) self.handle(self, ...) end)
end

function server:Start()
	while true do 
		copas.step()
	end 
end

-- SERVER HANDLE IS A THREAD IT CLOSES LE CONNECTION ONCE IT RETURNS
-- oh yes copas 
-- oh yes

function server.getpage(page)
	local i,err = io.open(self.webdir .. page, "r")
	if not i then 
		prettyprint.write("server", "error", "fopen: " .. err)
		return nil
	end
	if page:match("*.lua") then 
		return loadstring(i:read("*a"))()
	else 
		return i:read("*all")
	end
end

server.handle = function(self,conn, efc, tr)
	self.RQs = self.RQs + 1
	local id = self.RQs 
	prettyprint.write("server", "info", "New connection, id: "..self.RQs)
	local request = copas.receive(conn, "*l")
	local METHOD, PAGE, VERSION 
	local cname = "Client " .. id .. " "
	if request then 
		local method, page, version = http.getrequest(request)
		if method and page and version then 
			prettyprint.write("server", "info", cname .. method .. " request on page: " .. page .. " (HTTP: "..version..")")
			local cl = http.getclen(conn, copas.receive)
			if cl then 
				prettyprint.write("server", "info", cname.. " Content Length: ".. tostring(cl) )
			end

			if page:match("%.") or page:match("^/") then 
				-- oh really...
				rq = http.response(404, {"Cache-Control = no-cache"})
			end

			local rq = http.response(200, {"Cache-Control: no-cache"},"<!DOCTYPE html>\n<head><body>Hi</body></head>")
			copas.send(conn, rq)
		end

	end
	io.read()
end 

--[[copas.addserver(server, handle)
copas.loop()

--]]


return server 