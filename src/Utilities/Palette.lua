local Palette = {}



local ct = Instinct.Include("Utilities/ColorTools")

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
	Console = {
		Default = rgb(0,0,0),
		Text = rgb(255,255,255),
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
	},
	ColorLabel = { -- colorlabel tags!
		black = rgb(0,0,0),
		red = rgb(128,0,0),
		green = rgb(0,128,0),
		yellow = rgb(128,128,0),
		blue = rgb(0,0,128),
		purple = rgb(128,0,128),
		cyan = rgb(0,128,128),
		white = rgb(192,192,192)
		
		
	},
	ColorLabelLight = {
		black = rgb(128,128,128),
		red = rgb(255,0,0),
		green = rgb(0,255,0),
		yellow = rgb(255,255,0),
		blue = rgb(0,0,255),
		purple = rgb(255,0,255),
		cyan = rgb(0,255,255),
		white = rgb(255,255,255)		
		
	}
	
	
	--[[ 0 #000000  1 #800000  2 #008000  3 #808000  4 #000080  5 #800080  6 #008080  7 #c0c0c0
 8 #808080  9 #ff0000 10 #00ff00 11 #ffff00 12 #0000ff 13 #ff00ff 14 #00ffff 15 #ffffff--]]
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

function Palette:GetRaw(Type, Which) -- can return nil! raw checks
	return self.Data[Type] and self.Data[Type][Which]
end

return Palette