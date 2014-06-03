local GuiPresets = {}

local Palette = Instinct.Include("Utilities/Palette")
local SFX = Instinct.Include("Gui/SFX")
local Dim = Instinct.Include "Gui/DimTools"

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

-- for easy creationz
-- returns button, xsize, ysize
-- omg it so awesome
function GuiPresets.CustomButton(ButtonText, ButtonShade, ButtonFont, ButtonFontSize, TextColor, BackgroundColor, WhiteSpace)
	local ButtonText = ButtonText or ""
	local ButtonShade = ButtonShade or 0
	local ButtonFont = ButtonFont or "ArialBold"
	local ButtonFontSize = ButtonFontSize or "Size12"
	local TextColor = TextColor or Palette:Get("Text")
	local BackgroundColor = BackgroundColor or Palette:Get("Complement")
	local WhiteSpace = WhiteSpace or 10	
	local new = Instance.new("TextButton")
	new.Text = ButtonText
	new.Font = ButtonFont
	new.FontSize = ButtonFontSize
	new.TextColor3 = TextColor
	new.BackgroundColor3 = BackgroundColor
	if ButtonShade > 0 then
		SFX.Shade(new, ButtonShade)
	end
	local size_x , size_y = Dim.TextSize(ButtonText, ButtonFont, ButtonFontSize)
	local rs = size_x + WhiteSpace
	new.Size = UDim2.new(0, rs, 0, size_y)
	return new, rs, size_y 
	
end

function GuiPresets.Canvas(color)
	local canvas = Instance.new("Frame")
	canvas.BackgroundColor3 = color or Palette:Get()
	canvas.BorderSizePixel = 0
	return canvas
end

function GuiPresets.Backdrop(bsize)
	local bar = Instance.new("Frame")
	bar.Size=UDim2.new(0,0,0,0)
	bar.BorderSizePixel = bsize
	bar.BorderColor3 = Palette:Get("Default", "Shade4")
	bar.BackgroundColor3 = Palette:Get("Default", "Shade2")	
	return bar
end


return GuiPresets