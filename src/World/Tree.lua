local Tree = {}

-- New trees. Simple, have limitions;
-- No branch spawning! Branch finding should be done via shaking trees.
-- (this action also drops all fruit which *could* be hidden in the tree)
-- Foliage should be CanCollide once dropped
-- Trunk cannot be cut in half directly: first cut completely 
-- This also destroys the tree! 
-- Foliage has the option to regrow - for future season additions!

local WorldTools = Instinct.Include "World/WorldTools"

Tree.Trunk = Instance.new("Part")
Tree.Trunk.BrickColor = BrickColor.new "Brown"
Tree.Trunk.Material = "Wood"
Tree.Trunk.TopSurface = "Smooth"
Tree.Trunk.BottomSurface = "Smooth"
Tree.Trunk.FormFactor = "Custom"
Tree.Trunk.Name = "Trunk"

Tree.TrunkFormMin = Vector3.new(0.25,1,0.25)
Tree.TrunkFormMax = Vector3.new(0.25,1,0.25)

Tree.FoliageFormMin = Vector3.new(3,1,3)
Tree.FoliageFormMax = Vector3.new(4,1,4)

Tree.SaplingHeight = 1 -- oh so cute
Tree.MinHeight = 18
Tree.MaxHeight = 22

Tree.GrowTimeMin = 10
Tree.GrowTimeMax = 30

-- TrunkForm and FoliageForm are set on init

Tree.BottomFoliagePortion = 0.5 -- Thsi is relative to the MIDDLE
Tree.MiddleFoliagePortion = 0.25  -- This is relative to the TRUNK
Tree.TopFoliagePortion = 0.5 -- This is relative to the MIDDLE

Tree.Foliage = Instance.new("Part")
Tree.Foliage.BrickColor = BrickColor.new "Bright green"
Tree.Foliage.Material = "Grass"
Tree.Foliage.TopSurface = "Smooth"
Tree.Foliage.BottomSurface = "Smooth"
Tree.Foliage.FormFactor = "Custom"
Tree.Foliage.Name = "Foliage"

Tree.Fruit = Instance.new("Part")
Tree.Fruit.BrickColor = BrickColor.Red() 
Tree.Fruit.TopSurface = "Smooth"
Tree.Fruit.BottomSurface = "Smooth"
Tree.Fruit.FormFactor = "Custom"
Tree.Fruit.Name = "Apple"
local mesh = Instance.new("SpecialMesh", Tree.Fruit)
mesh.MeshType = "Sphere"

Tree.FruitTargetSize = Vector3.new(1,1,1)
Tree.MaxFruit = 5
Tree.MinimalFoliageFruitSize = 10 -- as magnitude
-- fruit welds do not update so fruit will "dissapear" 

Tree.RoomNeeded = Vector3.new(16,22,16)

function Tree:UpdateWeld(part1, part2, c1, c2)
	if part1:FindFirstChild("Weld") then
		part1.Weld:Destroy()
	end
	local Weld = Instance.new("Weld", part1)
	Weld.Name = "Weld"
	Weld.Part0 = part2
	Weld.Part1 = part1
	Weld.C0 = c2:toObjectSpace(c1)
end

function Tree:InitializeFoliage()
	-- Find all foliages which we dont have
	if not self.MiddleFoliage or self.MiddleFoliage.Parent ~= self.TreeBase then 
		local wanted_height = self.SaplingHeight * self.MiddleFoliagePortion
		local size = self.FoliageForm * wanted_height
		local new = self.Foliage:Clone()
		new.Size = size
		new.Parent = self.TreeBase
		new.CFrame = self.TreeBase.CFrame * CFrame.new(0, self.TreeBase.Size.y/2, 0)
		self:UpdateWeld(new, self.TreeBase, new.CFrame, self.TreeBase.CFrame)
		self.MiddleFoliage = new
		self.MiddleFoliageTime = tick()
	end
	if not self.TopFoliage or self.TopFoliage.Parent ~= self.TreeBase then 
		local wanted_height =  self.SaplingHeight * self.MiddleFoliagePortion * self.TopFoliagePortion
		local size = self.FoliageForm * wanted_height
		local new = self.Foliage:Clone()
		new.Size = size
		new.Parent = self.TreeBase
		new.CFrame = self.MiddleFoliage.CFrame * CFrame.new(0, self.MiddleFoliage.Size.y/2, 0) * CFrame.new(0, new.Size.y/2, 0)
		self:UpdateWeld(new, self.TreeBase, new.CFrame, self.TreeBase.CFrame)
		self.TopFoliage = new
		self.TopFoliageTime = tick()
	end
	if not self.BottomFoliage or self.BottomFoliage.Parent ~= self.TreeBase then 
		local wanted_height =  self.SaplingHeight * self.MiddleFoliagePortion * self.BottomFoliagePortion
		local size = self.FoliageForm * wanted_height
		local new = self.Foliage:Clone()
		new.Size = size
		new.Parent = self.TreeBase
		new.CFrame = self.MiddleFoliage.CFrame * CFrame.new(0, -self.MiddleFoliage.Size.y/2, 0) * CFrame.new(0, -new.Size.y/2, 0)
		self:UpdateWeld(new, self.TreeBase, new.CFrame, self.TreeBase.CFrame)
		self.BottomFoliage = new
		self.BottomFoliageTime = tick()
	end
