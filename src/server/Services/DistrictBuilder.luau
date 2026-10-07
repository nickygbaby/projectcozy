--!strict
-- Builds Lantern Row, the starter district, out of primitive parts so the game is playable
-- the moment you sync it. This is a greybox: every piece here is meant to be swapped for
-- chunky, bevelled art meshes later (see docs/ART_DIRECTION.md) while keeping the same
-- names, tags and attributes that the gameplay services look for.
--
-- Layout (top-down, +Z is "north"):
--
--   [ buildings  | Lucky Byte Noodles | buildings ]   z  22..50
--   [ sidewalk   vending  stall  cat              ]   z  12..22
--   [ ============ wet neon street ============== ]   z -12..12
--   [ sidewalk  stairs ->                          ]   z -22..-12
--   [ buildings      | rooftop garden building    ]   z -50..-22

local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local Palette = require(Shared.Palette)

export type District = {
	Root: Model,
	CustomerSpots: { CFrame },
	StallPot: BasePart,
	Vending: BasePart,
	Planters: { Model },
	RoboCat: Model,
}

local SIDEWALK_Y = 0.6
local ROOF_Y = 10
local rng = Random.new(2077)

-- Helpers --------------------------------------------------------------------

local function make(className: string, props: { [string]: any }, parent: Instance?): any
	local inst = Instance.new(className :: any)
	for key, value in props do
		(inst :: any)[key] = value
	end
	if parent then
		inst.Parent = parent
	end
	return inst
end

local function part(
	parent: Instance,
	name: string,
	size: Vector3,
	cframe: CFrame,
	color: Color3,
	props: { [string]: any }?
): Part
	local p = make("Part", {
		Name = name,
		Anchored = true,
		Size = size,
		CFrame = cframe,
		Color = color,
		Material = Enum.Material.SmoothPlastic,
		TopSurface = Enum.SurfaceType.Smooth,
		BottomSurface = Enum.SurfaceType.Smooth,
	})
	if props then
		for key, value in props do
			(p :: any)[key] = value
		end
	end
	p.Parent = parent
	return p
end

local function neon(
	parent: Instance,
	name: string,
	size: Vector3,
	cframe: CFrame,
	color: Color3,
	light: number?
): Part
	local p = part(parent, name, size, cframe, color, { Material = Enum.Material.Neon, CastShadow = false })
	if light then
		make("PointLight", { Color = color, Range = light, Brightness = 1.5, Shadows = false }, p)
	end
	return p
end

-- Cylinders in Roblox lie along X; this stands one upright.
local UPRIGHT = CFrame.Angles(0, 0, math.rad(90))

local function cylinder(
	parent: Instance,
	name: string,
	height: number,
	diameter: number,
	position: Vector3,
	color: Color3,
	props: { [string]: any }?
): Part
	local merged: { [string]: any } = { Shape = Enum.PartType.Cylinder }
	if props then
		for key, value in props do
			merged[key] = value
		end
	end
	return part(
		parent,
		name,
		Vector3.new(height, diameter, diameter),
		CFrame.new(position) * UPRIGHT,
		color,
		merged
	)
end

local function prompt(
	parent: Instance,
	action: string,
	object: string,
	props: { [string]: any }?
): ProximityPrompt
	local pp = make("ProximityPrompt", {
		ActionText = action,
		ObjectText = object,
		HoldDuration = 0,
		MaxActivationDistance = 10,
		RequiresLineOfSight = false,
	})
	if props then
		for key, value in props do
			(pp :: any)[key] = value
		end
	end
	pp.Parent = parent
	return pp
end

