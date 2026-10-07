--!strict
-- Every tunable number lives here so designers can tweak feel without touching systems.

local Config = {
	-- Time of day. The city spends most of its time at night: daytime runs DayRushMultiplier
	-- times faster than night, so the "real" vibe is neon-after-dark.
	DayLengthMinutes = 20,
	StartClockTime = 20.5,
	DayRushMultiplier = 3,

	-- Economy
	StartingCredits = 20,
	StartingInventory = { Noodles = 2 },
	NoodleBrickPrice = 4,

	-- Garden (Tiny Eden style care ritual: plants only grow while their soil is watered,
	-- and the soil dries out again after every growth stage)
	GrowSeconds = 45, -- total watered time from seed to ripe
	HarvestYield = 2,

	-- Noodle stall
	CustomerSpawnInterval = { Min = 6, Max = 14 },
	CustomerPatienceSeconds = 75,
	MaxTipFraction = 0.5, -- served instantly = +50% tip, served at the last second = +0%

	-- Saving
	DataStoreName = "ProjectCozy_v1",
	AutosaveSeconds = 120,

	-- Cozy camera (Tiny Eden style diorama view)
	Camera = {
		FieldOfView = 32,
		Pitch = 55, -- degrees looking down
		StartYaw = 200, -- from the south side, looking north at the stall
		Distance = 70,
		MinDistance = 35,
		MaxDistance = 120,
		RotateStep = 45,
		FollowSharpness = 8,
		RotateSharpness = 10,
	},

	-- Home is played in first person, like Tiny Eden. The street keeps the diorama camera.
	FirstPersonAtHome = true,

	-- World-space boxes the client uses to switch camera and audio per area.
	-- Keep in sync with DistrictBuilder (apartment sits on the tower behind the stall).
	Zones = {
		Home = { Center = Vector3.new(0, 53, 26), Size = Vector3.new(18, 12, 18) }, -- apartment + balcony
		Indoors = { Center = Vector3.new(0, 53, 28.5), Size = Vector3.new(18, 12, 13) }, -- apartment only
		Rooftop = { Center = Vector3.new(35, 17, -36), Size = Vector3.new(30, 14, 28) },
	},

	-- Sound asset ids ("rbxassetid://123..."). Left blank on purpose: drop in ids from your
	-- own uploads or licensed Creator Store audio. Blank = silently skipped.
	-- See docs/LIGHTING_AND_AUDIO.md for what each one should sound like.
	Sounds = {
		-- Ambience beds (2D, looped, crossfaded per zone)
		Rain = "",
		CityHum = "",
		RoomTone = "",
		RooftopWind = "",
		-- Music (2D, looped)
		MusicNight = "",
		MusicHome = "",
		-- Positional loops (3D, attached to tagged parts)
		BrothSimmer = "",
		VendingHum = "",
		GrowLampHum = "",
		NeonBuzz = "",
		Fridge = "",
		-- One-shots
		Pop = "",
		Coin = "",
		Water = "",
		Harvest = "",
		Elevator = "",
		Purr = "",
		Nope = "",
	},
}

return Config
