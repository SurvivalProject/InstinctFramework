local Window = {}

local Palette = Instinct.Include("Utilities/Palette")
local Dim = Instinct.Include("Gui/DimTools")
local WindowServer = Instinct.Include("Gui/WindowServer")
local SFX = Instinct.Include("Gui/SFX")

Window.Canvas = nil
Window.Root = nil
Window.DestroyOnClose = false
Window.TitleFont = "ArialBold"
Window.TitleFontSize = "Size18"

local Player = game.Players.LocalPlayer

function Window:Create(Size, Title)
	if Player.PlayerGui:FindFirstChild("Windows") == nil then 
		Instance.new("ScreenGui", Player.PlayerGui).Name = "Windows"
	end
	local Root = Player.PlayerGui.Windows
	local new = Instance.new("Frame", Root)
	new.BackgroundColor3 = Palette:Get("Background", "Shade4") 
	new.BackgroundTransparency = 0.5
	new.Size = Size or UDim2.new(0.5,0,0.5,0)
	new.BorderSizePixel = 0
	Dim.Center(new)
	-- Create header
	local header = Instance.new("Frame", new)
	header.Position = UDim2.new(0,0,0,-20)
	header.Size = UDim2.new(1,0,0,20)
	header.BorderSizePixel = 0
	header.BackgroundColor3 = Palette:Get("Default", "Shade4")
	-- Create title
	local title = Instance.new("TextLabel", header)
	title.Position = UDim2.new(0.25, 0, 0, -6)
	title.Size = UDim2.new(0.5, 0, 0, 20)
	title.Text = Title or ""
	title.Font = "ArialBold"
	title.FontSize = "Size18"
	title.TextColor3 = Palette:Get("Text")
	title.BorderSizePixel = 0
	title.BackgroundColor3 = Palette:Get("Default", "Shade2")
	self.Title = title
	SFX.Shade(title, 3)
	-- Create buttons
	local close = Instance.new("TextButton", header)
	close.Size = UDim2.new(0,30, 0,12)
	close.Position = UDim2.new(1, -40, 0, 4)
	close.Text = "X"
	close.BorderSizePixel = 0
	close.TextColor3 = Palette:Get("Text", "Default")
	close.BackgroundColor3 = Palette:Get("Complement", "Default")
	close.MouseButton1Click:connect(function()
		WindowServer:Notify(new, "Close")
		self:Close()
	end)
	SFX.Shade(close, 2)
	self.Canvas = new
end

function Window:Close()
	self.Canvas.Visible = false
	self.State = "Closed"
	if self.Button then
		self.Button.BackgroundColor3 = Palette:Get("Complement")
	end
	if self.CloseCallback then
		self.CloseCallback()
	end
	if self.DestroyOnClose then
		self.Canvas:Destroy()
	end
end

function Window:Open()
	self.Canvas.Visible = true
	self.State = "Open"
	print('xwn open')
	if self.Button then
		self.Button.BackgroundColor3 = Palette:Get("Shade1")
	end
	if self.OpenCallback then 
		self.OpenCallback()
	end
end

function Window:SetButton(Button)
	self.Button = Button
end

function Window:Toggle()
	if self.State == "Open" then
		self:Close()
	else
		self:Open()
	end
end

function Window:SetTitle(title)
	self.Title.Text = title
end

return Window