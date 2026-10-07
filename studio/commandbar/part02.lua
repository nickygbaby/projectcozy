-- PROJECT COZY · PART 2 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=2 then warn("Project Cozy: this is part 2, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("ReplicatedStorage/Shared/Config",[=[
--!strict
local Config = { DayLengthMinutes = 20, StartClockTime = 20.5, DayRushMultiplier = 3, StartingCredits = 20, StartingInventory = { Noodles = 2 }, NoodleBrickPrice = 4, GrowSeconds = 45, -- total watered time from seed to ripe
HarvestYield = 2, Orders = { Slots = 3, -- open requests at once
RewardMultiplier = 1.4, -- reward = item value x count x this
HeartBonus = 0.05, -- +5% reward per heart with that neighbor...
MaxBonusHearts = 10, -- ...up to +50%
RefillSeconds = 4, }, CustomerSpawnInterval = { Min = 6, Max = 14 }, CustomerPatienceSeconds = 75, MaxTipFraction = 0.5, -- served instantly = +50% tip, served at the last second = +0%
DataStoreName = "ProjectCozy_v1", AutosaveSeconds = 120, Camera = { FieldOfView = 32, Pitch = 55, -- degrees looking down
StartYaw = 200, -- from the south side, looking north at the stall
Distance = 70, MinDistance = 35, MaxDistance = 120, RotateStep = 45, FollowSharpness = 8, RotateSharpness = 10, }, Lighting = { Exposure = -0.15, -- Lighting.ExposureCompensation
BloomIntensity = 0.4, BloomSize = 18, BloomThreshold = 0.95, -- only the very brightest pixels bloom
NeonTransparency = 0.25, -- neon parts are dimmer when slightly see-through
WindowGlowTransparency = 0.5, -- lit apartment windows
NeonLightBrightness = 0.6, -- PointLights attached to neon parts (lanterns, coin, doors)
SignTextBrightness = 1.1, -- SurfaceGui text on signs
SignLightBrightness = 0.7, -- colored light signs throw onto the street
SignLightRange = 12, GrowLightBrightness = 1.2, }, FirstPersonAtHome = true, Zones = { Home = { Center = Vector3.new(0, 53, 26), Size = Vector3.new(18, 12, 18) }, -- apartment + balcony
Indoors = { Center = Vector3.new(0, 53, 28.5), Size = Vector3.new(18, 12, 13) }, -- apartment only
Rooftop = { Center = Vector3.new(35, 17, -36), Size = Vector3.new(30, 14, 28) }, }, Sounds = { Rain = "", CityHum = "", RoomTone = "", RooftopWind = "", MusicNight = "", MusicHome = "", BrothSimmer = "", VendingHum = "", GrowLampHum = "", NeonBuzz = "", Fridge = "", Pop = "", Coin = "", Water = "", Harvest = "", Cook = "", Elevator = "", Purr = "", Nope = "", }, }
return Config
]=])
S:SetAttribute("CozyNext",3)
print("Project Cozy: part 2/41 done. Paste part 3 next.")
