local Mine = {}

Instinct.Include "Utilities/Random"

Mine.OtherStoneSpawningChance = 1/100

function Mine:GetStone(height, stonetype)
	local selected = stonetype or Instinct.Option.StoneType.General
	if height then 
		local height = height - (height % 8) - 24
		local my = -math.huge
		local standard = Instinct.Option.StoneType.General
		for i,v in pairs(self.Heights) do 
			if height < v[2] then 
				standard = v[1]
			end
		end
	end

	local Stones = _G.StoneData.StonesInStoneType[selected]
	local NonNativeStones = {}
	for i,v in pairs(_G.StoneData.StonesInStoneType) do 
		if i ~= selected then
			for _, stone in pairs(v) do 
				table.insert(NonNativeStones, stone)
			end
		end
	end
	local randomroulette = {}
	local function scan(t, multiplier)
		for i,v in pairs(t) do
		
			randomroulette[v.Name] = v.Rarity * multiplier
		end
	end
	scan(Stones, 1)
	scan(NonNativeStones, self.OtherStoneSpawningChance)

	local stone = Instinct.Utilities.Random:FromWeightsTable(randomroulette)
	local t =  game.ServerStorage.Mining[stone]:Clone()
	t.Anchored = true
	return t
end

return Mine