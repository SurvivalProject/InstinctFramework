local lfs = require "lfs"

_G.__InstinctPresets = {
LoadType = "term"
}

lfs.chdir("../src")

Instinct = require "Instinct"

return Instinct