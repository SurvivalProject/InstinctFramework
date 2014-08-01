package.path = package.path .. ";/Users/jochembrouwer/Stranded/Framework/InstinctFramework/Local/?.lua;"


tmod = require "termloader"

-- setup 

print(package.path)

require "recipedriver"
require "lgamesetup"

local r = TESTRECIPE
local rs = Instinct.Include "Services/RecipeService"
local rbxi = Instinct.Include "Local/rbxinstance"
local CS = Instinct.Include "Action/CreationService"

local o = Instinct.Include "Action/Object"

local inventory = {}

function add(n)
	local new = Instinct.Create(rbxi)
	new.Name = n
	o:SetContext(new, "Temperature", 1000)
	table.insert(inventory, new)
end 

for i = 1, 9 do 
	add "Copper"
end 

add "Tin"
add "Metal Container"

	local new = Instinct.Create(rbxi)
	new.Name = "Tin"
	o:SetContext(new, "Temperature", 1000)
	table.insert(inventory, new)

for i,v in pairs(Instinct.Services.ObjectService.ObjectData) do 
	print(i) 
end 

out, err = rs:CheckRecipe(r, World.ctx, inventory, 2 )

local use, stat = CS:CanCreateImmediate(out, r)

print(CS:GetStatusInfo(stat))

print(out, err )
print(use, stat)

