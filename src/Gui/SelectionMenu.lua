local Window = Instinct.Include("Gui/Window")
local Palette = Instinct.Include("Utilities/Palette")
local SFX = Instinct.Include("Gui/SFX")
local DimTools = Instinct.Include "Gui/DimTools"
local GuiPresets = Instinct.Include "Gui/GuiPresets"

-- Selecitonmenu builds a GUI with a list of items
-- The user selects and item (highlights)
-- Once OK is clicked the SelectionMenu.Selected will fire:
--> button text AND button instnace as argument
--> NIL if the user did NOT SELECT ANYTHING
--> A close button will also be generated; this will do the same

local SelectionMenu = {}


-- Style

-- Size offset per text item
SelectionMenu.SelectionOffset = 6

-- Color map -> index % 2 + 1 -> color index in color table
--> used as background color
SelectionMenu.Colors = {
	Palette:Get("Shade2", "Shade1"),
	Palette:Get("Shade2", "Shade2"),
}

SelectionMenu.SelectionColor = Palette:Get("Shade1", "Shade1")

-- Shades the selection 
-- >= selectionoffset to prevent overflows
SelectionMenu.Shade = 0


-- Horizontal total whitespace per selection
-- On the left side (and right size) this / 2


SelectionMenu.HorizontalWS = 10

-- Vertical space; how much offset between window title, the items, the OK button and the end

SelectionMenu.VerticalSpace = 5

SelectionMenu.OKColor = Palette:Get("Complement")
SelectionMenu.CreateOK = true


SelectionMenu.TextWS = 10

function SelectionMenu:Constructor()
	
	self.SelectionDone = Instinct.Create(Instinct.Event)
end



-- No tooltip supported yet
function SelectionMenu:CreateWindow(ItemList, Title, DefaultSelection, Description) 
	assert(ItemList, "No itemlist provided")
	local Window = Instinct.Create(Instinct.Gui.Window)	
	Window.DestroyOnClose = true
	
	
	-- Create a list of text bound items
	
	local TextBounds = {} -- only horizontal
	
	local button = GuiPresets.Button()
	local max = 0
	local tmax = 0	
	
	function chk(txt)
		local s =  DimTools.TextSize(txt, button.Font, button.FontSize)
		TextBounds[txt] = s
		if s > max then
			max = s
		end
	end
	
	for i,v in pairs(ItemList) do
		chk(v)
	end
	
	chk "OK"	
	
	local TitleSizeMinimum = DimTools.TextSize(Title or "Select an item...", Window.TitleFont, Window.TitleFontSize)
	print(TitleSizeMinimum * 0.5, max)
	if (TitleSizeMinimum) * 0.5 > max then
		max = TitleSizeMinimum * 2
	end
	
	local ysize_needed = 4 * self.VerticalSpace + (#ItemList * (button.Size.Y.Offset + self.SelectionOffset))	
	
	Window:Create(UDim2.new(0, max + self.HorizontalWS + self.TextWS , 0,  ysize_needed), Title or "Select an item...")
	
	local curry = self.VerticalSpace -- yum
	
	
	
	for i,v in pairs(ItemList) do
			-- Selection Item
			local color_index = ( i % 2 ) + 1
			local color = self.Colors[color_index]
			local cl = button:Clone()
			cl.Parent = Window.Canvas
			cl.Position = UDim2.new(0, self.HorizontalWS/2, 0, curry)
			cl.Size = UDim2.new(0, max + self.TextWS, 0, cl.Size.Y.Offset)
			cl.BackgroundColor3 = color
			cl.Text = v
			if v == DefaultSelection and not self.SelectedButton then 
				self:ChangeSelection(cl)
			end
			cl.MouseButton1Click:connect(function() self:ChangeSelection(cl) end)
			curry = curry + cl.Size.Y.Offset + self.SelectionOffset
	end
	if self.CreateOK then 
				-- OK button
			curry = curry - self.SelectionOffset + self.VerticalSpace
			local cl = button:Clone()
			cl.Parent = Window.Canvas
			cl.Position = UDim2.new(0.5, -TextBounds["OK"]/2,0,curry)
			cl.BackgroundColor3 = self.OKColor
			cl.Text = "OK"
			cl.Size = UDim2.new(0, TextBounds["OK"] + self.TextWS, 0, cl.Size.Y.Offset)
			SFX.Shade(cl, self.Shade)
			cl.MouseButton1Click:connect(function()
				self:Done(true) -- and close window
			end)
	end
	self.Window = Window
	Window.CloseCallback = function()
		self:Done(false)
	end
end

function SelectionMenu:ChangeSelection(newbutton)
	SFX.Shade(newbutton, self.Shade)
	if self.SelectedButton then 
		SFX.RemoveShade(self.SelectedButton)
		self.SelectedButton.BackgroundColor3 = self.OldColor
	end
	self.OldColor = newbutton.BackgroundColor3 
	self.SelectedButton = newbutton
	self.SelectedText = newbutton.Text
	newbutton.BackgroundColor3 = self.SelectionColor
end


function SelectionMenu:Done(do_window_close)
	print("wut done")
	if not self.CycleDone then 
		self.CycleDone = true
		print("Selection done: "..self.SelectedText)
		self.SelectionDone:fire(self.SelectedText)
		if do_window_close then
			self.Window:Close()
		end
	end
end

return SelectionMenu