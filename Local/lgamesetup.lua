local rbxinstance = Instinct.Include "Local/rbxinstance"
local Object = Instinct.Include "Action/Object"
local Context = Instinct.Include "Action/Context"

local newrbx = Instinct.Create(rbxinstance)

newrbx.Name = "Crucible"

local newcontext = Instinct.Create(Context)

newcontext:SetLocation(newrbx)

World = {
	ctx = newcontext,
	inst = newrbx,
}
