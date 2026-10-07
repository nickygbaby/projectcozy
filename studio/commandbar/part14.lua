-- PROJECT COZY · PART 14 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=14 then warn("Project Cozy: this is part 14, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("ServerScriptService/Server/Services/DistrictBuilder",[=[
local h = SIDEWALK_Y + rise * i
part( garden, "Step", Vector3.new(2, h, 4), CFrame.new(x0 - 25 + i * 2, h / 2, -19), if i % 2 == 0 then Palette.Concrete else Palette.Violet )
end
part(garden, "Landing", Vector3.new(3, top, 6), CFrame.new(x0 + 0.5, top / 2, -20), Palette.Concrete)
neon( garden, "StairGlow", Vector3.new(26, 0.15, 0.15), CFrame.new(x0 - 12, (SIDEWALK_Y + top) / 2 + 1.2, -17) * CFrame.Angles(0, 0, math.atan2(top - SIDEWALK_Y, 24)), Palette.NeonCyan )
sign( garden, "SKY GARDEN", Vector2.new(9, 2.2), Vector3.new(35, ROOF_Y - 3, -21.6), Vector3.new(0, 0, 1), Palette.NeonLime )
local planters = {}
for row, pz in { -30, -40 } do
local lamp = neon( garden, "GrowLamp", Vector3.new(26, 0.4, 0.8), CFrame.new(35, top + 7, pz), Palette.NeonPurple )
make("SurfaceLight", { Face = Enum.NormalId.Bottom, Color = Palette.NeonPurple, Range = 10, Brightness = LightCfg.GrowLightBrightness, Angle = 120, }, lamp)
lamp:SetAttribute("SoundKey", "GrowLampHum")
lamp:AddTag("AudioEmitter")
for _, lx in { 23, 47 } do
cylinder(garden, "LampPost", 7, 0.4, Vector3.new(lx, top + 3.5, pz), Palette.Ink)
end
for i, px in { 27, 35, 43 } do
local crop = CROPS[i]
local planter = makePlanter( garden, `Planter_{row}_{i}`, CFrame.new(px, top + 0.8, pz), Vector3.new(6, 1.6, 5), crop )
table.insert(planters, planter)
end
end
return planters
end
local function buildApartment(root: Model): Apartment
local home = make("Model", { Name = "Apartment" }, root)
local y0 = HOME_Y
local x0, x1, zFront, zBack = -9, 9, 22, 34
local cz = (zFront + zBack) / 2
local height = 10
part(home, "Floor", Vector3.new(17.6, 0.2, 11.6), CFrame.new(0, y0 + 0.1, cz), Palette.Wood)
part(home, "Ceiling", Vector3.new(18, 0.6, 12), CFrame.new(0, y0 + height + 0.3, cz), Palette.Cream)
part( home, "BackWall", Vector3.new(18, height, 0.6), CFrame.new(0, y0 + height / 2, zBack - 0.3), Palette.Peach )
for _, x in { x0 + 0.3, x1 - 0.3 } do
part( home, "SideWall", Vector3.new(0.6, height, 12), CFrame.new(x, y0 + height / 2, cz), Palette.Peach )
end
part(home, "Roof", Vector3.new(19, 0.6, 13), CFrame.new(0, y0 + height + 0.9, cz), Palette.Concrete)
neon( home, "RoofTrim", Vector3.new(19.1, 0.2, 0.2), CFrame.new(0, y0 + height + 0.6, zFront - 0.5), Palette.NeonPink )
local glassProps = { Material = Enum.Material.Glass, Transparency = 0.7, CastShadow = false }
part( home, "Window", Vector3.new(10, height, 0.3), CFrame.new(-4, y0 + height / 2, zFront), Palette.Sky, glassProps )
part( home, "Window", Vector3.new(4, height, 0.3), CFrame.new(7, y0 + height / 2, zFront), Palette.Sky, glassProps )
part( home, "Transom", Vector3.new(4, 2, 0.3), CFrame.new(3, y0 + height - 1, zFront), Palette.Sky, glassProps )
for _, x in { -9, 1, 5, 9 } do
part( home, "Mullion", Vector3.new(0.4, height, 0.5), CFrame.new(x, y0 + height / 2, zFront), Palette.Cream )
end
part(home, "Sill", Vector3.new(9.4, 0.4, 1.8), CFrame.new(-4, y0 + 3, zFront + 1.1), Palette.Cream)
local strip = neon( home, "GrowStrip", Vector3.new(9, 0.25, 0.4), CFrame.new(-4, y0 + 6.8, zFront + 1.1), Palette.NeonPink )
make("SurfaceLight", { Face = Enum.NormalId.Bottom, Color = Palette.NeonPink, Range = 6, Brightness = LightCfg.GrowLightBrightness, Angle = 100, }, strip)
local planters = {}
local sillCrops = { "Scallion", "Glowshroom", "Scallion", "Glowshroom" }
for i, x in { -7.5, -5.2, -2.9, -0.6 } do
]=])
S:SetAttribute("CozyNext",15)
print("Project Cozy: part 14/41 done. Paste part 15 next.")
