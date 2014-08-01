--[[wait(1)

_G.WaitForInstinct()--]]

local Object = Instinct.Include "Action/Object"
local ObjectService = Instinct.Include "Services/ObjectService"

local Stone = Instinct.Create (Object)

Stone.Name = "Stone"

ObjectService:AddObject(Stone)

local StoneTypes = {
	"General",
	"River",
	"Pressured",
	"Volcanic",
	"All"
}

local Instinct = _G.Instinct
print(Instinct.Option)
Instinct.Options = Instinct.Option
Instinct.Options.New("StoneType", StoneTypes)

local stonedata = {}

_G.StoneData = stonedata
stonedata.StonesInStoneType = {}

local data = {
	[Instinct.Options.StoneType.General] = {
			Flint = {
				Rarity = 0.75,
				OreBoost = "Chalcopyrite",
				Hardness = 4
			},
			Chert = {
				Rarity = 4,
				OreBoost = "Franklinite",
				Hardness = 2,				
				
			},
			Chalk = {
				Rarity = 6,
				OreBoost = "Malachite",
				Hardness = 1				
			},
			Coal = {
				Rarity = 2.5,
				OreBoost = "Cuprite",
				Hardness = 3,
			},
			Shale = {
				Rarity = 11,
				OreBoost = "Cassiterite",
				Hardness = 2,
			},
		},
	[Instinct.Options.StoneType.River] = {
		Sandstone = {
			Rarity = 10,
			OreBoost = "Pyrite",
			Hardness = 5,
		},
		Mudstone = {
			Rarity = 3,
			OreBoost = "Cuprite",
			Hardness = 1,
		},
		Breccia = {
			Rarity = 1,
			OreBoost = "Bismite",
			Hardness = 4,
		},
		Dolomite = {
			Rarity = 5,
			OreBoost = "Nordenskioldine",
			Hardness = 5,
		},
		Limestone = {
			Rarity = 8,
			OreBoost = "Malachite",
			Hardness = 3,			
		}
	},
	[Instinct.Options.StoneType.Pressured] = {
		Blueschist = {
			Rarity = 1,
			OreBoost = "Pyrolusite",
			Hardness = 7
		},
		Gneiss = {
			Rarity = 8,
			OreBoost = "Malachite",
			Hardness = 6,
		},
		Quartzite = {
			Rarity = 0.5,
			OreBoost = "Pentlandite",
			Hardness = 8,
		},
		Marble = {
			Rarity = 3,
			OreBoost = "Cassiterite",
			Hardness = 7,
		},
		Slate = {
			Rarity = 10,
			OreBoost = "Stannite",
			Hardness = 9,
		}
	},
	[Instinct.Options.StoneType.Volcanic] = {
		Obsidian = {
			Rarity = 0.3,
			OreBoost = "Chromium",
			Hardness = 11,
		},
		Andesite = {
			Rarity = 5,
			OreBoost = "Chalcopyrite",
			Hardness = 11
		},
		Latite = {
			Rarity = 8,
			OreBoost = "Hematite",
			Hardness = 10,
		},
		Rhyolite = {
			Rarity = 4,
			OreBoost = "Cassiterite",
			Hardness = 14,			
			
		},
		Feldspar = {
			Rarity = 12,
			OreBoost = "Malachite",
			Hardness = 18
		}
		
	}
	
}

for StoneType, StoneData in pairs(data) do 
	for name, data in pairs(StoneData) do 
		local obj = Stone:CreateExtension(name)

		local new = {}
		new.StoneType = StoneType
		new.Name = name 
		for setting, settingdata in pairs(data) do 
			new[setting] = settingdata
			obj[setting] = settingdata
		end
		
		ObjectService:AddObject(new)

		if _G.StoneData.StonesInStoneType[StoneType] then
			table.insert(_G.StoneData.StonesInStoneType[StoneType], new)
		else
			_G.StoneData.StonesInStoneType[StoneType] = {new}
		end
	end	

end

local holder = {}

local Ore = Instinct.Create(Object)

Ore.Name = "Ore"

ObjectService:AddObject(Ore)


_G.OreData = holder
_G.OreData.OresInStoneType = {}


