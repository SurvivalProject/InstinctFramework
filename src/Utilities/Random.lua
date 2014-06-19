local Random = {}

function Random:FromWeightsTable(tab)
	local tweight = 0
	for i,v in pairs(tab) do
		tweight = tweight + v
	end
	local portion = math.random() * tweight
	local start = 0
	for i,v in pairs(tab) do 
		start = start + v
		if start > portion then
			return i
		end
	end
end

return Random