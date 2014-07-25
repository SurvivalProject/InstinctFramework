local lfs = require "lfs"

_G.__InstinctPresets = {
LoadType = "term"
}
local load =  lfs.currentdir()
lfs.chdir("../src")

Instinct = require "Instinct"

_G.Instinct = Instinct 

lfs.chdir(load)

return Instinct