local data = {
	Chalcopyrite = {
		Contents = {Cu = 34.6, Fe = 30.4},
		Rarity = 8,
		StoneType = Instinct.Option.StoneType.General
	},
	Cuprite = {
		Contents = {Cu = 88.8},
		Rarity = 1,
		StoneType = Instinct.Option.StoneType.General
	},
	Malachite = {
		Contents = {Cu = 57.3},
		Rarity = 10,
		StoneType = Instinct.Option.StoneType.All,
	},
	Cassiterite = {
		Contents = {Sn = 78.8},
		Rarity = 1,
		StoneType = Instinct.Option.StoneType.All
		
	},
	Stannite = {
		Contents = {Cu = 29.6, Sn = 27.6, Fe = 13.0},
		Rarity = 3,
		StoneType = Instinct.Option.StoneType.General
	},
	Nordenskioldine = {
		Contents = {Sn = 43.0},
		Rarity = 7,
		StoneType = Instinct.Option.StoneType.General
	},
	Sphalerite = {
		Contents = {Zn = 67.1},
		Rarity = 0.25,
		StoneType = Instinct.Option.StoneType.General
	},
	Franklinite = {
		Contents = {Zn = 27.1, Fe = 46.3},
		Rarity = 0.75,
		StoneType = Instinct.Option.StoneType.General,
	},
	Pyrite = {
		Contents = {Fe = 46.5},
		Rarity = 10,
		StoneType = Instinct.Option.StoneType.Pressured

	},
	Bismuthinite = {
		Contents = {Bi = 81.3},
		Rarity = 0.6,
		StoneType = Instinct.Option.StoneType.River,
	},
	Bismite = {
		Contents = {Bi = 89.7},
		Rarity = 0.3,
		StoneType = Instinct.Option.StoneType.River,
	},
	Stibnite = {
		Contents = {Sb = 71.7},
		Rarity = 0.25,
		StoneType = Instinct.Option.StoneType.River
	},
	Cobaltite = {
		Contents = {As = 45.2},
		Rarity = 1,
		StoneType = Instinct.Option.StoneType.River
	},
	Hematite = {
		Contents = {Fe = 69.9},
		Rarity = 6,
		StoneType = Instinct.Option.StoneType.Volcanic
	},
	Pyrolusite = {
		Contents = {Mn = 63.2},
		Rarity = 0.8,
		StoneType = Instinct.Option.StoneType.Pressured
		
	},
	["Native Silver"] = {
		Contents = {Ag = 80.5},
		Rarity = 0.08,
		StoneType = Instinct.Option.StoneType.Pressured
	},
	["Native Gold"] = {
		Contents = {An = 75.3},
		Rarity = 0.01,
		StoneType = Instinct.Option.StoneType.River
	},
	Pentlandite = {
		Contents = {Ni = 41.0},
		Rarity = 10	,
		StoneType  = Instinct.Option.StoneType.Pressured	
	},
	Chromite = {
		Contents = {Cr = 41.9},
		Rarity = 0.2,
		StoneType = Instinct.Option.StoneType.Volcanic
	},
	Galena = {
		Contents = {Pb = 86.6},
		Rarity = 4,
		StoneType = Instinct.Option.StoneType.Volcanic
	},
	Beryl = {
		Contents = {Si = 31.0},
		Rarity = 1,
		StoneType = Instinct.Option.StoneType.Volcanic
	}

}

_G.OreData.OresInStoneType = {}

for OreName, OreData in pairs(data) do
	local new = {}
	new.Name = OreName

	local obj = Ore:CreateExtension(OreName)


	for setting, value in pairs(OreData) do
		new[setting] = value
		obj[setting] = value 
	end

	ObjectService:AddObject(obj)

	if _G.OreData.OresInStoneType[OreData.StoneType] and OreData.StoneType ~= Instinct.Option.StoneType.All then 
		table.insert(_G.OreData.OresInStoneType[OreData.StoneType], new)
	elseif  OreData.StoneType ~= Instinct.Option.StoneType.All then
		_G.OreData.OresInStoneType[OreData.StoneType] = {new}
	end
	
end

Instinct.Include "World/Mine"
