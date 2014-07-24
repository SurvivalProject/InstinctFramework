repeat wait() until _G and _G.Instinct and _G.WaitForInstinct

_G.WaitForInstinct()

-- Holds local checks for gathering -- 

function call(name)
	if game:GetService("ReplicatedStorage"):FindFirstChild(name) then
		local obj = game:GetService("ReplicatedStorage"):FindFirstChild(name)
		obj:InvokeServer(targ)
	end
end

local DefaultActions = {}

DefaultActions.Gather = {
	func = function(targ)
		if targ:IsDescendantOf(game.Workspace.Resources) then
			return true
		end
	end,
	proc = "AddBPItem"
}
	