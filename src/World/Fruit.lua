-- Fruit is a special resource type
-- It has a Grow function
-- Can also be used as vegetables ^_^

-- The Tree Instance will handle all positions;
-- 
local Fruit = {}

Fruit.LastTick = 0
Fruit.Base = nil

-- This fucntion should be user defined
-- It should return a base
function Fruit:GetBase()
	return Instance.new("Part") 
end

-- Fruit doesnt have regular growing patterns
-- This function should also be user provided
-- This whole class is user defined ._.

function Fruit:GrowBase(dt)
	
	
end

-- the dt argument is delta time since last
-- intern clock is provided and used when dt is nil
function Fruit:Grow(dt)
	local dt = dt or (tick() - self.LastTick)
	self:GrowBase(dt)
	self.LastTick = tick()	
end



return Fruit