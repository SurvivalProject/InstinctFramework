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

return SFX