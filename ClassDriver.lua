local Classes = require ("Class")

local new = {} 

function new:die() 
	print("dead")
end 

Classes.CreateClass("Entity", new )

local fish = {} 

function fish:swim() 
	print("umg swimmin")
end 

Classes.Extend("Entity", "Fish", fish)

local fish = Create("Fish")
fish:die()