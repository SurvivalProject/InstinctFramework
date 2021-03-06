-- MainMenu provides the main menu for the game
-- Additional modules can be launched from here
-- Insertion points are provided

local Palette = Instinct.Include "Utilities/Palette"
local Locale = Instinct.Include "Services/Locale"
local Presets = Instinct.Include "Gui/GuiPresets"
local Dim = Instinct.Include "Gui/DimTools"

local MainMenu = {}

MainMenu.TitleFont = "ArialBold"
MainMenu.FontSize = "Size36"
MainMenu.TitleShade = 3

MainMenu.BarSize = 4
MainMenu.BarOffset = 3
MainMenu.BarColor = Palette:Get() 
MainMenu.BarScale = 0.8 -- 80% of the original size

MainMenu.TextWhiteSpace = 10

MainMenu.ButtonFont = "ArialBold"
MainMenu.ButtonFontSize = "Size24"
MainMenu.VersionFontSize = "Size14"

MainMenu.WhiteSpace = 20
MainMenu.ButtonShading = 2 -- wow so much shading
MainMenu.XOffset = 50

MainMenu.Choosen = Instinct.Create(Instinct.Event)

local Player = game.Players.LocalPlayer

function MainMenu.CreateFromList(title, list) -- creates the main menu from gui items
	local VERSION = Instinct.Include "Version"
	local title = title 
	local Root = Instance.new("ScreenGui", Player.PlayerGui)
	MainMenu.Root = Root
	local Backdrop = Presets.Backdrop(5)
	local MMLabel, x, y = Presets.CustomButton(
		title,		MainMenu.TitleShade, MainMenu.TitleFont, MainMenu.FontSize, 
		Palette:Get("Text"), Palette:Get("Complement"), 
		MainMenu.TextWhiteSpace) 
	local curry = MainMenu.WhiteSpace
	Backdrop.Parent = Root
	MMLabel.Parent = Backdrop
	local curry = curry + y + MainMenu.WhiteSpace
	MMLabel.Position = UDim2.new(0.5, -x/2, 0, MainMenu.WhiteSpace)
	local max_x = x
	table.insert(list, 1, "Version "..VERSION)
	for i,v in pairs(list) do
		local DeltaY = -( MainMenu.TextWhiteSpace - MainMenu.BarOffset )
		local inspos = curry + DeltaY 
		local new = Instance.new("Frame", BackDrop)
		local b,x,y
		if i ~= 1 then 
			b,x,y = Presets.CustomButton(v, MainMenu.ButtonShading, MainMenu.ButtonFont, 
			MainMenu.ButtonFontSize, Palette:Get("Text"), Palette:Get("Complement", "Shade2"), 
			MainMenu.TextWhiteSpace
			)
		else 
			b,x,y = Presets.CustomButton(v, MainMenu.ButtonShading, MainMenu.ButtonFont,
			MainMenu.VersionFontSize,  Palette:Get("Text"), Palette:Get("Complement", "Shade1"), 
			MainMenu.TextWhiteSpace
			)
		end 
		b.Parent = Backdrop
		b.Position = UDim2.new(0.5, -x/2, 0, curry)
		b.MouseButton1Click:connect(function()
			MainMenu.Choosen:fire(b.Text)
		end)
		curry = curry + y + MainMenu.WhiteSpace
		if x > max_x then
			x = max_x
		end
	end
	
	Backdrop.Size = UDim2.new(0, max_x + MainMenu.WhiteSpace, 0, curry)
	Backdrop.Position = UDim2.new(1,-(max_x + MainMenu.WhiteSpace) - MainMenu.XOffset, 0.5, -curry/2)
end

function MainMenu:Close()
	MainMenu.Root:Destroy()
end


return MainMenu