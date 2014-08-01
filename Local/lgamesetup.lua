local rbxinstance = Instinct.Include "Local/rbxinstance"
local Object = Instinct.Include "Action/Object"
local Context = Instinct.Include "Action/Context"

local newrbx = Instinct.Create(rbxinstance)

newrbx.Name = "Crucible"

local newcontext = Instinct.Create(Context)
print(Instinct.Services.ObjectService.ObjectData.Crucible, 1 )
newcontext:SetLocation(newrbx)

print(newcontext.Location)

World = {
	ctx = newcontext,
	inst = newrbx,
}
