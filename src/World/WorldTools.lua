-- World Tools provides a toolkit
-- for "world operations" such as
-- collission checking.

local WorldTools = {}

function WorldTools:IsRoom(Pos, Size) -- both vector3 please
	local BOX = Instance.new("Part", game.Workspace)
	BOX.FormFactor = "Custom"
--	BOX.Transparency = 0
	BOX.CanCollide = true
	BOX.Size = Size
	BOX.Position = Pos
--	wait(1)
	local bool = (BOX.Position - Pos).magnitude < 0.05
	--print(bool)
	BOX:Destroy()
	return bool	
end

function WorldTools:UpdateWeld(part1, part2, c1, c2)
	if part1:FindFirstChild("Weld") then
		part1.Weld:Destroy()
	end
	local Weld = Instance.new("Weld", part1)
	Weld.Name = "Weld"
	Weld.Part0 = part2
	Weld.Part1 = part1
	Weld.C0 = c2:toObjectSpace(c1)
end

return WorldTools