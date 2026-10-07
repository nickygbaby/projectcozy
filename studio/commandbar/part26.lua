-- PROJECT COZY · PART 26 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=26 then warn("Project Cozy: this is part 26, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("StarterPlayer/StarterPlayerScripts/Client/Controllers/AmbientController",[=[
--!strict
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Juice = require(Shared.Juice)
local Palette = require(Shared.Palette)
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local AmbientController = {}
type Floater = { base: CFrame, phase: number }
local bobbing: { [Model]: Floater } = {}
local spinning: { [Instance]: CFrame } = {}
local function pivotOf(inst: Instance): CFrame?
if inst:IsA("Model") then return inst:GetPivot() elseif inst:IsA("BasePart") then return inst.CFrame
end
return nil
end
local function setPivot(inst: Instance, cf: CFrame)
if inst:IsA("Model") then inst:PivotTo(cf) elseif inst:IsA("BasePart") then inst.CFrame = cf
end
end
local function onTag(tag: string, added: (Instance) -> (), removed: ((Instance) -> ())?)
for _, inst in CollectionService:GetTagged(tag) do
task.spawn(added, inst)
end
CollectionService:GetInstanceAddedSignal(tag):Connect(added)
if removed then CollectionService:GetInstanceRemovedSignal(tag):Connect(removed)
end
end
local function flickerLoop(inst: Instance)
local rng = Random.new()
while inst.Parent do
task.wait(rng:NextNumber(2, 9))
if not inst.Parent then break
end
for _ = 1, rng:NextInteger(2, 5) do
local on = false
for _, d in inst:GetDescendants() do
if d:IsA("Light") or d:IsA("SurfaceGui") then d.Enabled = on
end
end
if inst:IsA("BasePart") and inst.Material == Enum.Material.Neon then inst.LocalTransparencyModifier = 0.85
end
task.wait(rng:NextNumber(0.03, 0.12))
for _, d in inst:GetDescendants() do
if d:IsA("Light") or d:IsA("SurfaceGui") then d.Enabled = true
end
end
if inst:IsA("BasePart") then inst.LocalTransparencyModifier = 0
end
task.wait(rng:NextNumber(0.04, 0.2))
end
end
end
local function watchPatience(model: Model)
local bar = model:FindFirstChild("Patience", true) :: Frame?
if not bar then return
end
local total = model:GetAttribute("Patience") :: number
local spawnedAt = model:GetAttribute("SpawnedAt") :: number
local fullWidth = bar.Size.X.Scale
local conn: RBXScriptConnection
conn = RunService.Heartbeat:Connect(function()
if not model.Parent or model:GetAttribute("Mood") then conn:Disconnect()
return
end
local left = math.clamp(1 - (workspace:GetServerTimeNow() - spawnedAt) / total, 0, 1)
bar.Size = UDim2.new(fullWidth * left, 0, 0, bar.Size.Y.Offset)
bar.BackgroundColor3 = if left > 0.5 then Palette.NeonLime elseif left > 0.2 then Palette.NeonAmber else Palette.NeonRed
end)
end
local function onCustomer(inst: Instance)
if not inst:IsA("Model") then return
end
local model = inst
Juice.popIn(model)
task.spawn(watchPatience, model)
model:GetAttributeChangedSignal("Mood"):Connect(function()
local mood = model:GetAttribute("Mood")
bobbing[model] = nil
local order = model:FindFirstChild("Order", true)
if order and order:IsA("BillboardGui") then order.Enabled = false
end
if mood == "happy" then Juice.hop(model, 3)
task.delay(0.8, function()
if model.Parent then Juice.popOut(model)
end
end)
else
Juice.popOut(model)
end
end)
end
function AmbientController.start()
onTag("Bob", function(inst)
if inst:IsA("Model") then local base = inst:GetPivot()
bobbing[inst] = { base = base, phase = math.random() * math.pi * 2 }
end
end, function(inst)
if inst:IsA("Model") then bobbing[inst] = nil
]=])
S:SetAttribute("CozyNext",27)
print("Project Cozy: part 26/41 done. Paste part 27 next.")
