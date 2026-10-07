-- PROJECT COZY · PART 40 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=40 then warn("Project Cozy: this is part 40, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("StarterPlayer/StarterPlayerScripts/Client/Controllers/PlantVisuals",[=[
light.Color = ItemsModule.Items[crop].Color
light.Range = 6
light.Brightness = 1.2
light.Name = "RipeGlow"
light.Parent = soil
end
plants.WorldPivot = top
if scale ~= 1 then plants:ScaleTo(scale)
end
plants.Parent = planter
Juice.popIn(plants)
end
local WET = Palette.Soil
local DRY = Palette.SoilDry
local function renderMoisture(planter: Model)
local soil = planter:FindFirstChild("Soil") :: BasePart?
if not soil then return
end
local stage = (planter:GetAttribute("Stage") :: number?) or 0
local thirsty = planter:GetAttribute("Thirsty") == true
local wet = not thirsty
TweenService:Create(soil, TweenInfo.new(if wet then 0.6 else 2.5), { Color = if wet then WET else DRY })
:Play()
local drop = soil:FindFirstChild("ThirstyDrop") :: BillboardGui?
if thirsty and stage > 0 then if not drop then local gui = Instance.new("BillboardGui")
gui.Name = "ThirstyDrop"
gui.Size = UDim2.fromOffset(36, 36)
gui.StudsOffsetWorldSpace = Vector3.new(0, 2.2, 0)
gui.AlwaysOnTop = true
gui.LightInfluence = 0
gui.MaxDistance = 60
local label = Instance.new("TextLabel")
label.BackgroundTransparency = 1
label.Size = UDim2.fromScale(1, 1)
label.Text = "💧"
label.TextScaled = true
label.Parent = gui
gui.Parent = soil
task.spawn(function()
local t = 0
while gui.Parent do
t += task.wait()
gui.StudsOffsetWorldSpace = Vector3.new(0, 2.2 + math.sin(t * 3) * 0.2, 0)
end
end)
end elseif drop then drop:Destroy()
end
end
function PlantVisuals.start()
local function track(inst: Instance)
if not inst:IsA("Model") then return
end
render(inst)
renderMoisture(inst)
inst:GetAttributeChangedSignal("Stage"):Connect(function()
render(inst)
end)
inst:GetAttributeChangedSignal("Thirsty"):Connect(function()
renderMoisture(inst)
end)
end
for _, inst in CollectionService:GetTagged("Planter") do
task.spawn(track, inst)
end
CollectionService:GetInstanceAddedSignal("Planter"):Connect(track)
end
return PlantVisuals
]=])
S:SetAttribute("CozyNext",41)
print("Project Cozy: part 40/41 done. Paste part 41 next.")
