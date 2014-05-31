-- DimTools define functions for moving and reszing GUIs around
-- They dont respect the parent GUIs

local DimTools = {}

function DimTools.Center(Gui)
	Gui.Position = UDim2.new(0.5 - (Gui.Size.X.Scale/2), -Gui.Size.X.Offset * 0.5, 0.5 - (Gui.Size.Y.Scale/2), -Gui.Size.Y.Offset * 0.5)
end

function DimTools.TextSize(text, font, fontsize)
	if not game.Players.LocalPlayer.PlayerGui:FindFirstChild("FontCHK") then 
		local new = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
		new.Name = "FontCHK"
		local x = Instance.new("TextButton", new)
		x.Visible = false
	end
	local my = game.Players.LocalPlayer.PlayerGui.FontCHK.TextButton

	my.FontSize = fontsize
	my.Text = text
	my.Font = font
	if my.TextBounds.X == 0 or my.TextBounds.Y == 0 then
		repeat wait(1/60) 
		until my.TextBounds.X ~= 0 and my.TextBounds.Y ~= 0
	end
	return my.TextBounds.X, my.TextBounds.Y
end

return DimTools