local Console = {}

local Palette = Instinct.Include "Utilities/Palette"
local ScrollText = Instinct.Include "Gui/ScrollText"
local ButtonBar = Instinct.Include "Gui/ButtonBar"
local Dim = Instinct.Include "Gui/DimTools"

local Player = game.Players.LocalPlayer

Console.Seperator = " :: "
Console.Ready = false

function Console.Initialize()
	print(Console.Ready)
	if Console.Ready then
		return
	end
	local new = Instance.new("ScreenGui", Player.PlayerGui)
	new.Name = "Console"

	local fr = Instance.new("Frame", new)
	fr.BackgroundColor3 = Palette:Get("Shade1", "Shade4")
	fr.Size = UDim2.new(1,0,1,0)
	fr.Name = "Outer"
	fr.BorderSizePixel = 0
	local win = Instance.new("Frame", fr)
	win.Size = UDim2.new(1,-80,1,-80)
	win.Position = UDim2.new(0,40,0,40)
	win.BackgroundColor3 = Palette:Get("Console")
	win.Name = "Inner"
	Console.CRoot = new
	Console.TerminalWindow = win
	-- Create tab bar
	local new = Instinct.Create(Instinct.Gui.ButtonBar)
	local size_x, size_y = Dim.TextSize("test", new.Font, new.FontSize)
	new:Init(Console.CRoot, UDim2.new(0,40, 1, -38), UDim2.new(1,-80,0,size_y + new.Shade))
	Console.ButtonDock = new
	Console.Tabs = {}
	Console.Ready = true
end

function Console.Open()
	Console.CRoot.Visible = true
end

function Console.Close()
	Console.CRoot.Visible = false
end

function Console.Write(tab, prio, ...)
	-- figure out if prio is an option or just text
	--> assertion: if prio is a table then it is an option!
	if not Console.Tabs[tab] then
		Console.CreateTab(tab)
	end
	local args
	if type(prio) == "table" then
		args = {...}
		if prio == Instinct.Option.ConsolePriority.Extreme then 
			-- MASTER WARNING open up the console
			Console.Open()
		end
	else 
		args = {prio, ...}
	end
	local t_args = {}
	for i,v in pairs(args) do
		t_args[i] = tostring(v)
	end
	local str = table.concat(t_args, Console.Seperator)
	Console.Tabs[tab][1]:Push("[ %{light cyan bold} "..math.floor(os.time() + 0.5).." %{reset}] "..str, Palette:Get("ColorLabel", "white"))
end

function Console.OpenTab(tab)
	if Console.TabOpen then
		Console.Tabs[Console.TabOpen][1].Root.Visible = false
		Console.Tabs[Console.TabOpen][2].BackgroundColor3 = Palette:Get("Complement")
	end
	if Console.Tabs[tab] then
		Console.TabOpen = tab
		Console.Tabs[tab][1].Root.Visible = true
		Console.Tabs[tab][2].BackgroundColor3 = Palette:Get("Shade1")
	end
end

function Console.CreateTab(tab)
	if Console.Tabs[tab] then
		return
	end
	local b = Console.ButtonDock:AddButton(tab)

	Console.Tabs[tab] = {Instinct.Create(ScrollText),b}
	Console.Tabs[tab][1].FontSize = "Size18"
	Console.Tabs[tab][1].TextColor = Palette:Get("Console", "Text")
	Console.Tabs[tab][1]:Create(Console.TerminalWindow)
	Console.Tabs[tab][1]:Push(" --- "..tab.." ---", Palette:Get("ColorLabel", "white"))
	Console.Tabs[tab][1].Root.Visible = false
	
	b.MouseButton1Click:connect(function()
		if Console.TabOpen then
			Console.Tabs[Console.TabOpen][1].Root.Visible = false
			Console.Tabs[Console.TabOpen][2].BackgroundColor3 = Palette:Get("Complement")
		end
		Console.TabOpen = tab
		Console.Tabs[tab][1].Root.Visible = true
		b.BackgroundColor3 = Palette:Get("Shade1")
	end)
	
	return Console.Tabs[tab][1]
end

return Console