end

function Tree:UpdateFoliage()
	local function mvfruit(part,ds)
		for i,v in pairs(part:GetChildren()) do
			if v.Name == self.Fruit.Name then
				local g1, g2 = self.FruitTicks[v][2], self.FruitTicks[v][3]
				local newcf = self:GetFruitPositionFromOffset(part, g1, g2)
				v.CFrame = CFrame.new(newcf)
				self:UpdateWeld(v, part,v.CFrame, part.CFrame)
			end
		end
	end
	-- Middle
	local wanted_height = self.WantedHeight * self.MiddleFoliagePortion
	local new_height = self:GetNewHeight(tick() - self.MiddleFoliageTime, wanted_height)
	if new_height > self.MiddleFoliage.Size.y then 
		local size = self.FoliageForm * new_height
		local new = self.MiddleFoliage
		local ds = (size - new.Size)/2
		new.Size = size
		new.CFrame = self.TreeBase.CFrame * CFrame.new(0, self.TreeBase.Size.y/2, 0)
		self:UpdateWeld(new, self.TreeBase, new.CFrame, self.TreeBase.CFrame)
		mvfruit(new, ds)
	end
	
	-- Top
	local wh =  wanted_height * self.TopFoliagePortion
	local new_height = self:GetNewHeight(tick() - self.TopFoliageTime, wh)
	if new_height > self.TopFoliage.Size.y then 
		local size = self.FoliageForm * new_height
		local new = self.TopFoliage
		local ds = (size - new.Size)/2
		new.Size = size
		new.CFrame = self.MiddleFoliage.CFrame * CFrame.new(0, self.MiddleFoliage.Size.y/2, 0) * CFrame.new(0, new.Size.y/2, 0)
		self:UpdateWeld(new, self.TreeBase, new.CFrame, self.TreeBase.CFrame)
		mvfruit(new, ds)
	end

	-- Bottom
	local wh =  wanted_height * self.BottomFoliagePortion
	local new_height = self:GetNewHeight(tick() - self.BottomFoliageTime, wh)
	if new_height > self.BottomFoliage.Size.y then 
		local size = self.FoliageForm * new_height
		local new = self.BottomFoliage
		local ds = (size - new.Size)/2
		new.Size = size
		new.CFrame = self.MiddleFoliage.CFrame * CFrame.new(0, -self.MiddleFoliage.Size.y/2, 0) * CFrame.new(0, -new.Size.y/2, 0)
		self:UpdateWeld(new, self.TreeBase, new.CFrame, self.TreeBase.CFrame)
		mvfruit(new, ds)
	end
end

function Tree:GetRandomVector(min,max)
	-- height is 1
	local dx, dz = (max.x - min.x), (max.z - min.z)
	return Vector3.new(min.x + dx*math.random(), 1, min.z + dz * math.random())
end

-- returns a random position under the part
function Tree:GetFruitPosition(part)
	local delta = part.Size
	local function get() 
		local x = math.random() - 0.5
		if x > 0 then 
			return (x + 0.5) * 0.5
		else
			return (x - 0.5) * 0.5
		end
	end
	local get_1 = get()
	local get_2 = get()
	local x,y,z = get_1 * delta.x, -0.5 * delta.y, get_2 * delta.z
	return (part.CFrame * CFrame.new(Vector3.new(x,y,z))).p, get_1, get_2
end

function Tree:GetFruitPositionFromOffset(part, g1, g2)
	local size = part.Size
	local x,y,z = g1 * size.x, -0.5 * size.y, g2 * size.z
	return (part.CFrame * CFrame.new(Vector3.new(x,y,z))).p
end

function Tree:GetFruitCount()
	local out = 0
	for i,v in pairs(self.TreeBase:GetChildren()) do
		for ind, val in pairs(v:GetChildren()) do
			if val.Name == self.Fruit.Name then
				out = out + 1
			end
		end
	end
	return out
end

