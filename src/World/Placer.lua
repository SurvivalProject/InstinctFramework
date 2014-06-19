-- General placer.

local Placer = {}

-- root to getchildren;
-- placecheck is called on each child -> true? check density
--> move to new position
--> call placefunc with this position + part
function Placer:DoJob(root, density_min, density_max, placecheck, placefunc)	
	local CurrentDensity, NextDensity
	function newdens()
		CurrentDensity = 0
		NextDensity= density_min + math.random() * (density_max - density_min)
	end
	newdens()
	for _, child in pairs(root:GetChildren()) do


		if child:IsA("BasePart") and placecheck(child) then 
			local z = 0
			
			for x = 1, child.Size.x do 
				CurrentDensity = CurrentDensity + child.Size.z
				if CurrentDensity > NextDensity then 
					local goback = CurrentDensity - NextDensity
					local z = child.Size.z - goback
					local start = child.CFrame * CFrame.new(-child.Size.x/2, child.Size.y/2, -child.Size.z/2)
					local pos = start * CFrame.new(x,0,z)
					placefunc(pos.p, child)
					newdens()
				end
			end
			wait()
		end

	end
end

return Placer