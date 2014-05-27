local root = game:GetService("ReplicatedStorage")
local OLD
local NEW

local charbuff = ""

local OldRoot

function Create(Where, Root, MirrorRoot)
	--Root:ClearAllChildren()
	local names = {}
	for i,v in pairs(Where:GetChildren()) do
		names[v.Name] = true
		if not v:IsA("BaseScript") and Root:FindFirstChild(v.Name) == nil then
			local a = v:Clone()
			a:ClearAllChildren()
			a.Parent = Root
			Create(v, a)
			print("[Instinct Plugin] "..v:GetFullName().. " ... (mod) ok")
		elseif v:IsA("BaseScript") then
			if Root:FindFirstChild(v.Name) == nil then
				Instance.new("ModuleScript", Root).Name = v.Name
			end

			parse_api(v, Root[v.Name], v.Name)

			if v == root.Include.Version then 
				local v1,v2,v3 = v.Source:match("(%d+)%.(%d+)%.(%d+)")
				v3=v3+1
				OLD = v1.."."..v2.."."..(v3-1)
				NEW = v1.."."..v2.."."..(v3)
				v.Source = v.Source:gsub("%d+%.%d+%.%d+", v1.."."..v2.."."..v3)

			end 


			Root[v.Name].Source = v.Source 
			print("[Instinct Plugin] "..v:GetFullName().. " ... (code) ok")
		end
	end
	for i,v in pairs(Root:GetChildren()) do 
		if not names[v.Name] then 
			v:Destroy()
		end
	end
end

local plug = PluginManager():CreatePlugin()
local tb = plug:CreateToolbar("InstinctFramework")

local button = tb:CreateButton("Update API", "Click to update the Instinct Framework!", "")

function cwrite(text)
	charbuff = charbuff .. text 
end

function parse_api(old, new, name) -- writes to charbuff
	local matcher = "function [%w%.%[%]]+[^\n)]*%)"
	local src = old.Source 
	local nsrc = new.Source 

	local oldf, newf = {}, {}
	print("OLD")
	for match in src:gmatch(matcher) do 
		oldf[match] = true 
		print(match)
	end 
	print("NEW", nsrc,"hi")
	for match in nsrc:gmatch(matcher) do 
		newf[match] = true 
		print(match)
	end 
	-- Create charbuff title 
	cwrite("\t"..name.."\n")
	for i,v in pairs(newf) do 
		if oldf[i] then 
			cwrite("\t\t\t"..i.."\n")
		end
	end
	cwrite("\t\tAdditions\n")
	for i,v in pairs(oldf) do 
		if not newf[i] then 
			cwrite("\t\t\t"..i.."\n")
		end 
	end
	cwrite("\t\tDeletions\n")
	for i,v in pairs(newf) do 
		if not oldf[i] then 
			cwrite("\t\t\t"..i)
		end
	end
	cwrite("\n")
end 

function find(where, what, mustcreate)
	if where:FindFirstChild(what) then 
		return where[what]
	elseif mustcreate then 
		local new = Instance.new("Model", where)
		new.Name = what
	else 
		print("[Instinct Plugin] "..what.." not found, please create!") 
	end
end

find(root, "Include")
find(root, "Instinct", true)
find(root, "Instinct_APIs", true)

button.Click:connect(function()
	OldRoot = nil
charbuff = ""
 Create(game.ReplicatedStorage.Include, game.ReplicatedStorage.Instinct) 
 print("[Instinct Plugin] Creation completed! ("..OLD.." --> "..NEW..")") 
 local file = Instance.new("Script", root.Instinct_APIs)
 file.Name = NEW 
 file.Source = charbuff
 print("[Instinct Plugin] API diff written to ReplicatedStorage.Instinct_APIs."..NEW)
 end)


