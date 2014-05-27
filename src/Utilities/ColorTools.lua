local ColorTools = {}

function ColorTools.RGBToColor3(r,g,b)
	return Color3.new(r/255,g/255,b/255)
end

return ColorTools