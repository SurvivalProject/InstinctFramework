local SFX = {}

local Palette = Instinct.Include("Utilities/Palette")

function SFX.Shade(which, size)
	local size = size or 3
	local shadeunder = Instance.new("Frame", which)
	shadeunder.BorderSizePixel = 0
	shadeunder.BackgroundColor3 = Palette:Get("SFX", "Default")
	shadeunder.Name = "Shade"
	local shaderight = shadeunder:Clone()
	shaderight.Parent = which
	shaderight.Size = UDim2.new(0,size,1,0)
	shadeunder.Size = UDim2.new(1,0,0,size)
	shaderight.Position = UDim2.new(1,0,0,size)
	shadeunder.Position = UDim2.new(0,size,1,0)
	
end

function SFX.MakeBorder(which, left, right, up, down, color, bordersize)
	function get()
		local new = Instance.new("Frame", which)
		new.BackgroundColor3 = color
		new.BorderSizePixel = 0
		new.Name = "Border"
		return new
	end
	-- left
	if left then 
	local x = get()
	local yoffset = -((up and bordersize) or 0)
	x.Position = UDim2.new(0, -bordersize, 0, yoffset)
	x.Size = UDim2.new(0, bordersize, 1, -yoffset + ((down and bordersize) or 0))
	end
	-- right
	if right then
	local x = get()
	local yoffset = -((up and bordersize) or 0)
	x.Position = UDim2.new(1,0,0, yoffset)
	x.Size = UDim2.new(0, bordersize, 1, -yoffset + ((down and bordersize) or 0))
	end
	-- down
	if down then 
	local y = get()
	local xoffset = -((left and bordersize) or 0)
	y.Position = UDim2.new(0,xoffset,1, 0)
	y.Size = UDim2.new(1, xoffset + ((right and bordersize) or 0), 0, bordersize)
	end
	-- up
	if up then 
	local y = get()
	local xoffset = -((left and bordersize) or 0)
	y.Position = UDim2.new(0,xoffset,0, -bordersize)
	y.Size = UDim2.new(0, xoffset + ((right and bordersize) or 0), 0, bordersize)
	end	
end

return SFX