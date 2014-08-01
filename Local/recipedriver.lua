-- Lets setup a quick way of doing this

-- We will define an alloy test recipe

-- The recipe has the following rules:
--> We will create Bronze
--> We will need 10 pieces of Copper and 1 piece of tin 
--> The metals have to be "molten" (900 in this example)
--> The metals have to be in a furnace which is a mixing device
--> The last thing could also be defined as a Crucible
--> But for testing purposes we define it in a more abstract way 

--[[

This is actually quite funny
We can define objects on the moments we need them
For instance, if I want to create a Metal Container
From a random metal, the recipe check should check if there 
Is enough metal, and then create this object
Dammit. Nice.


--]]

-- Lets first define the Objects

local Object = Instinct.Include "Action/Object"
local ObjectService = Instinct.Include "Services/ObjectService"
for i,v in pairs(Instinct.Create) do 
	print(tostring(i), tostring(v))
end 

print(Instinct.Create)

for i,v in pairs(Instinct.Create) do print(i) end

require "stonecap" 

local Metal = Instinct.Create(Object)

Metal.IsMetal = true 
Metal.Name = "Metal"

local Copper = Metal:CreateExtension("Copper")

local Tin = Metal:CreateExtension("Tin")

local Bronze = Metal:CreateExtension("Bronze")

local MetalContainer = Instinct.Create(Object)
MetalContainer.Name = "Metal Container"
MetalContainer.IsMetalContainer = true 

local Furnace = Instinct.Create(Object)
Furnace.Name = "Furnace"
Furnace.IsFurnace = true 

local Crucible = Furnace:CreateExtension("Crucible")

Crucible.IsMetalMixingDevice = true 

ObjectService:AddObjects {
	Metal, Copper, Tin, Bronze;
	MetalContainer; 
	Furnace, Crucible 
}

local functemplate = function (RuleData, RuleType, RuleSet, 
	Context, List, Recipe) end 

-- Now we will define our Recipe!

local Recipe = Instinct.Include "Action/Recipe"

local test = Instinct.Create(Recipe)

test.Context = {
	Furnace = true, 
	MetalMixingDevice = true
}

test.Ingredients = {
	Copper = {Amount = 9, Temperature = {"L", 900}},
	Tin = {Amount = 1, Temperature = {"L", 900}},
	["Metal Container"] = {Amount = 1},

}

test.Created = "Bronze"

print(lfs.currentdir())
lfs.chdir("../Local")
require "ruleset"

test:SetCategory("Furnace")

TESTRECIPE = test 



