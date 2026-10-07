-- PROJECT COZY · PART 13 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=13 then warn("Project Cozy: this is part 13, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("ServerScriptService/Server/Services/DistrictBuilder",[=[
local body = part(cat, "Body", Vector3.new(1.6, 1.2, 2.4), CFrame.new(p + Vector3.new(0, 0.6, 0)), Palette.Lilac)
cat.PrimaryPart = body
part(cat, "Head", Vector3.new(1.6, 1.4, 1.4), CFrame.new(p + Vector3.new(0, 1.5, -1.1)), Palette.Lilac)
for _, side in { -1, 1 } do
part( cat, "Ear", Vector3.new(0.4, 0.6, 0.5), CFrame.new(p + Vector3.new(side * 0.5, 2.45, -1.1)), Palette.Lilac, { Shape = Enum.PartType.Wedge } )
neon( cat, "Eye", Vector3.new(0.3, 0.3, 0.1), CFrame.new(p + Vector3.new(side * 0.35, 1.6, -1.82)), Palette.NeonCyan )
end
part( cat, "Tail", Vector3.new(0.3, 0.3, 1.6), CFrame.new(p + Vector3.new(0, 1.2, 1.6)) * CFrame.Angles(math.rad(35), 0, 0), Palette.Lilac )
neon( cat, "TailTip", Vector3.new(0.4, 0.4, 0.4), CFrame.new(p + Vector3.new(0, 1.75, 2.25)), Palette.NeonPink )
cat:SetAttribute("BobAmplitude", 0.06)
cat:SetAttribute("BobSpeed", 2.2)
cat:AddTag("Bob")
return cat
end
local CROPS = { "Scallion", "Glowshroom", "EmberChili" }
local CROP_COLORS = { Scallion = Palette.NeonLime, Glowshroom = Palette.NeonCyan, EmberChili = Palette.NeonRed }
local function makePlanter( parent: Instance, name: string, boxCFrame: CFrame, boxSize: Vector3, crop: string, color: Color3?, plantScale: number? ): Model
local planter = make("Model", { Name = name }, parent)
local box = part(planter, "Box", boxSize, boxCFrame, color or Palette.Wood)
local soil = part( planter, "Soil", Vector3.new(boxSize.X - 0.8, 0.3, boxSize.Z - 0.8), boxCFrame * CFrame.new(0, boxSize.Y / 2 + 0.05, 0), Palette.SoilDry, { Material = Enum.Material.Ground } )
planter.PrimaryPart = box
local corner = boxCFrame * CFrame.new(boxSize.X / 2 - 0.4, 0, -boxSize.Z / 2 + 0.4)
local stakeHeight = math.max(1, boxSize.Y)
cylinder( planter, "Stake", stakeHeight, 0.15, (corner * CFrame.new(0, boxSize.Y / 2 + stakeHeight / 2, 0)).Position, Palette.Cream )
neon( planter, "Marker", Vector3.new(0.5, 0.5, 0.5), corner * CFrame.new(0, boxSize.Y / 2 + stakeHeight + 0.2, 0), CROP_COLORS[crop] )
planter:SetAttribute("Crop", crop)
planter:SetAttribute("Stage", 0)
planter:SetAttribute("Thirsty", false)
planter:SetAttribute("PlantScale", plantScale or 1)
planter:AddTag("Planter")
prompt(soil, "Plant", crop, { Name = "GardenPrompt" })
return planter
end
local function buildGarden(root: Model): { Model }
local garden = make("Model", { Name = "RooftopGarden" }, root)
local x0, x1, z0, z1 = 20, 50, -50, -22
part( garden, "Body", Vector3.new(x1 - x0, ROOF_Y, z1 - z0), CFrame.new((x0 + x1) / 2, ROOF_Y / 2, (z0 + z1) / 2), Palette.Brick )
part( garden, "Roof", Vector3.new(x1 - x0, 0.4, z1 - z0), CFrame.new((x0 + x1) / 2, ROOF_Y + 0.2, (z0 + z1) / 2), Palette.Concrete )
local top = ROOF_Y + 0.4
part( garden, "Parapet", Vector3.new(x1 - x0, 1.2, 0.6), CFrame.new((x0 + x1) / 2, top + 0.6, z0 + 0.3), Palette.Cream )
part( garden, "Parapet", Vector3.new(x1 - x0 - 6, 1.2, 0.6), CFrame.new((x0 + x1) / 2 + 3, top + 0.6, z1 - 0.3), Palette.Cream )
part( garden, "Parapet", Vector3.new(0.6, 1.2, z1 - z0), CFrame.new(x1 - 0.3, top + 0.6, (z0 + z1) / 2), Palette.Cream )
part( garden, "Parapet", Vector3.new(0.6, 1.2, z1 - z0 - 6), CFrame.new(x0 + 0.3, top + 0.6, (z0 + z1) / 2 - 3), Palette.Cream )
neon( garden, "ParapetGlow", Vector3.new(x1 - x0, 0.15, 0.15), CFrame.new((x0 + x1) / 2, top + 1.25, z0 + 0.3), Palette.NeonLime )
local steps = 12
local rise = (top - SIDEWALK_Y) / steps
for i = 1, steps do
]=])
S:SetAttribute("CozyNext",14)
print("Project Cozy: part 13/41 done. Paste part 14 next.")
