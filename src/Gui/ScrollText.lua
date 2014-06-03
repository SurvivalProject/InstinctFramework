local ScrollText = {}

local Window = Instinct.Include "Gui/Window"
local Palette = Instinct.Include "Utilities/Palette"
local Dim = Instinct.Include "Gui/DimTools"
local ColorLabel = Instinct.Include "Gui/ColorLabel"


ScrollText.Font = "ArialBold"
ScrollText.FontSize = "Size12"

ScrollText.TextColor = Palette:Get("TextColor", "Black")

function ScrollText:Create(where, size, pos)
	local new = Instance.new("Frame", where)
	new.Size = size or UDim2.new(1,0,1,0)
	new.Position = pos or UDim2.new(0,0,0,0)
	new.ClipsDescendants = true
	new.BackgroundTransparency = 1
	self.Root = new
end

function ScrollText:CreateWindow(size)
	
end

function ScrollText:Push(txt, tcolor)
	local new = Instinct.Create(ColorLabel)
	new.FontSize = self.FontSize
	new.DefaultColor = tcolor or Palette:Get "Text"
	new = new:GetLabel(txt, tcolor or Palette:Get("Text"))
	new.Position = UDim2.new(0, 0, 1, 0)
	new.Parent = self.Root
	local size_x, size_y = Dim.TextSize("test", self.Font, self.FontSize)
	for i,v in pairs(self.Root:GetChildren()) do
		v.Position = v.Position - UDim2.new(0,0,0,size_y)
		if v.Position.Y.Offset < -v.Parent.AbsoluteSize.Y then
			v:Destroy()
		end
	end
end

return ScrollText