-- PROJECT COZY · PART 39 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=39 then warn("Project Cozy: this is part 39, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("StarterPlayer/StarterPlayerScripts/Client/Controllers/PlantVisuals",[=[
--!strict
local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local Juice = require(Shared.Juice)
local Palette = require(Shared.Palette)
local ItemsModule = require(Shared.Items)
local PlantVisuals = {}
local function bit( parent: Instance, size: Vector3, cf: CFrame, color: Color3, shape: Enum.PartType?, glow: boolean? ): Part
local p = Instance.new("Part")
p.Anchored = true
p.CanCollide = false
p.CanQuery = false
p.CastShadow = false
p.Size = size
p.CFrame = cf
p.Color = color
p.Material = if glow then Enum.Material.Neon else Enum.Material.SmoothPlastic
p.Shape = shape or Enum.PartType.Block
p.Parent = parent
return p
end
local function sprout(model: Model, origin: CFrame, crop: string, stage: number, rng: Random)
local fruit = ItemsModule.Items[crop].Color
local tilt = CFrame.Angles( rng:NextNumber(-0.15, 0.15), rng:NextNumber(0, math.pi * 2), rng:NextNumber(-0.15, 0.15) )
local base = origin * tilt
if stage == 1 then bit(model, Vector3.new(0.5, 0.5, 0.5), base * CFrame.new(0, 0.2, 0), Palette.Leaf, Enum.PartType.Ball)
return
end
local height = if stage == 2 then 1.2 else 1.8
bit(model, Vector3.new(0.25, height, 0.25), base * CFrame.new(0, height / 2, 0), Palette.Leaf)
for i = 0, 2 do
local a = i * math.pi * 2 / 3
bit( model, Vector3.new(0.9, 0.12, 0.45), base * CFrame.new(0, height * 0.55, 0) * CFrame.Angles(0, a, math.rad(25)) * CFrame.new(0.45, 0, 0), Palette.Leaf )
end
if stage >= 3 then if crop == "Glowshroom" then bit(model, Vector3.new(0.3, 0.6, 0.3), base * CFrame.new(0, height + 0.2, 0), Palette.Cream)
local cap = bit( model, Vector3.new(0.6, 1.3, 1.3), base * CFrame.new(0, height + 0.55, 0) * CFrame.Angles(0, 0, math.rad(90)), fruit, Enum.PartType.Cylinder, true )
cap.Transparency = 0.1 elseif crop == "EmberChili" then for _, side in { -1, 1 } do
bit( model, Vector3.new(0.3, 0.8, 0.3), base * CFrame.new(side * 0.35, height * 0.6, 0) * CFrame.Angles(0, 0, side * 0.3), fruit, nil, true )
end else -- Scallion: glowing stalk tips
bit( model, Vector3.new(0.35, 0.35, 0.35), base * CFrame.new(0, height + 0.1, 0), fruit, Enum.PartType.Ball, true )
end
end
end
local function render(planter: Model)
local old = planter:FindFirstChild("Plants")
if old then old:Destroy()
end
local soil = planter:FindFirstChild("Soil") :: BasePart?
if not soil then return
end
local oldGlow = soil:FindFirstChild("RipeGlow")
if oldGlow then oldGlow:Destroy()
end
local stage = (planter:GetAttribute("Stage") :: number?) or 0
if stage <= 0 then return
end
local crop = planter:GetAttribute("Crop") :: string
local plants = Instance.new("Model")
plants.Name = "Plants"
local rng = Random.new(#planter.Name * 7919 + math.floor(soil.Position.X * 13 + soil.Position.Z))
local top = soil.CFrame * CFrame.new(0, soil.Size.Y / 2, 0)
local spread = math.min(soil.Size.X / 5.2, soil.Size.Z / 4.2)
local scale = (planter:GetAttribute("PlantScale") :: number?) or 1
local positions = if spread < 0.35 then { Vector3.zero } else nil
for _, offset in
positions or { Vector3.new(-1.4, 0, -1), Vector3.new(1.3, 0, -0.9), Vector3.new(-1.2, 0, 1.1), Vector3.new(1.4, 0, 1), Vector3.new(0, 0, 0), }
do
sprout(plants, top * CFrame.new(offset * spread), crop, stage, rng)
end
if stage >= 3 then local light = Instance.new("PointLight")
]=])
S:SetAttribute("CozyNext",40)
print("Project Cozy: part 39/41 done. Paste part 40 next.")
