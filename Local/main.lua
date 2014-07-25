tmod = require "termloader"

-- setup 

require "recipedriver"
require "lgamesetup"

local r = TESTRECIPE
local rs = Instinct.Include "Services/RecipeService"
local rbxi = Instinct.Include "Local/rbxinstance"

local inventory = {}

function add(n)
	local new = Instinct.Create(rbxi)
	new.Name = n
	table.insert(inventory, new)
end 

for i = 1, 9 do 
	add "Copper"
end 

add "Tin"
add "Metal Container"


local out = rs:CheckRecipe(r, World.ctx, inventory)
print(out)