function Tree:InitializeFruit()
	local make = self.WantedFruit - self:GetFruitCount()
	if make > 0 then 
		for i,v in pairs(self.FruitTicks) do
			if not i:IsDescendantOf(self.TreeBase) then 
				self.FruitTicks[i] = nil
			end
		end
	
		for i = 1, make do 
			local parts = {self.TopFoliage, self.MiddleFoliage, self.BottomFoliage}
			local rem = {}
			for i,v in pairs(parts) do
				if v.Size.magnitude <  self.MinimalFoliageFruitSize then 
					parts[i] = nil
				end
			end
			local temp = {}
			for i,v in pairs(parts) do
				table.insert(temp,v)
			end
			parts=temp
			if #parts > 0 then 

				local new = self.Fruit:Clone()
				new.Size = Vector3.new(0.2,0.2,0.2)
				local part = parts[math.random(1,#parts)]
				local offset, g1,g2 = self:GetFruitPosition(part)
				self.FruitTicks[new] = {tick(), g1,g2}
				new.Parent = part
				new.CFrame = CFrame.new(offset)
			
				self:UpdateWeld(new,part,new.CFrame,part.CFrame)
			end
		end

	
	end
end

function Tree:UpdateFruit()
	for fruit,lasttick in pairs(self.FruitTicks) do
		local newh = self:GetNewHeight(tick() - lasttick[1], self.FruitTargetSize.y)
		if newh > fruit.Size.y then
			local oldcf = fruit.CFrame
			fruit.Size = newh * self.FruitTargetSize
			fruit.CFrame =oldcf
			self:UpdateWeld(fruit, fruit.Parent, oldcf, fruit.Parent.CFrame)
		end
	end
end

function Tree:Initialize(Position, Ground)
	local IsRoom = WorldTools:IsRoom(Position + Vector3.new(0,self.RoomNeeded.y/2,0), self.RoomNeeded)
	if IsRoom then 
		self.LastTick = tick()
		self.Ground = Ground		
		self.GroundPos = Position
		
		-- Generate the look of the tree!
		self.FoliageForm = self:GetRandomVector(self.FoliageFormMin, self.FoliageFormMax)
		self.TrunkForm = self:GetRandomVector(self.TrunkFormMin, self.TrunkFormMax)
		self.WantedHeight = self.MinHeight + math.random() * (self.MaxHeight - self.MinHeight)
		
		self.WantedFruit = math.random(1, self.MaxFruit)		
		
		self.FruitTicks = {}
		
		self.GrowTime = self.GrowTimeMin + math.random() * (self.GrowTimeMax - self.GrowTimeMin)		
		-- Let's incoroporate some animal crossing elements: shake trees!		
		
		-- Create the base size!
				
		local NewTrunk = self.Trunk:Clone()
		self.TreeBase = NewTrunk
		self.StartTime = tick()
		NewTrunk.Parent = game.Workspace.Life
		NewTrunk.Size = self.SaplingHeight * self.TrunkForm
		self.TrunkRotation = math.random(1,360)
		NewTrunk.CFrame = CFrame.new(Position) * CFrame.new(0,NewTrunk.Size.y/2,0) * CFrame.Angles(0, math.rad(self.TrunkRotation), 0) -- oh so hipster
		self:UpdateWeld(NewTrunk, Ground, NewTrunk.CFrame, Ground.CFrame)
		self:InitializeFoliage()
		self:InitializeFruit()
	end
	return IsRoom
end

function Tree:GetNewHeight(dt,max)
	-- returns the new height
	local portion = dt/self.GrowTime
	if portion >= 1 then return max end
	-- now ease...
	local ease = (-1 * ((portion-1)^2)) + 1
	return ease * max
end



-- Grows a tick.
function Tree:Grow() 
	-- Update the branch!
	if not self.TreeBase or self.TreeBase.Parent ~= game.Workspace.Life then 
		return false -- If false is returned DESTROY
	end
	local NewHeight = self:GetNewHeight(tick() - self.StartTime, self.WantedHeight)
	if NewHeight > self.TreeBase.Size.y then 
		local dy = NewHeight - self.TreeBase.Size.y 
		self.TreeBase.Size = NewHeight * self.TrunkForm
		self.TreeBase.CFrame = CFrame.new(self.GroundPos) * CFrame.new(0,  self.TreeBase.Size.y/2, 0)  * CFrame.Angles(0, math.rad(self.TrunkRotation), 0)
		self:UpdateWeld(self.TreeBase, self.Ground, self.TreeBase.CFrame, self.Ground.CFrame)
	end
	self:InitializeFoliage()
	self:UpdateFoliage()
	self:InitializeFruit()
	self:UpdateFruit()
	self.LastTick = tick()
	return true
end

function Tree:Generate()

	self.StartTime = 0
	self.MiddleFoliageTime = 0
	self.TopFoliageTime = 0
	self.BottomFoliageTime = 0

	self:Grow()
	for i,v in pairs(self.FruitTicks) do
		v[1] = 0
	end
	self:UpdateFruit()
end


return Tree