--!strict
-- Lucky Byte Noodles. Chibi customers pop onto the stools with an order bubble; serve them
-- if you have the ingredients. No fail state: if you're slow they just wave and wander off.

local Players = game:GetService("Players")

local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local Config = require(Shared.Config)
local Palette = require(Shared.Palette)
local ItemsModule = require(Shared.Items)

local PlayerData = require(script.Parent.PlayerDataService)
local Notify = require(script.Parent.Notify)

local StallService = {}

local rng = Random.new()
local occupied: { [number]: Model } = {}

local NAMES = { "Kiko", "Zed", "Momo", "Rook", "Lumi", "Taro", "Nyx", "Pip", "Juno", "Hex", "Mochi", "Vee" }
local GREETINGS = {
	"Long shift. Need noodles.",
	"Rain's nice tonight, huh?",
	"My cyberdeck crashed again...",
	"Smells like home in here.",
	"Extra glow, please!",
	"Byte! Hi Byte!",
}

local function makePart(
	parent: Instance,
	name: string,
	size: Vector3,
	cframe: CFrame,
	color: Color3,
	material: Enum.Material?
): Part
	local p = Instance.new("Part")
	p.Name = name
	p.Anchored = true
	p.CanCollide = false
	p.Size = size
	p.CFrame = cframe
	p.Color = color
	p.Material = material or Enum.Material.SmoothPlastic
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end

