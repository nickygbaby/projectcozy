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

	-- Garden
	GrowSeconds = 45, -- seed -> ripe
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

	-- Sound asset ids. Left blank on purpose: drop in ids from your own uploads / Creator Store.
	Sounds = {
		Rain = "",
		CityHum = "",
		Pop = "",
		Coin = "",
	},
}

return Config
