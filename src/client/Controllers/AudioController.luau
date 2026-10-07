--!strict
-- Zone-aware sound. The mix crossfades as you walk between the Street, the Rooftop, your
-- Balcony ("Home") and Indoors. Rain and the city get muffled behind the window, and the
-- room picks up a living-room reverb. Every sound id lives in Config.Sounds. Blank one-shots
-- fall back to sounds built into the Roblox client; blank loops/music stay silent until you
-- add ids. Full plan: docs/LIGHTING_AND_AUDIO.md.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local CollectionService = game:GetService("CollectionService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared.Config)
local Zones = require(Shared.Zones)

local AudioController = {}

local Sounds = Config.Sounds :: { [string]: string }
local player = Players.LocalPlayer

-- Mix ----------------------------------------------------------------------

local function group(name: string, volume: number): SoundGroup
	local g = Instance.new("SoundGroup")
	g.Name = name
	g.Volume = volume
	g.Parent = SoundService
	return g
end

local Groups = {
	Music = group("Music", 0.6),
	Outside = group("Outside", 1), -- rain + city: muffled indoors
	Ambience = group("Ambience", 1),
	World = group("World", 0.9), -- positional loops and 3D one-shots
	UI = group("UI", 0.7),
}

-- Target volume of each looping bed per zone. Missing = silent.
local BEDS: { [string]: { group: SoundGroup } } = {
	Rain = { group = Groups.Outside },
	CityHum = { group = Groups.Outside },
	RoomTone = { group = Groups.Ambience },
	RooftopWind = { group = Groups.Ambience },
	MusicNight = { group = Groups.Music },
	MusicHome = { group = Groups.Music },
}

local MIX: { [string]: { [string]: number } } = {
	Street = { Rain = 0.5, CityHum = 0.35, MusicNight = 0.35 },
	Rooftop = { Rain = 0.6, CityHum = 0.25, RooftopWind = 0.35, MusicNight = 0.3 },
	Home = { Rain = 0.45, CityHum = 0.3, RoomTone = 0.08, MusicHome = 0.3 },
	Indoors = { Rain = 0.35, CityHum = 0.15, RoomTone = 0.3, MusicHome = 0.4 },
}

local REVERB: { [string]: Enum.ReverbType } = {
	Street = Enum.ReverbType.Alley,
	Rooftop = Enum.ReverbType.City,
	Home = Enum.ReverbType.City,
	Indoors = Enum.ReverbType.LivingRoom,
}

-- How loud each positional loop is, and how far it carries (studs).
local EMITTERS: { [string]: { volume: number, range: number } } = {
	BrothSimmer = { volume = 0.5, range = 30 },
	VendingHum = { volume = 0.3, range = 20 },
	GrowLampHum = { volume = 0.2, range = 18 },
	NeonBuzz = { volume = 0.15, range = 14 },
	Fridge = { volume = 0.2, range = 14 },
}

local function damp(a: number, b: number, sharpness: number, dt: number): number
	return a + (b - a) * (1 - math.exp(-sharpness * dt))
end

-- One-shots ------------------------------------------------------------------

-- Stand-ins built into every Roblox client (the default character sounds), so feedback
-- works with zero uploads. Pitched and trimmed to feel cute. Any id you put in
-- Config.Sounds replaces the stand-in for that key.
type Spec = { id: string, speed: number, volume: number, maxLength: number? }
local BUILTIN: { [string]: Spec } = {
	Pop = { id = "rbxasset://sounds/action_jump_land.mp3", speed = 1.8, volume = 0.5 },
	Water = { id = "rbxasset://sounds/impact_water.mp3", speed = 1.3, volume = 0.3 },
	Harvest = { id = "rbxasset://sounds/action_get_up.mp3", speed = 1.5, volume = 0.5 },
	Cook = { id = "rbxasset://sounds/impact_water.mp3", speed = 0.8, volume = 0.3 },
	Coin = { id = "rbxasset://sounds/action_jump.mp3", speed = 2.2, volume = 0.3 },
	Nope = { id = "rbxasset://sounds/action_jump_land.mp3", speed = 0.7, volume = 0.45 },
	Elevator = { id = "rbxasset://sounds/action_falling.mp3", speed = 1.3, volume = 0.25, maxLength = 1.2 },
	Purr = { id = "rbxasset://sounds/action_swim.mp3", speed = 0.6, volume = 0.25, maxLength = 1.5 },
}

local function resolve(key: string): Spec?
	local id = Sounds[key]
	if id and id ~= "" then
		return { id = id, speed = 1, volume = 1 }
	end
	return BUILTIN[key]
end

local rng = Random.new()

local function playOneShot(key: string, at: Vector3?)
	local spec = resolve(key)
	if not spec then
		return
	end
	local sound = Instance.new("Sound")
	sound.SoundId = spec.id
	sound.Volume = spec.volume
	-- Small pitch wobble keeps repeats cute.
	sound.PlaybackSpeed = spec.speed * rng:NextNumber(0.94, 1.06)
	if spec.maxLength then
		local length = spec.maxLength
		task.delay(length, function()
			local holder = sound.Parent
			if holder and holder:IsA("Attachment") then
				holder:Destroy() -- 3D one-shot: remove its anchor too
			elseif holder then
				sound:Destroy()
			end
		end)
	end
	if at then
		local anchor = Instance.new("Attachment")
		anchor.WorldPosition = at
		anchor.Parent = workspace.Terrain
		sound.SoundGroup = Groups.World
		sound.RollOffMinDistance = 6
		sound.RollOffMaxDistance = 60
		sound.Parent = anchor
		sound.Ended:Once(function()
			anchor:Destroy()
		end)
	else
		sound.SoundGroup = Groups.UI
		sound.Parent = SoundService
		sound.Ended:Once(function()
			sound:Destroy()
		end)
	end
	sound:Play()
end

local function positionOf(inst: Instance): Vector3?
	if inst:IsA("BasePart") then
		return inst.Position
	elseif inst:IsA("Model") then
		return inst:GetPivot().Position
	end
	return nil
end

-- Start ----------------------------------------------------------------------

function AudioController.start()
	-- Looping beds, all started at volume 0 and crossfaded by zone.
	local beds: { [string]: Sound } = {}
	for key, info in BEDS do
		local id = Sounds[key]
		if id and id ~= "" then
			local sound = Instance.new("Sound")
			sound.Name = key
			sound.SoundId = id
			sound.Looped = true
			sound.Volume = 0
			sound.SoundGroup = info.group
			sound.Parent = SoundService
			sound:Play()
			beds[key] = sound
		end
	end

	-- Behind glass, highs disappear first: that's what makes indoors feel safe and warm.
	local muffle = Instance.new("EqualizerSoundEffect")
	muffle.LowGain = 0
	muffle.MidGain = 0
	muffle.HighGain = 0
	muffle.Parent = Groups.Outside

	-- Positional loops on tagged parts.
	local function addEmitter(inst: Instance)
		local key = inst:GetAttribute("SoundKey") :: string?
		local id = key and Sounds[key]
		if not (key and id and id ~= "" and inst:IsA("BasePart")) then
			return
		end
		local spec = EMITTERS[key] or { volume = 0.3, range = 20 }
		local sound = Instance.new("Sound")
		sound.Name = key
		sound.SoundId = id
		sound.Looped = true
		sound.Volume = spec.volume
		sound.RollOffMode = Enum.RollOffMode.InverseTapered
		sound.RollOffMinDistance = 3
		sound.RollOffMaxDistance = spec.range
		sound.SoundGroup = Groups.World
		sound.Parent = inst
		sound.TimePosition = rng:NextNumber(0, 4) -- de-sync identical loops
		sound:Play()
	end
	for _, inst in CollectionService:GetTagged("AudioEmitter") do
		addEmitter(inst)
	end
	CollectionService:GetInstanceAddedSignal("AudioEmitter"):Connect(addEmitter)

	-- Server-requested one-shots, plus a pop sound with every Juice pop.
	local remotes = ReplicatedStorage:WaitForChild("Remotes");
	(remotes:WaitForChild("Sfx") :: RemoteEvent).OnClientEvent:Connect(function(key: string, at: Vector3?)
		playOneShot(key, at)
	end);
	(remotes:WaitForChild("Pop") :: RemoteEvent).OnClientEvent:Connect(function(target: Instance?)
		if target then
			playOneShot("Pop", positionOf(target))
		end
	end);
	(remotes:WaitForChild("Toast") :: RemoteEvent).OnClientEvent:Connect(function(_, tone: string)
		if tone == "nope" then
			playOneShot("Nope")
		end
	end)

	-- Coins: only when credits go up.
	local lastCredits = player:GetAttribute("Credits") :: number?
	player:GetAttributeChangedSignal("Credits"):Connect(function()
		local now = player:GetAttribute("Credits") :: number?
		if lastCredits and now and now > lastCredits then
			playOneShot("Coin")
		end
		lastCredits = now
	end)

	-- Zone crossfade.
	local zone = "Street"
	RunService.Heartbeat:Connect(function(dt)
		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart") :: BasePart?
		if root then
			local current = Zones.at(root.Position)
			if current ~= zone then
				zone = current
				SoundService.AmbientReverb = REVERB[zone] or Enum.ReverbType.NoReverb
			end
		end

		local mix = MIX[zone] or {}
		for key, sound in beds do
			sound.Volume = damp(sound.Volume, mix[key] or 0, 1.5, dt)
		end
		local indoors = zone == "Indoors"
		muffle.HighGain = damp(muffle.HighGain, if indoors then -30 else 0, 3, dt)
		muffle.MidGain = damp(muffle.MidGain, if indoors then -10 else 0, 3, dt)
	end)
	SoundService.AmbientReverb = REVERB[zone]
end

return AudioController