-- A flat sign board with glowing text that also throws colored light on the street.
-- `facing` is the world direction the text should face.
local function sign(
	parent: Instance,
	text: string,
	size: Vector2,
	position: Vector3,
	facing: Vector3,
	color: Color3,
	flicker: boolean?
): Part
	local cf = CFrame.lookAt(position, position + facing)
	local board =
		part(parent, "Sign", Vector3.new(size.X, size.Y, 0.4), cf, Palette.Ink, { CastShadow = false })
	local gui = make("SurfaceGui", {
		Face = Enum.NormalId.Front,
		SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud,
		PixelsPerStud = 40,
		LightInfluence = 0,
		Brightness = 2.5,
	}, board)
	local label = make("TextLabel", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = color,
		TextScaled = true,
		Font = Enum.Font.Michroma,
	}, gui)
	make("UIStroke", { Color = color, Thickness = 2, Transparency = 0.4 }, label)
	make("UIPadding", {
		PaddingTop = UDim.new(0.12, 0),
		PaddingBottom = UDim.new(0.12, 0),
		PaddingLeft = UDim.new(0.06, 0),
		PaddingRight = UDim.new(0.06, 0),
	}, label)
	-- Neon frame
	local t = 0.25
	neon(board, "FrameTop", Vector3.new(size.X + t, t, t), cf * CFrame.new(0, size.Y / 2, -0.2), color)
	neon(board, "FrameBottom", Vector3.new(size.X + t, t, t), cf * CFrame.new(0, -size.Y / 2, -0.2), color)
	make(
		"SurfaceLight",
		{ Face = Enum.NormalId.Front, Color = color, Range = 16, Brightness = 2, Angle = 70 },
		board
	)
	if flicker then
		board:AddTag("NeonFlicker")
	end
	return board
end

-- Pieces ---------------------------------------------------------------------

local function buildGround(root: Model)
	local ground = make("Folder", { Name = "Ground" }, root)
	part(ground, "Underlay", Vector3.new(400, 1, 400), CFrame.new(0, -0.5, 0), Palette.Ink)
	-- Wet street: a touch of reflectance catches the sky and neon haze.
	part(
		ground,
		"Street",
		Vector3.new(140, 0.2, 24),
		CFrame.new(0, 0.1, 0),
		Palette.Asphalt,
		{ Reflectance = 0.12 }
	)
	for x = -60, 60, 12 do
		neon(ground, "LaneDash", Vector3.new(5, 0.05, 0.4), CFrame.new(x, 0.22, 0), Palette.NeonAmber)
	end
	part(
		ground,
		"SidewalkNorth",
		Vector3.new(140, SIDEWALK_Y, 10),
		CFrame.new(0, SIDEWALK_Y / 2, 17),
		Palette.Concrete
	)
	part(
		ground,
		"SidewalkSouth",
		Vector3.new(140, SIDEWALK_Y, 10),
		CFrame.new(0, SIDEWALK_Y / 2, -17),
		Palette.Concrete
	)
	neon(
		ground,
		"CurbGlowNorth",
		Vector3.new(140, 0.15, 0.15),
		CFrame.new(0, SIDEWALK_Y, 12),
		Palette.NeonCyan
	)
	neon(
		ground,
		"CurbGlowSouth",
		Vector3.new(140, 0.15, 0.15),
		CFrame.new(0, SIDEWALK_Y, -12),
		Palette.NeonPink
	)

	-- Puddles reflect neon tint; pure set dressing.
	for _ = 1, 9 do
		local d = rng:NextNumber(3, 7)
		cylinder(
			ground,
			"Puddle",
			0.05,
			d,
			Vector3.new(rng:NextNumber(-60, 60), 0.23, rng:NextNumber(-9, 9)),
			Palette.Violet,
			{ Material = Enum.Material.Glass, Reflectance = 0.35, Transparency = 0.3, CanCollide = false }
		)
	end

	-- Soft invisible walls at the street ends; the haze hides what's beyond.
	for _, x in { -71, 71 } do
		part(
			ground,
			"Boundary",
			Vector3.new(2, 40, 120),
			CFrame.new(x, 20, 0),
			Palette.Ink,
			{ Transparency = 1 }
		)
		for z = -10, 10, 5 do
			cylinder(ground, "Bollard", 2.4, 0.8, Vector3.new(x * 0.98, 1.2, z), Palette.Concrete)
			neon(
				ground,
				"BollardCap",
				Vector3.new(0.9, 0.3, 0.9),
				CFrame.new(x * 0.98, 2.5, z),
				Palette.NeonAmber
			)
		end
	end

	make("SpawnLocation", {
		Name = "Spawn",
		Anchored = true,
		Neutral = true,
		Size = Vector3.new(6, 0.2, 6),
		CFrame = CFrame.new(-30, 0.3, 0),
		Color = Palette.Violet,
		Material = Enum.Material.SmoothPlastic,
		TopSurface = Enum.SurfaceType.Smooth,
		Duration = 0,
	}, ground)
