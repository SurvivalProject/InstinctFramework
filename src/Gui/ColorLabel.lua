local ColorLabel = {}

local Palette = Instinct.Include "Utilities/Palette"
local Dim = Instinct.Include "Gui/DimTools"

ColorLabel.FontSize = "Size12"
ColorLabel.Font = "Arial"
ColorLabel.BoldFont = "ArialBold"

ColorLabel.DefaultColor = Palette:Get("Text")

-- Parsing:
-- default escape; %{red light bold}

function ColorLabel:GetElementList(txt)
	-- returns a table with elements to build labels from
	-- ret: {txt, font, fontcolor}
	local out = {}
	local dmode = {self.Font, self.DefaultColor} -- default mode
	local cmode = dmode -- current mode
	local last
	for match, newmode in string.gmatch(txt, "([^%%]*)(%b%})") do
		last = newmode
		table.insert(out, {match, cmode[1], cmode[2]}) --unpack(cmode)
		cmode = {}
		local elements = {} -- elements provided;
		for element in string.gmatch(newmode, "[^{} ]+") do
			elements[element:lower()] = true
		end
		if not elements.reset then 
			if elements.bold then
				cmode[1] = self.BoldFont
				elements.bold = nil
			else
				cmode[1] = self.Font
			end
			local palette = "ColorLabel"
			if elements.light then
				palette = "ColorLabelLight"
				elements.light = nil
			end
			for i,v in pairs(elements) do
				local color = Palette:Get(palette, i) 
				if color then 
					cmode[2] = color
				end
			end
		else 
			cmode = dmode
		end
		if not cmode[2] then
			cmode[2] = self.DefaultColor
		end
	end
	local tail 
	if last then 
		tail = txt:match("%"..last.."(.-)$")
		local test = tail
		local loop = 0
		while test do
			test = tail:match("%"..last.."(.-)$")
			if test then
				tail = test
			end
			loop = loop + 1
			if loop > 50 then 
				break
			end
		end 
	end

	if not tail then
		tail = txt -- no escapes provided, kthen
	end
	table.insert(out, {tail, cmode[1], cmode[2]})
	return out
	
	
end


function ColorLabel:GetLabel(txt,c)
	if c then
		self.DefaultColor = c
	end
	local list = self:GetElementList(txt)
	local root
	local x = 0 -- offsetz
	local function newlabel(text, font, color)
		local new = Instance.new("TextLabel", root)

		local xsize, ysize = Dim.TextSize(text, font, self.FontSize)
		new.Size = UDim2.new(0,xsize,0,ysize)
		new.TextColor3 = color
		new.Text = text
		new.Font = font
		new.FontSize = self.FontSize
		new.BackgroundTransparency = 1
		new.Position = UDim2.new(1,x,0,0)
		if not root then
			root = new
		else 
			x = x + xsize
		end
	end
	for item_id, item_data in pairs(list) do
		local Text = item_data[1]
		local Font = item_data[2]
		local Color = item_data[3]
		newlabel(Text, Font, Color)
	end
	return root
end

return ColorLabel