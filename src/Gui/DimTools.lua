-- DimTools define functions for moving and reszing GUIs around
-- They respect the parent GUIs

local DimTools = {}

function DimTools.Center(Gui)
	local as = game.Players.LocalPlayer.PlayerGui.Windows.AbsoluteSize
	local x,y = as.X, as.Y
	Gui.Position = UDim2.new(0.5 - (Gui.Size.X.Scale/2), x/Gui.Size.X.Offset * 0.5, 0.5 - (Gui.Size.Y.Scale/2), y/Gui.Size.Y.Offset * 0.5)
end

return DimTools