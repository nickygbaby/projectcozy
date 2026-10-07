-- PROJECT COZY · PART 41 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=41 then warn("Project Cozy: this is part 41, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("StarterPlayer/StarterPlayerScripts/Client/Controllers/RainController",[=[
--!strict
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local Palette = require(Shared.Palette)
local Zones = require(Shared.Zones)
local RainController = {}
function RainController.start()
local emitterPart = Instance.new("Part")
emitterPart.Name = "RainCloud"
emitterPart.Anchored = true
emitterPart.CanCollide = false
emitterPart.CanQuery = false
emitterPart.CanTouch = false
emitterPart.Transparency = 1
emitterPart.Size = Vector3.new(120, 1, 120)
emitterPart.Parent = workspace
local rain = Instance.new("ParticleEmitter")
rain.Name = "Rain"
rain.EmissionDirection = Enum.NormalId.Bottom
rain.Rate = 600
rain.Lifetime = NumberRange.new(0.9, 1.1)
rain.Speed = NumberRange.new(70, 80)
rain.SpreadAngle = Vector2.new(4, 4)
rain.Size = NumberSequence.new(0.12)
rain.Squash = NumberSequence.new(2.5)
rain.Orientation = Enum.ParticleOrientation.VelocityParallel
rain.Transparency = NumberSequence.new(0.55)
rain.Color = ColorSequence.new(Palette.Sky)
rain.LightEmission = 0.4
rain.LightInfluence = 0.6
rain.Parent = emitterPart
local player = Players.LocalPlayer
RunService.Heartbeat:Connect(function()
local character = player.Character
local root = character and character:FindFirstChild("HumanoidRootPart") :: BasePart?
local center = if root then root.Position else workspace.CurrentCamera.Focus.Position
if Zones.contains("Home", center) then emitterPart.Size = Vector3.new(80, 1, 30)
emitterPart.CFrame = CFrame.new(center.X, center.Y + 40, 6)
else
emitterPart.Size = Vector3.new(120, 1, 120)
emitterPart.CFrame = CFrame.new(center.X, center.Y + 60, center.Z)
end
end)
end
return RainController
]=])
for _,d in S.Server:GetDescendants() do if d:IsA("Script") then d.Disabled=false end end for _,d in game:GetService("StarterPlayer").StarterPlayerScripts.Client:GetDescendants() do if d:IsA("LocalScript") then d.Disabled=false end end
S:SetAttribute("CozyNext",nil)
print("Project Cozy: all 41 parts installed! Press Play.")
