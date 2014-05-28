local ButtonBar = Instinct.Include("Gui/ButtonBar")
local Palette = Instinct.Include("Utilities/Palette")
local SFX = Instinct.Include("Gui/SFX")
local WindowServer = Instinct.Include("Gui/WindowServer")
local DDMenu = Instinct.Include("Gui/DropDown")

local Player = game.Players.LocalPlayer

local Menu = {}

Menu.Offset = 4
Menu.YSize = 30
Menu.Shade = 2
Menu.BorderSize = 3
Menu.FontSize = "Size14"
Menu.LastDropDown = nil

function Menu:Init()
	local Scr = Instance.new("ScreenGui", Player.PlayerGui)
	Scr.Name = "Menu"
	self.Root = Scr
	local bar = Instance.new("Frame", Scr)
	bar.Size=UDim2.new(0,0,0,self.YSize)
	bar.BorderSizePixel = self.BorderSize
	bar.BorderColor3 = Palette:Get("Default", "Shade4")
	bar.BackgroundColor3 = Palette:Get("Default", "Shade2")
	self.Bar = bar
	-- create dropdown button
	Menu:AddButton("V", "DropDown", {"Console", "Administration", "Server"})
end

function Menu:GetButton(type, openlist)
	local DropDown = Instance.new("TextButton", self.Root)
	local offset = self.YSize - self.Offset * 2
	DropDown.BackgroundColor3 = Palette:Get("Complement")
	DropDown.TextColor3 = Palette:Get("Text")
	DropDown.Font = "ArialBold"
	DropDown.FontSize = self.FontSize
	DropDown.Text = "V"
	DropDown.BorderSizePixel = 0
	SFX.Shade(DropDown,self.Shade)
	if type == "DropDown" and openlist then 
		DropDown.MouseButton1Click:connect(function()
		if self.LastDropDown then
			self.LastDropDown:Destroy()
		end
		local new = Instinct.Create(Instinct.Gui.DropDown)
		self.LastDropDown = new
		new:Create(self.Root, UDim2.new(0,0,0, self.YSize + self.BorderSize), Palette:Get("Default", "Shade1"), Palette:Get("Default", "Shade4"), 
			{	which = DropDown,
				left = false,
				right = true,
				up = false,
				down = true,
				bordersize = self.BorderSize,
		})
		for i,v in pairs(openlist) do 
			new:AddButton(v)
		end
		end)
	else 
		-- negotiate with winserver
		DropDown.MouseButton1Click:connect(function() 
			WindowServer.RequestOpen(DropDown.Text)
		end)
	end
	return DropDown
end

function Menu:AddButton(button_name, type, openlist)
	local button = self:GetButton(type or "Window", openlist)
	button.Text = button_name
	local max = 0
	for i,v in pairs(self.Root:GetChildren()) do
		if v.Position.X.Offset + v.Size.X.Offset + self.Offset + self.Shade > max then 
			max = v.Position.X.Offset + v.Size.X.Offset + self.Offset + self.Shade
		end
	end
	button.Position = UDim2.new(0,max,0,self.Offset)
	local offset = self.YSize - self.Offset * 2
	button.Size = UDim2.new(0, button.TextBounds.X + 10, 0, offset)
	local nsize = max + button.Size.X.Offset + self.Offset + self.Shade
	delay(1/30, function() self.Bar.Size = UDim2.new(0, nsize, 0, self.YSize) end)
end

return Menu