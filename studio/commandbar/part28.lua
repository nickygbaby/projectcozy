-- PROJECT COZY · PART 28 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=28 then warn("Project Cozy: this is part 28, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("StarterPlayer/StarterPlayerScripts/Client/Controllers/AudioController",[=[
--!strict
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
local function group(name: string, volume: number): SoundGroup
local g = Instance.new("SoundGroup")
g.Name = name
g.Volume = volume
g.Parent = SoundService
return g
end
local Groups = { Music = group("Music", 0.6), Outside = group("Outside", 1), -- rain + city: muffled indoors
Ambience = group("Ambience", 1), World = group("World", 0.9), -- positional loops and 3D one-shots
UI = group("UI", 0.7), }
local BEDS: { [string]: { group: SoundGroup } } = { Rain = { group = Groups.Outside }, CityHum = { group = Groups.Outside }, RoomTone = { group = Groups.Ambience }, RooftopWind = { group = Groups.Ambience }, MusicNight = { group = Groups.Music }, MusicHome = { group = Groups.Music }, }
local MIX: { [string]: { [string]: number } } = { Street = { Rain = 0.5, CityHum = 0.35, MusicNight = 0.35 }, Rooftop = { Rain = 0.6, CityHum = 0.25, RooftopWind = 0.35, MusicNight = 0.3 }, Home = { Rain = 0.45, CityHum = 0.3, RoomTone = 0.08, MusicHome = 0.3 }, Indoors = { Rain = 0.35, CityHum = 0.15, RoomTone = 0.3, MusicHome = 0.4 }, }
local REVERB: { [string]: Enum.ReverbType } = { Street = Enum.ReverbType.Alley, Rooftop = Enum.ReverbType.City, Home = Enum.ReverbType.City, Indoors = Enum.ReverbType.LivingRoom, }
local EMITTERS: { [string]: { volume: number, range: number } } = { BrothSimmer = { volume = 0.5, range = 30 }, VendingHum = { volume = 0.3, range = 20 }, GrowLampHum = { volume = 0.2, range = 18 }, NeonBuzz = { volume = 0.15, range = 14 }, Fridge = { volume = 0.2, range = 14 }, }
local function damp(a: number, b: number, sharpness: number, dt: number): number
return a + (b - a) * (1 - math.exp(-sharpness * dt))
end
type Spec = { id: string, speed: number, volume: number, maxLength: number? }
local BUILTIN: { [string]: Spec } = { Pop = { id = "rbxasset://sounds/action_jump_land.mp3", speed = 1.8, volume = 0.5 }, Water = { id = "rbxasset://sounds/impact_water.mp3", speed = 1.3, volume = 0.3 }, Harvest = { id = "rbxasset://sounds/action_get_up.mp3", speed = 1.5, volume = 0.5 }, Cook = { id = "rbxasset://sounds/impact_water.mp3", speed = 0.8, volume = 0.3 }, Coin = { id = "rbxasset://sounds/action_jump.mp3", speed = 2.2, volume = 0.3 }, Nope = { id = "rbxasset://sounds/action_jump_land.mp3", speed = 0.7, volume = 0.45 }, Elevator = { id = "rbxasset://sounds/action_falling.mp3", speed = 1.3, volume = 0.25, maxLength = 1.2 }, Purr = { id = "rbxasset://sounds/action_swim.mp3", speed = 0.6, volume = 0.25, maxLength = 1.5 }, }
local function resolve(key: string): Spec?
local id = Sounds[key]
if id and id ~= "" then return { id = id, speed = 1, volume = 1 }
end
return BUILTIN[key]
end
local rng = Random.new()
local function playOneShot(key: string, at: Vector3?)
local spec = resolve(key)
if not spec then return
end
local sound = Instance.new("Sound")
sound.SoundId = spec.id
sound.Volume = spec.volume
]=])
S:SetAttribute("CozyNext",29)
print("Project Cozy: part 28/41 done. Paste part 29 next.")
