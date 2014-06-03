-- MainMenu provides the main menu for the game
-- Additional modules can be launched from here
-- Insertion points are provided

local MainMenu = {}

MainMenu.TitleFont = "ArialBold"
MainMenu.FontSize = "Size36"
MainMenu.TitleShade = 7

MainMenu.TextWhiteSpace = 10

MainMenu.ButtonFont = "ArialBold"
MainMenu.ButtonFontSize = "Size24"

MainMenu.WhiteSpace = 20
MainMenu.ButtonShading = 5 -- wow so much shading
MainMenu.XOffset = 50

local Palette = Instinct.Include "Utilities/Palette"
local Locale = Instinct.Include "Services/Locale"
local Presets = Instinct.Include "Gui/GuiPresets"
local Dim = Instinct.Include "Gui/DimTools"

local Player = game.Players.LocalPlayer

function MainMenu.CreateFromList(title, list) -- creates the main menu from gui items
	local VERSION = Instinct.Include "Version"
	local Root = Instance.new("ScreenGui", Player.PlayerGui)
	local Backdrop = Presets.Backdrop(5)
	local MMLabel, x, y = Presets.CustomButton(
		title,		MainMenu.TitleShade, MainMenu.TitleFont, MainMenu.FontSize, 
		Palette:Get("Text"), Palette:Get("Complement", "Shade3"), 
		MainMenu.TextWhiteSpace) 
	local curry = MainMenu.WhiteSpace
	Backdrop.Parent = Root
	MMLabel.Parent = Backdrop
	local curry = curry + y + MainMenu.WhiteSpace
	MMLabel.Position = UDim2.new(0.5, -x/2, 0, MainMenu.WhiteSpace)
	local max_x = x
	for i,v in pairs(list) do
		local b,x,y = Presets.CustomButton(v, MainMenu.ButtonShading, MainMenu.ButtonFont, 
			MainMenu.ButtonFontSize, Palette:Get("Text"), Palette:Get("Complement"), 
			MainMenu.TextWhiteSpace
		)
		b.Parent = Backdrop
		b.Position = UDim2.new(0.5, -x/2, 0, curry)
		curry = curry + y + MainMenu.WhiteSpace
		if x > max_x then
			x = max_x
		end
	end
	
	Backdrop.Size = UDim2.new(0, max_x + MainMenu.WhiteSpace, 0, curry)
	Backdrop.Position = UDim2.new(1,-(max_x + MainMenu.WhiteSpace) - MainMenu.XOffset, 0.5, -curry/2)
end


return MainMenu