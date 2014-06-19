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
	print(bool)
	BOX:Destroy()
	return bool	
end

return WorldTools