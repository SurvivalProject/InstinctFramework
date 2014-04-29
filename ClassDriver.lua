local Classes = require ("Class")

local new = {} 

function new:die() 
	print("dead")
end 

Classes.CreateClass("Entity", new )

new.x = 3 -- should error

local fish = {} 

function fish:swim() 
	print("umg swimmin")
end 

Classes.Extend("Entity", "Fish", fish)

local fish = Create("Fish")
fish:die()

new = Create "Entity"

-- benchmark

function randclass() 
	str = ""
	for i = 1, 8 do 
		str = str .. string.char(math.random(80,120))
	end 
	return str 
end 

local start = os.clock()
for i = 1, 1000 do 
	Classes.CreateClass(randclass(), {})
end 

print("1000 classes creation took ", os.clock() - start )

