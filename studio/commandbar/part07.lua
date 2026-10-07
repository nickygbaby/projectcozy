-- PROJECT COZY · PART 7 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=7 then warn("Project Cozy: this is part 7, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("ServerScriptService/Server/Services/AtmosphereService",[=[
--!strict
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local Config = require(Shared.Config)
type Key = { t: number, -- ClockTime
ambient: Color3, outdoor: Color3, haze: Color3, decay: Color3, brightness: number, density: number, }
local KEYS: { Key } = { { t = 2, ambient = Color3.fromRGB(58, 40, 96), outdoor = Color3.fromRGB(70, 48, 120), haze = Color3.fromRGB(70, 40, 120), decay = Color3.fromRGB(30, 20, 60), brightness = 0.6, density = 0.38, }, { t = 6, ambient = Color3.fromRGB(110, 70, 110), outdoor = Color3.fromRGB(170, 110, 140), haze = Color3.fromRGB(255, 150, 170), decay = Color3.fromRGB(120, 70, 120), brightness = 1.6, density = 0.34, }, { t = 12, ambient = Color3.fromRGB(110, 120, 120), outdoor = Color3.fromRGB(160, 170, 160), haze = Color3.fromRGB(190, 220, 200), decay = Color3.fromRGB(120, 140, 130), brightness = 2.2, density = 0.3, }, { t = 18, ambient = Color3.fromRGB(120, 70, 100), outdoor = Color3.fromRGB(190, 100, 130), haze = Color3.fromRGB(255, 120, 150), decay = Color3.fromRGB(110, 50, 110), brightness = 1.4, density = 0.34, }, { t = 21, ambient = Color3.fromRGB(70, 48, 110), outdoor = Color3.fromRGB(80, 58, 140), haze = Color3.fromRGB(90, 50, 150), decay = Color3.fromRGB(40, 25, 80), brightness = 0.8, density = 0.36, }, }
local function sample(clock: number): Key
local n = #KEYS
for i = 1, n do
local a = KEYS[i]
local b = KEYS[i % n + 1]
local tb = if b.t <= a.t then b.t + 24 else b.t
local c = if clock < a.t then clock + 24 else clock
if c >= a.t and c < tb then local alpha = (c - a.t) / (tb - a.t)
alpha = alpha * alpha * (3 - 2 * alpha)
return { t = clock, ambient = a.ambient:Lerp(b.ambient, alpha), outdoor = a.outdoor:Lerp(b.outdoor, alpha), haze = a.haze:Lerp(b.haze, alpha), decay = a.decay:Lerp(b.decay, alpha), brightness = a.brightness + (b.brightness - a.brightness) * alpha, density = a.density + (b.density - a.density) * alpha, }
end
end
return KEYS[1]
end
local function getOrCreate(className: string, name: string, parent: Instance): any
local existing = parent:FindFirstChild(name)
if existing and existing:IsA(className) then return existing
end
local inst = Instance.new(className :: any)
inst.Name = name
inst.Parent = parent
return inst
end
local AtmosphereService = {}
function AtmosphereService.start()
Lighting.GlobalShadows = true
Lighting.ShadowSoftness = 0.6
Lighting.EnvironmentDiffuseScale = 0.6
Lighting.EnvironmentSpecularScale = 1
Lighting.ExposureCompensation = Config.Lighting.Exposure
Lighting.ClockTime = Config.StartClockTime
local atmosphere: Atmosphere = getOrCreate("Atmosphere", "CityHaze", Lighting)
atmosphere.Offset = 0.15
atmosphere.Glare = 0.4
atmosphere.Haze = 2.2
local bloom: BloomEffect = getOrCreate("BloomEffect", "NeonBloom", Lighting)
bloom.Intensity = Config.Lighting.BloomIntensity
bloom.Size = Config.Lighting.BloomSize
bloom.Threshold = Config.Lighting.BloomThreshold
local grade: ColorCorrectionEffect = getOrCreate("ColorCorrectionEffect", "CozyGrade", Lighting)
grade.Saturation = 0.18
grade.Contrast = 0.08
grade.Brightness = 0.02
grade.TintColor = Color3.fromRGB(255, 240, 250)
local secondsPerHour = (Config.DayLengthMinutes * 60) / 24
local accumulator = 0
RunService.Heartbeat:Connect(function(dt)
local clock = Lighting.ClockTime
]=])
S:SetAttribute("CozyNext",8)
print("Project Cozy: part 7/41 done. Paste part 8 next.")
