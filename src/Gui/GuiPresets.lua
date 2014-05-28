local GuiPresets = {}

local Palette = Instinct.Include("Utilities/Palette")
local SFX = Instinct.Include("Gui/SFX")

function GuiPresets.Button(shade)
	local DropDown = Instance.new("TextButton")
	DropDown.BackgroundColor3 = Palette:Get("Complement")
	DropDown.TextColor3 = Palette:Get("Text")
	DropDown.Font = "ArialBold"
	DropDown.Text = ""
	DropDown.BorderSizePixel = 0
	DropDown.Size = UDim2.new(0,10,0,20)
	DropDown.FontSize = "Size12"
	if shade then 
		SFX.Shade(DropDown,shade)
	end
	return DropDown
end

function GuiPresets.Canvas(color)
	local canvas = Instance.new("Frame")
	canvas.BackgroundColor3 = color or Palette:Get()
	canvas.BorderSizePixel = 0
	return canvas
end


return GuiPresets