end

local SIGN_WORDS =
	{ "SYNTH", "24/7", "CHROME", "KARAOKE", "PIXEL BAR", "SOBA", "REPAIR", "★ COZY ★", "LOFI", "TEA" }

-- A chunky building with warm lit windows on the street-facing facade.
local function building(parent: Instance, x0: number, x1: number, zNear: number, zFar: number, height: number)
	local model = make("Model", { Name = "Building" }, parent)
	local width = x1 - x0
	local depth = math.abs(zFar - zNear)
	local cx = (x0 + x1) / 2
	local cz = (zNear + zFar) / 2
	local facing = if zNear > 0 then Vector3.new(0, 0, -1) else Vector3.new(0, 0, 1)
	local tones = { Palette.Concrete, Palette.Brick, Palette.Violet, Palette.Indigo }
	local body = part(
		model,
		"Body",
		Vector3.new(width, height, depth),
		CFrame.new(cx, height / 2, cz),
		tones[rng:NextInteger(1, #tones)]
	)
	model.PrimaryPart = body

	-- Rounded "toy" roof lip + neon trim
	part(
		model,
		"RoofLip",
		Vector3.new(width + 1, 1, depth + 1),
		CFrame.new(cx, height + 0.5, cz),
		Palette.Concrete
	)
	neon(
		model,
		"RoofTrim",
		Vector3.new(width + 1.1, 0.2, 0.2),
		CFrame.new(cx, height + 0.1, zNear + facing.Z * 0.6),
		Palette.NeonSet[rng:NextInteger(1, #Palette.NeonSet)]
	)

	-- Windows: warm and lived-in. Mostly cozy amber, a few neon screens.
	local facadeZ = zNear + facing.Z * 0.15
	for y = 4, height - 3, 4.5 do
		for x = x0 + 2.5, x1 - 2.5, 4 do
			local roll = rng:NextNumber()
			if roll < 0.62 then
				local color = if roll < 0.08
					then Palette.NeonPink
					elseif roll < 0.14 then Palette.NeonCyan
					else Palette.Butter
				neon(model, "Window", Vector3.new(2.2, 2.8, 0.3), CFrame.new(x, y, facadeZ), color):SetAttribute(
					"Lit",
					true
				)
			else
				part(
					model,
					"Window",
					Vector3.new(2.2, 2.8, 0.3),
					CFrame.new(x, y, facadeZ),
					Palette.Ink,
					{ Reflectance = 0.25 }
				)
			end
			-- Little sill makes each window read as a cozy box rather than a texture.
			part(
				model,
				"Sill",
				Vector3.new(2.6, 0.3, 0.6),
				CFrame.new(x, y - 1.55, facadeZ + facing.Z * 0.3),
				Palette.Cream
			)
		end
	end

	if width >= 10 and rng:NextNumber() < 0.75 then
		local word = SIGN_WORDS[rng:NextInteger(1, #SIGN_WORDS)]
		sign(
			model,
			word,
			Vector2.new(math.min(width - 3, 10), 2.6),
			Vector3.new(cx, rng:NextNumber(6, math.max(7, height - 4)), zNear + facing.Z * 0.4),
			facing,
			Palette.NeonSet[rng:NextInteger(1, #Palette.NeonSet)],
			rng:NextNumber() < 0.5
		)
	end
	return model
end

local function buildSkyline(root: Model)
	local folder = make("Folder", { Name = "Buildings" }, root)
	-- North row, leaving a gap at x -9..9 for the noodle stall's alcove building.
	local x = -70
	while x < 70 do
		local w = rng:NextInteger(10, 18)
		local x1 = math.min(x + w, 70)
		if x >= -9 and x < 9 then
			building(folder, -9, 9, 22, 34, 14)
			x = 9
		else
			if x < -9 and x1 > -9 then
				x1 = -9
			end
			building(folder, x, x1, 22, 50, rng:NextInteger(18, 40))
			x = x1
		end
	end
	-- South row, the garden building occupies x 20..50.
	x = -70
	while x < 70 do
		local w = rng:NextInteger(10, 18)
		local x1 = math.min(x + w, 70)
		if x >= 20 and x < 50 then
			x = 50
		else
			if x1 > 20 and x < 20 then
				x1 = 20
			end
			-- The south side is low-rise so it never blocks the diorama camera, which looks north.
			building(folder, x, x1, -22, -50, rng:NextInteger(12, 20))
			x = x1
		end
	end
	-- Distant tall towers to sell scale through the haze.
	for _ = 1, 10 do
		local tx = rng:NextNumber(-120, 120)
		local tz = if rng:NextNumber() < 0.5 then rng:NextNumber(70, 140) else rng:NextNumber(-140, -70)
		local h = rng:NextNumber(60, 140)
		part(
			folder,
			"Tower",
			Vector3.new(rng:NextNumber(14, 26), h, rng:NextNumber(14, 26)),
			CFrame.new(tx, h / 2, tz),
			Palette.Indigo
		)
		neon(folder, "TowerBeacon", Vector3.new(1, 1, 1), CFrame.new(tx, h + 0.5, tz), Palette.NeonRed):AddTag(
			"NeonFlicker"
		)
	end

	-- Strings of lanterns across the street.
	for _, lx in { -40, -20, 22, 46 } do
		part(
			folder,
			"LanternWire",
			Vector3.new(0.1, 0.1, 44),
			CFrame.new(lx, 15, 0),
			Palette.Ink,
			{ CanCollide = false, CastShadow = false }
		)
		for lz = -16, 16, 8 do
			local color = if (lz // 8) % 2 == 0 then Palette.NeonPink else Palette.NeonAmber
			local lantern = make("Model", { Name = "Lantern" }, folder)
			local ball = neon(lantern, "Glow", Vector3.new(1.6, 1.6, 1.6), CFrame.new(lx, 14, lz), color, 12)
			ball.Shape = Enum.PartType.Ball
			lantern.PrimaryPart = ball
			lantern:SetAttribute("BobAmplitude", 0.15)
			lantern:SetAttribute("BobSpeed", 1.4)
			lantern:AddTag("Bob")
		end
	end
end

local function buildStall(root: Model): (BasePart, { CFrame })
	local stall = make("Model", { Name = "LuckyByteNoodles" }, root)
	local base = SIDEWALK_Y

	local counter =
		part(stall, "Counter", Vector3.new(14, 3.4, 3), CFrame.new(0, base + 1.7, 18), Palette.Wood)
	stall.PrimaryPart = counter
	part(stall, "CounterTop", Vector3.new(14.6, 0.4, 3.6), CFrame.new(0, base + 3.6, 17.9), Palette.Cream)
	part(stall, "BackWall", Vector3.new(15, 9, 1), CFrame.new(0, base + 4.5, 21.4), Palette.Coral)
	neon(stall, "MenuStrip", Vector3.new(10, 0.25, 0.1), CFrame.new(0, base + 6.5, 20.85), Palette.NeonCyan)

	for _, px in { -7, 7 } do
		cylinder(stall, "Post", 8.4, 0.6, Vector3.new(px, base + 4.2, 15.6), Palette.Wood)
	end

	-- Striped awning, tilted toward the street.
	local slats = 7
	for i = 0, slats - 1 do
		local sx = -7 + 1 + i * 2
		local color = if i % 2 == 0 then Palette.Coral else Palette.Cream
		part(
			stall,
			"Awning",
			Vector3.new(2, 0.35, 7),
			CFrame.new(sx, base + 9, 18) * CFrame.Angles(math.rad(-14), 0, 0),
			color,
			{ CastShadow = true }
		)
	end
	-- Scalloped awning edge: little bobbles read as soft fabric at diorama scale.
	for i = 0, 13 do
		local bx = -6.5 + i
		part(
			stall,
			"AwningEdge",
			Vector3.new(0.9, 0.9, 0.9),
			CFrame.new(bx, base + 7.75, 14.6),
			if i % 2 == 0 then Palette.Coral else Palette.Cream,
			{ Shape = Enum.PartType.Ball, CastShadow = false }
		)
	end

	-- Paper-ish lanterns under the awning
	for _, lx in { -5.5, -1.8, 1.8, 5.5 } do
		local lantern = make("Model", { Name = "StallLantern" }, stall)
		local glow = neon(
			lantern,
			"Glow",
			Vector3.new(1.2, 1.2, 1.2),
			CFrame.new(lx, base + 6.4, 15.4),
			Palette.NeonRed,
			10
		)
		glow.Shape = Enum.PartType.Ball
		lantern.PrimaryPart = glow
		lantern:SetAttribute("BobAmplitude", 0.12)
		lantern:SetAttribute("BobSpeed", 1.8)
		lantern:AddTag("Bob")
	end

	sign(
		stall,
		"LUCKY BYTE NOODLES",
		Vector2.new(13, 2.4),
		Vector3.new(0, base + 11.6, 17.6),
		Vector3.new(0, 0, -1),
		Palette.NeonPink
	)

	-- The broth pot. Server pops it when an order is served.
	local pot = cylinder(stall, "Pot", 1.6, 2.2, Vector3.new(3.5, base + 4.6, 18.4), Palette.Concrete)
	local steamAt = make("Attachment", { Name = "Steam", Position = Vector3.new(0.9, 0, 0) }, pot)
	make("ParticleEmitter", {
		Rate = 6,
		Lifetime = NumberRange.new(2, 3),
		Speed = NumberRange.new(1.5, 2.5),
		SpreadAngle = Vector2.new(12, 12),
		Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.6), NumberSequenceKeypoint.new(1, 2.2) }),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(0.2, 0.6),
			NumberSequenceKeypoint.new(1, 1),
		}),
		Color = ColorSequence.new(Palette.Cream),
		LightInfluence = 0.3,
		Drag = 0.6,
		Acceleration = Vector3.new(0, 1, 0),
		-- Emit along the attachment's +X, which is world up on an upright cylinder.
		EmissionDirection = Enum.NormalId.Right,
	}, steamAt)
	make("PointLight", { Color = Palette.NeonAmber, Range = 8, Brightness = 1 }, pot)

	-- Stools and the spots where customers sit.
	local spots = {}
	for _, sx in { -4.5, 0, 4.5 } do
		cylinder(stall, "StoolLeg", 2, 0.4, Vector3.new(sx, base + 1, 14.6), Palette.Ink)
		cylinder(stall, "StoolSeat", 0.4, 1.8, Vector3.new(sx, base + 2.1, 14.6), Palette.Peach)
		local at = Vector3.new(sx, base + 2.3, 14.6)
		table.insert(spots, CFrame.lookAt(at, at + Vector3.new(0, 0, 1)))
	end

	return pot, spots
end

local function buildVending(root: Model): BasePart
	local model = make("Model", { Name = "NoodleVending" }, root)
	local body =
		part(model, "Body", Vector3.new(4, 7, 2.6), CFrame.new(-14, SIDEWALK_Y + 3.5, 20.4), Palette.Indigo)
	model.PrimaryPart = body
	local panel = sign(
		model,
		"NOODLE\nBRICKS",
		Vector2.new(3.2, 3.2),
		Vector3.new(-14, SIDEWALK_Y + 4.6, 19.05),
		Vector3.new(0, 0, -1),
		Palette.NeonCyan
	)
	panel.Name = "Panel"
	neon(
		model,
		"Slot",
		Vector3.new(2.4, 0.5, 0.2),
		CFrame.new(-14, SIDEWALK_Y + 1.6, 19.05),
		Palette.NeonLime
	)
	local coin = neon(
		model,
		"HoloCoin",
		Vector3.new(0.3, 2, 2),
		CFrame.new(-14, SIDEWALK_Y + 8.6, 20.4),
		Palette.NeonAmber,
		6
	)
	coin.Shape = Enum.PartType.Cylinder
	coin.Transparency = 0.3
	coin:AddTag("Spin")
	return body
end

local function buildRoboCat(root: Model): Model
	local cat = make("Model", { Name = "Byte" }, root)
	local p = Vector3.new(-9, SIDEWALK_Y, 14)
	local body =
		part(cat, "Body", Vector3.new(1.6, 1.2, 2.4), CFrame.new(p + Vector3.new(0, 0.6, 0)), Palette.Lilac)
	cat.PrimaryPart = body
	part(cat, "Head", Vector3.new(1.6, 1.4, 1.4), CFrame.new(p + Vector3.new(0, 1.5, -1.1)), Palette.Lilac)
	for _, side in { -1, 1 } do
		part(
			cat,
			"Ear",
			Vector3.new(0.4, 0.6, 0.5),
			CFrame.new(p + Vector3.new(side * 0.5, 2.45, -1.1)),
			Palette.Lilac,
			{ Shape = Enum.PartType.Wedge }
		)
		neon(
			cat,
			"Eye",
			Vector3.new(0.3, 0.3, 0.1),
			CFrame.new(p + Vector3.new(side * 0.35, 1.6, -1.82)),
			Palette.NeonCyan
		)
	end
	part(
		cat,
		"Tail",
		Vector3.new(0.3, 0.3, 1.6),
		CFrame.new(p + Vector3.new(0, 1.2, 1.6)) * CFrame.Angles(math.rad(35), 0, 0),
		Palette.Lilac
	)
	neon(
		cat,
		"TailTip",
		Vector3.new(0.4, 0.4, 0.4),
		CFrame.new(p + Vector3.new(0, 1.75, 2.25)),
		Palette.NeonPink
	)
	cat:SetAttribute("BobAmplitude", 0.06)
	cat:SetAttribute("BobSpeed", 2.2)
	cat:AddTag("Bob")
	return cat
end

local CROPS = { "Scallion", "Glowshroom", "EmberChili" }
local CROP_COLORS =
	{ Scallion = Palette.NeonLime, Glowshroom = Palette.NeonCyan, EmberChili = Palette.NeonRed }

local function buildGarden(root: Model): { Model }
	local garden = make("Model", { Name = "RooftopGarden" }, root)
	local x0, x1, z0, z1 = 20, 50, -50, -22
	part(
		garden,
		"Body",
		Vector3.new(x1 - x0, ROOF_Y, z1 - z0),
		CFrame.new((x0 + x1) / 2, ROOF_Y / 2, (z0 + z1) / 2),
		Palette.Brick
	)
	part(
		garden,
		"Roof",
		Vector3.new(x1 - x0, 0.4, z1 - z0),
		CFrame.new((x0 + x1) / 2, ROOF_Y + 0.2, (z0 + z1) / 2),
		Palette.Concrete
	)

	-- Parapet with a gap where the stairs arrive.
	local top = ROOF_Y + 0.4
	part(
		garden,
		"Parapet",
		Vector3.new(x1 - x0, 1.2, 0.6),
		CFrame.new((x0 + x1) / 2, top + 0.6, z0 + 0.3),
		Palette.Cream
	)
	part(
		garden,
		"Parapet",
		Vector3.new(x1 - x0 - 6, 1.2, 0.6),
		CFrame.new((x0 + x1) / 2 + 3, top + 0.6, z1 - 0.3),
		Palette.Cream
	)
	part(
		garden,
		"Parapet",
		Vector3.new(0.6, 1.2, z1 - z0),
		CFrame.new(x1 - 0.3, top + 0.6, (z0 + z1) / 2),
		Palette.Cream
	)
	part(
		garden,
		"Parapet",
		Vector3.new(0.6, 1.2, z1 - z0 - 6),
		CFrame.new(x0 + 0.3, top + 0.6, (z0 + z1) / 2 - 3),
		Palette.Cream
	)
	neon(
		garden,
		"ParapetGlow",
		Vector3.new(x1 - x0, 0.15, 0.15),
		CFrame.new((x0 + x1) / 2, top + 1.25, z0 + 0.3),
		Palette.NeonLime
	)

	-- Stairs up from the south sidewalk, climbing toward +X.
	local steps = 12
	local rise = (top - SIDEWALK_Y) / steps
	for i = 1, steps do
		local h = SIDEWALK_Y + rise * i
		part(
			garden,
			"Step",
			Vector3.new(2, h, 4),
			CFrame.new(x0 - 25 + i * 2, h / 2, -19),
			if i % 2 == 0 then Palette.Concrete else Palette.Violet
		)
	end
	-- Landing joins the top step to the roof gap.
	part(garden, "Landing", Vector3.new(3, top, 6), CFrame.new(x0 + 0.5, top / 2, -20), Palette.Concrete)
	neon(
		garden,
		"StairGlow",
		Vector3.new(26, 0.15, 0.15),
		CFrame.new(x0 - 12, (SIDEWALK_Y + top) / 2 + 1.2, -17)
			* CFrame.Angles(0, 0, math.atan2(top - SIDEWALK_Y, 24)),
		Palette.NeonCyan
	)

	sign(
		garden,
		"SKY GARDEN",
		Vector2.new(9, 2.2),
		Vector3.new(35, ROOF_Y - 3, -21.6),
		Vector3.new(0, 0, 1),
		Palette.NeonLime
	)

	-- Planters in two rows, each under a purple grow lamp.
	local planters = {}
	for row, pz in { -30, -40 } do
		local lamp = neon(
			garden,
			"GrowLamp",
			Vector3.new(26, 0.4, 0.8),
			CFrame.new(35, top + 7, pz),
			Palette.NeonPurple
		)
		make("SurfaceLight", {
			Face = Enum.NormalId.Bottom,
			Color = Palette.NeonPurple,
			Range = 10,
			Brightness = 3,
			Angle = 120,
		}, lamp)
		for _, lx in { 23, 47 } do
			cylinder(garden, "LampPost", 7, 0.4, Vector3.new(lx, top + 3.5, pz), Palette.Ink)
		end

		for i, px in { 27, 35, 43 } do
			local crop = CROPS[i]
			local planter = make("Model", { Name = `Planter_{row}_{i}` }, garden)
			local box =
				part(planter, "Box", Vector3.new(6, 1.6, 5), CFrame.new(px, top + 0.8, pz), Palette.Wood)
			local soil = part(
				planter,
				"Soil",
				Vector3.new(5.2, 0.3, 4.2),
				CFrame.new(px, top + 1.65, pz),
				Palette.Soil,
				{ Material = Enum.Material.Ground }
			)
			planter.PrimaryPart = box
			-- Crop marker stake so players can read what grows where.
			cylinder(planter, "Stake", 1.6, 0.15, Vector3.new(px + 2.5, top + 2.4, pz - 2.2), Palette.Cream)
			neon(
				planter,
				"Marker",
				Vector3.new(0.6, 0.6, 0.6),
				CFrame.new(px + 2.5, top + 3.3, pz - 2.2),
				CROP_COLORS[crop]
			)
			planter:SetAttribute("Crop", crop)
			planter:SetAttribute("Stage", 0)
			planter:AddTag("Planter")
			prompt(soil, "Plant", crop, { Name = "GardenPrompt" })
			table.insert(planters, planter)
		end
	end
	return planters
end

-- Public ---------------------------------------------------------------------

local DistrictBuilder = {}

function DistrictBuilder.build(): District
	local existing = workspace:FindFirstChild("LanternRow")
	if existing then
		existing:Destroy()
	end
	local root = make("Model", { Name = "LanternRow" }) :: Model

	buildGround(root)
	buildSkyline(root)
	local pot, spots = buildStall(root)
	local vending = buildVending(root)
	local cat = buildRoboCat(root)
	local planters = buildGarden(root)

	prompt(vending, "Buy Noodle Brick", "Vending", { Name = "BuyPrompt" })
	prompt(cat.PrimaryPart :: BasePart, "Pet", "Byte", { Name = "PetPrompt", MaxActivationDistance = 7 })

	root.Parent = workspace
	return {
		Root = root,
		CustomerSpots = spots,
		StallPot = pot,
		Vending = vending,
		Planters = planters,
		RoboCat = cat,
	}
end

return DistrictBuilder
