print("\n\n / INSTINCT FRAMEWORK UTILITY SCRIPT \\")
print("Dependencies: LuaXml, LuaFileSystem")

require "luaxml"
local lfs = require "lfs"

print("This lua script will update the model from the src directory")
print("Please make sure that the version string (format %d+.%d+.%d+) is updated")

local arg = {...}

if arg[1] ~= "-f" then 
    print("Press any key to continue or q to quit")
    print("You can also call this with -f to disable this prompt!")
    local r = io.read()
    if r == "q" then 
        os.exit()
    end
end

function makemod(name, location)
    local new = location:append("Item")
    new.class = "Model"
    new.referent = "RBX0"
    local properties = new:append("Properties")
    local cf = properties:append("CoordinateFrame")
    cf.name = "ModelInPrimary"
    local t = {"X", "Y", "Z", "R00", "R01", "R02", "R10", "R11", "R12", "R20", "R21", "R22"}
    for _,v in pairs(t) do 
        if v == "R00" or v == "R11" or v == "R22" then 
            cf:append(v)[1] = 1
        else 
            cf:append(v)[1] = 0
        end
    end 
    local n = properties:append("string")
    n.name = "Name"
    n[1] = name 
    local ref = properties:append("Ref")
    ref.name = "PrimaryPart"
    ref[1] = "null"
    return new 
end 

function makescript(name, location, data)
    local new = location:append("Item")
    new.class = "Script"
    new.referent = "RBX0"
    local properties = new:append("Properties")
    local disabled = properties:append("bool")
    disabled.name = "Disabled"
    disabled[1] = "false"
    local Content = properties:append("Content")
    Content.name = "LinkedSource"
    Content:append("null")[1] = ""
    local nam = properties:append("string")
    nam.name = "Name"
    nam[1] = name:gsub(".lua", "")
    local ps = properties:append("ProtectedString")
    ps.name = "Source"
    ps[1] = data
end 

function scandir (path, xml_root)
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local fullpath = path..'/'..file
            local attr = lfs.attributes (fullpath)
            if attr.mode == "directory" then
                local newx = makemod(file, xml_root)
                scandir (fullpath, newx)
            else
                -- file
                makescript(file, xml_root, io.open(fullpath):read("*all"))
            end
        end
    end
end


oldversion, newversion, version =  dofile("GetVersion.lua")

local act = not version -- we are doing it backwards

if not version then 

    print("Parsing......")

    -- Create xml 

    local new = xml.new("roblox")
    new["xmlns:xmime"]="http://www.w3.org/2005/05/xmlmime"
    new["version"]="4"
    new["xsi:noNameSpaceSchemaLocation"]="http://www.roblox.com/roblox.xsd"
    new["xmlns:xsi"]="http://www.w3.org/2001/XMLSchema-instance"
    new = makemod("Include", new)
    scandir("../src", new)

    os.remove("../source.rbxm")
    lfs.touch("../source.rbxm")

    local handle = io.open("../source.rbxm","w")
    handle:write(tostring(new))
    print(newversion .. " --> " .. oldversion)
else 
    print("Trying to update with old/same version, please update versions in src and source.rbxm")
end 