-- Chibi proportions: the head is bigger than the body. That's the whole trick.
local function buildCustomer(seat: CFrame): Model
	local model = Instance.new("Model")
	model.Name = "Customer"
	local outfit = Palette.ToySet[rng:NextInteger(1, #Palette.ToySet)]
	local glow = Palette.NeonSet[rng:NextInteger(1, #Palette.NeonSet)]

	local body = makePart(model, "Body", Vector3.new(1.6, 1.6, 1.6), seat * CFrame.new(0, 0.8, 0), outfit)
	body.Shape = Enum.PartType.Ball
	model.PrimaryPart = body
	local head =
		makePart(model, "Head", Vector3.new(2.2, 2.2, 2.2), seat * CFrame.new(0, 2.5, 0), Palette.Peach)
	head.Shape = Enum.PartType.Ball
	-- The seat CFrame looks at the counter, so -Z in seat space is "forward" for the face.
	makePart(
		model,
		"Visor",
		Vector3.new(1.7, 0.45, 0.4),
		seat * CFrame.new(0, 2.65, -0.95),
		glow,
		Enum.Material.Neon
	)
	makePart(model, "Hair", Vector3.new(2.3, 0.8, 2.3), seat * CFrame.new(0, 3.35, 0.1), outfit)
	local antenna = makePart(
		model,
		"Antenna",
		Vector3.new(0.4, 0.4, 0.4),
		seat * CFrame.new(0.6, 4.1, 0),
		glow,
		Enum.Material.Neon
	)
	antenna.Shape = Enum.PartType.Ball

	model:SetAttribute("BobAmplitude", 0.08)
	model:SetAttribute("BobSpeed", rng:NextNumber(1.6, 2.6))
	return model
end

local function orderBubble(model: Model, recipe: ItemsModule.Recipe, name: string)
	local gui = Instance.new("BillboardGui")
	gui.Name = "Order"
	gui.Size = UDim2.fromOffset(150, 64)
	gui.StudsOffsetWorldSpace = Vector3.new(0, 4.6, 0)
	gui.AlwaysOnTop = true
	gui.LightInfluence = 0
	gui.MaxDistance = 90

	local bubble = Instance.new("Frame")
	bubble.Size = UDim2.fromScale(1, 1)
	bubble.BackgroundColor3 = Palette.Cream
	bubble.Parent = gui
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0.5, 0)
	corner.Parent = bubble
	local stroke = Instance.new("UIStroke")
	stroke.Color = Palette.NeonPink
	stroke.Thickness = 2
	stroke.Parent = bubble

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.fromScale(1, 0.62)
	label.Text = `{recipe.Icon} {recipe.Name}`
	label.TextColor3 = Palette.Ink
	label.TextScaled = true
	label.Font = Enum.Font.FredokaOne
	label.Parent = bubble

	local who = Instance.new("TextLabel")
	who.BackgroundTransparency = 1
	who.Position = UDim2.fromScale(0, 0.58)
	who.Size = UDim2.fromScale(1, 0.34)
	who.Text = name
	who.TextColor3 = Palette.Brick
	who.TextScaled = true
	who.Font = Enum.Font.FredokaOne
	who.Parent = bubble

	-- Patience bar; the client shrinks it smoothly using the Patience/SpawnedAt attributes.
	local bar = Instance.new("Frame")
	bar.Name = "Patience"
	bar.AnchorPoint = Vector2.new(0.5, 0)
	bar.Position = UDim2.new(0.5, 0, 1, 4)
	bar.Size = UDim2.new(0.7, 0, 0, 5)
	bar.BackgroundColor3 = Palette.NeonLime
	bar.BorderSizePixel = 0
	bar.Parent = bubble
	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(1, 0)
	barCorner.Parent = bar

	gui.Parent = model.PrimaryPart
end

local function leave(spotIndex: number, model: Model, mood: "happy" | "sad")
	if occupied[spotIndex] ~= model then
		return
	end
	occupied[spotIndex] = nil
	model:SetAttribute("Mood", mood)
	local promptObj = model:FindFirstChildWhichIsA("ProximityPrompt", true)
	if promptObj then
		promptObj.Enabled = false
	end
	-- Give the client time to play the hop / pop-out before we remove it.
	task.delay(1.4, function()
		model:Destroy()
	end)
end

local function spawnCustomer(spotIndex: number, seat: CFrame, pot: BasePart)
	local recipeId = ItemsModule.RecipeOrder[rng:NextInteger(1, #ItemsModule.RecipeOrder)]
	local recipe = ItemsModule.Recipes[recipeId]
	local name = NAMES[rng:NextInteger(1, #NAMES)]

	local model = buildCustomer(seat)
	model:SetAttribute("Recipe", recipeId)
	model:SetAttribute("Patience", Config.CustomerPatienceSeconds)
	model:SetAttribute("SpawnedAt", workspace:GetServerTimeNow())
	orderBubble(model, recipe, name)

	local promptObj = Instance.new("ProximityPrompt")
	promptObj.ActionText = `Serve {recipe.Name}`
	promptObj.ObjectText = name
	promptObj.HoldDuration = 0.4
	promptObj.MaxActivationDistance = 9
	promptObj.RequiresLineOfSight = false
	promptObj.Parent = model.PrimaryPart

	local spawnedAt = os.clock()
	promptObj.Triggered:Connect(function(player)
		if occupied[spotIndex] ~= model then
			return
		end
		if not PlayerData.takeItems(player, recipe.Needs) then
			Notify.toast(player, `Need {ItemsModule.describeNeeds(recipe.Needs)}`, "nope")
			return
		end
		local waited = os.clock() - spawnedAt
		local patienceLeft = math.clamp(1 - waited / Config.CustomerPatienceSeconds, 0, 1)
		local tip = math.floor(recipe.Price * Config.MaxTipFraction * patienceLeft + 0.5)
		PlayerData.addCredits(player, recipe.Price + tip)
		PlayerData.bumpStat(player, "Served")
		Notify.pop(pot, 1.2)
		local thanks = GREETINGS[rng:NextInteger(1, #GREETINGS)]
		Notify.toast(
			player,
			`{name}: "{thanks}"  +{recipe.Price} cr` .. (if tip > 0 then ` (+{tip} tip)` else ""),
			"good"
		)
		leave(spotIndex, model, "happy")
	end)

	model:AddTag("Customer")
	model:AddTag("Bob")
	model.Parent = workspace
	occupied[spotIndex] = model

	task.delay(Config.CustomerPatienceSeconds, function()
		leave(spotIndex, model, "sad")
	end)
end

function StallService.start(spots: { CFrame }, pot: BasePart)
	task.spawn(function()
		while true do
			local range = Config.CustomerSpawnInterval
			task.wait(rng:NextNumber(range.Min, range.Max))
			-- Only bring customers in while someone's around to serve them.
			if #Players:GetPlayers() == 0 then
				continue
			end
			local free = {}
			for i in spots do
				if not occupied[i] then
					table.insert(free, i)
				end
			end
			if #free > 0 then
				local i = free[rng:NextInteger(1, #free)]
				spawnCustomer(i, spots[i], pot)
			end
		end
	end)
end

return StallService
