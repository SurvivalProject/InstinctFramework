local Palette = {}



local ct = Instinct.Include("Utilities/ColorTools")
print(ct)
local rgb = ct.RGBToColor3


Palette.Data = {
	Default = {
		Default = rgb( 43,125, 43),
		Shade1 = rgb(120,186,120),
		Shade2 = rgb( 73,151, 73),
		Shade3 = rgb( 20, 95, 20),
		Shade4 = rgb(  2, 63,  2),
	},
	Shade1 ={
		Default = rgb( 32, 94, 94),
		Shade1 = rgb( 90,140,140),
		Shade2 = rgb( 54,113,113),
		Shade3 = rgb( 15, 72, 72),
		Shade4 = rgb(  2, 47, 47),
	},
	Shade2 = {
		Default = rgb(114,146, 51),
		Shade1 = rgb(191,217,140),
		Shade2 = rgb(146,177, 85),
		Shade3 = rgb( 82,111, 23),
		Shade4 = rgb( 50, 73,  3),
	},
	Complement = {
		Default = rgb(156, 54, 54),
		Shade1 = rgb(233,150,150),
		Shade2 = rgb(189, 91, 91),
		Shade3 = rgb(119, 25, 25),
		Shade4 = rgb( 78,  3,  3),
	},
	Text = {
		Default = rgb(0,0,0),
		White = rgb(255,255,255)
	},
	Background = {
		Default = rgb(0,0,0),
		Shade1 = rgb(20,20,20),
		Shade2 = rgb(40,40,40),
		Shade3 = rgb(60,60,60),
		Shade4 = rgb(80,80,80),
	},
	SFX = {
		Default = rgb(0,0,0), -- shade color
	}
}

function Palette:Get(Type, Which)
	local Type = Type or "Default"
	local Which = Which or "Default"
	if self.Data and self.Data[Type] then 
		return self.Data[Type][Which] or self.Data[Type].Default 
	else 
		return self.Data.Default[Which] or self.Data.Default.Default
	end
end

return Palette