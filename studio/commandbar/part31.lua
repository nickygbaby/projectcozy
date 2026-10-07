-- PROJECT COZY · PART 31 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=31 then warn("Project Cozy: this is part 31, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("StarterPlayer/StarterPlayerScripts/Client/Controllers/CameraController",[=[
--!strict
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local Config = require(Shared.Config)
local Zones = require(Shared.Zones)
local CameraController = {}
local cfg = Config.Camera
local player = Players.LocalPlayer
local enabled = true
local atHome = false
local targetYaw = math.rad(cfg.StartYaw)
local currentYaw = targetYaw
local targetDistance = cfg.Distance
local currentDistance = cfg.Distance
local focus: Vector3? = nil
local faded: { [BasePart]: boolean } = {}
local function damp(a: number, b: number, sharpness: number, dt: number): number
return a + (b - a) * (1 - math.exp(-sharpness * dt))
end
local function updateOcclusion(camera: Camera, target: Vector3, character: Model)
local still: { [BasePart]: boolean } = {}
local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Exclude
local ignore: { Instance } = { character }
local origin = camera.CFrame.Position
for _ = 1, 6 do
params.FilterDescendantsInstances = ignore
local result = workspace:Raycast(origin, target - origin, params)
if not result then break
end
local hit = result.Instance
if hit:IsA("BasePart") and hit.Transparency < 1 then still[hit] = true
hit.LocalTransparencyModifier = 0.75
end
table.insert(ignore, hit)
end
for p in faded do
if not still[p] then p.LocalTransparencyModifier = 0
end
end
faded = still
end
local function clearOcclusion()
for p in faded do
p.LocalTransparencyModifier = 0
end
faded = {}
end
function CameraController.start()
local camera = workspace.CurrentCamera
local dof = Instance.new("DepthOfFieldEffect")
dof.Name = "TiltShift"
dof.FarIntensity = 0.2
dof.NearIntensity = 0.25
dof.Parent = camera
local function apply()
if atHome and Config.FirstPersonAtHome then camera.CameraType = Enum.CameraType.Custom
player.CameraMode = Enum.CameraMode.LockFirstPerson
camera.FieldOfView = 70
dof.Enabled = false
clearOcclusion() elseif enabled then player.CameraMode = Enum.CameraMode.Classic
camera.CameraType = Enum.CameraType.Scriptable
camera.FieldOfView = cfg.FieldOfView
dof.Enabled = true
else
player.CameraMode = Enum.CameraMode.Classic
camera.CameraType = Enum.CameraType.Custom
camera.FieldOfView = 70
dof.Enabled = false
clearOcclusion()
end
end
apply()
ContextActionService:BindAction("CozyRotate", function(_, state, input)
if state ~= Enum.UserInputState.Begin then return Enum.ContextActionResult.Pass
end
local dir = if input.KeyCode == Enum.KeyCode.Z or input.KeyCode == Enum.KeyCode.ButtonL1 then -1 else 1
targetYaw += math.rad(cfg.RotateStep) * dir
return Enum.ContextActionResult.Sink
end, false, Enum.KeyCode.Z, Enum.KeyCode.C, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
ContextActionService:BindAction("CozyToggleCamera", function(_, state)
if state == Enum.UserInputState.Begin then enabled = not enabled
apply()
end
return Enum.ContextActionResult.Sink
end, false, Enum.KeyCode.V)
UserInputService.InputChanged:Connect(function(input, processed)
if processed or not enabled then return
end
if input.UserInputType == Enum.UserInputType.MouseWheel then targetDistance = math.clamp(targetDistance - input.Position.Z * 6, cfg.MinDistance, cfg.MaxDistance)
end
end)
]=])
S:SetAttribute("CozyNext",32)
print("Project Cozy: part 31/41 done. Paste part 32 next.")
