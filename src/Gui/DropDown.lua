local DropDown = {}

DropDown.XOffset = 10
DropDown.YOffset = 5
DropDown.TextOffset = 5
DropDown.Shade = 2

local SFX = Instinct.Include("Gui/SFX")
local Presets = Instinct.Include("Gui/GuiPresets")
local Dim = Instinct.Include("Gui/DimTools")

function DropDown:Create(Parent, Position, BackgroundC3, BorderC3, BorderSize)
	local new = Presets.Canvas(BackgroundC3)
	new.Position = Position or UDim2.new(0,0,0,0)
	new.Parent = Parent
	if type(BorderSize) == "table" then
		local need = { "left", "right", "down", "up", "bordersize"}
		local wrong = false
		for i,v in pairs(need) do 
			if BorderSize[v] == nil then 
				wrong = true
				print(v)
				break
			end
		end
		print(wrong, BorderSize.which)
		if not wrong then
			SFX.MakeBorder(new, BorderSize.left, BorderSize.right, BorderSize.up, BorderSize.down, BorderC3, BorderSize.bordersize)
		end
	else
		new.BorderSizePixel = BorderSize or 0
		new.BorderColor3 = BorderC3 or Palette:Get()
	end
		
	self.Root = new
end

function DropDown:AddButton(text)
	local new = Presets.Button(self.Shade)
	local numbuttons = 0
	for i,v in pairs(self.Root:GetChildren()) do
		if v.Name ~= "Border" then
			numbuttons = numbuttons + 1
		end
	end
	local ypos = (self.YOffset + self.Shade + new.Size.Y.Offset) * numbuttons + self.YOffset
	new.Text = text
	new.FontSize = "Size12"
	local xt, yt = Dim.TextSize(text, "ArialBold", "Size12")
	print(xt, "hi")
	new.Size = UDim2.new(0, xt + self.TextOffset * 2, 0, new.Size.Y.Offset)
	new.Position = UDim2.new(0, self.XOffset, 0, ypos)
	new.Parent = self.Root
	local max_x = 0
	for i,v in pairs(self.Root:GetChildren()) do
		if v.Name ~= "Border" then 
			local new_x = self.XOffset * 2 + v.Size.X.Offset
			if new_x > max_x then
				max_x = new_x
			end
		end
	end
	for i,v in pairs(self.Root:GetChildren()) do
		if v.Name ~= "Border" then 
			v.Size = UDim2.new(0, max_x - self.XOffset * 2, 0, new.Size.Y.Offset)
		end
	end
	local ysize = ypos + new.Size.Y.Offset + self.Shade + self.YOffset
	print(ysize)
	self.Root.Size = UDim2.new(0,max_x, 0, ysize)
	
	new.MouseButton1Click:connect(function() print("click") end)
	
end


function DropDown:Destroy()
	self.Root:Destroy()
end

return DropDown