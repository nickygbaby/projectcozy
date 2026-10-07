-- PROJECT COZY · PART 15 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=15 then warn("Project Cozy: this is part 15, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("ServerScriptService/Server/Services/DistrictBuilder",[=[
local pot = makePlanter( home, `Windowsill_{i}`, CFrame.new(x, y0 + 3.85, zFront + 1.1), Vector3.new(1.8, 1.3, 1.5), sillCrops[i], if i % 2 == 0 then Palette.Terracotta else Palette.Mint, 0.35 )
table.insert(planters, pot)
end
local zb = zFront - 2.6
part(home, "BalconyFloor", Vector3.new(14, 0.6, 5.2), CFrame.new(0, y0 - 0.3, zb), Palette.Concrete)
part( home, "BalconyRail", Vector3.new(14, 2.6, 0.2), CFrame.new(0, y0 + 1.3, zFront - 5.1), Palette.Sky, glassProps )
for _, x in { -6.9, 6.9 } do
part( home, "BalconyRail", Vector3.new(0.2, 2.6, 5), CFrame.new(x, y0 + 1.3, zb), Palette.Sky, glassProps )
end
neon( home, "RailGlow", Vector3.new(14, 0.15, 0.15), CFrame.new(0, y0 + 2.65, zFront - 5.1), Palette.NeonCyan )
for i, info in { { -4.2, "EmberChili" }, { 4.2, "Glowshroom" } } do
local box = makePlanter( home, `Balcony_{i}`, CFrame.new(info[1], y0 + 0.6, zb - 0.6), Vector3.new(4, 1.2, 2.4), info[2], Palette.Wood, 0.7 )
table.insert(planters, box)
end
for i = 0, 12 do
local bulb = neon( home, "FairyLight", Vector3.new(0.3, 0.3, 0.3), CFrame.new(-6 + i, y0 + 2.9 - (i % 2) * 0.15, zFront - 5.1), Palette.Butter )
bulb.Shape = Enum.PartType.Ball
end
local balconyLight = make( "PointLight", { Color = Palette.Butter, Range = 10, Brightness = 0.8 }, home:FindFirstChild("RailGlow") )
balconyLight.Name = "FairyGlow"
local lampShade = part( home, "LampShade", Vector3.new(1.8, 1.8, 1.8), CFrame.new(0, y0 + 9, cz + 1), Palette.Butter, { Shape = Enum.PartType.Ball } )
make( "PointLight", { Color = Color3.fromRGB(255, 205, 150), Range = 22, Brightness = 1.3, Shadows = true }, lampShade )
cylinder(home, "Rug", 0.1, 7, Vector3.new(1, y0 + 0.25, cz + 1), Palette.Lilac)
part(home, "Bed", Vector3.new(4.5, 1.4, 7), CFrame.new(6, y0 + 0.9, cz + 2), Palette.Wood)
part(home, "Mattress", Vector3.new(4.3, 0.8, 6.8), CFrame.new(6, y0 + 2, cz + 2), Palette.Cream)
part(home, "Blanket", Vector3.new(4.4, 0.3, 4.2), CFrame.new(6, y0 + 2.5, cz + 0.9), Palette.Coral)
part(home, "Pillow", Vector3.new(3, 0.6, 1.4), CFrame.new(6, y0 + 2.7, cz + 4.6), Palette.Sky)
part(home, "Counter", Vector3.new(6, 3.2, 2.2), CFrame.new(-4.5, y0 + 1.6, zBack - 1.4), Palette.Mint)
local counterTop = part( home, "CounterTop", Vector3.new(6.2, 0.3, 2.4), CFrame.new(-4.5, y0 + 3.35, zBack - 1.4), Palette.Cream )
prompt(counterTop, "Cook", "Kitchenette", { Name = "KitchenPrompt", MaxActivationDistance = 10 })
make("ClickDetector", { MaxActivationDistance = 14 }, counterTop)
counterTop:SetAttribute("Panel", "kitchen")
counterTop:AddTag("HomePanelTarget")
local terminal = part( home, "NeighborNet", Vector3.new(0.3, 2.4, 3.6), CFrame.new(x0 + 0.75, y0 + 4.5, 28.5), Palette.Ink, { CastShadow = false } )
local screen = make("SurfaceGui", { Face = Enum.NormalId.Right, SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud, PixelsPerStud = 50, LightInfluence = 0, Brightness = LightCfg.SignTextBrightness, }, terminal)
make("TextLabel", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Palette.Indigo, Text = "NEIGHBOR NET\n♥ requests ♥", TextColor3 = Palette.NeonCyan, TextScaled = true, Font = Enum.Font.Michroma, }, screen)
make( "SurfaceLight", { Face = Enum.NormalId.Right, Color = Palette.NeonCyan, Range = 6, Brightness = 0.5 }, terminal )
prompt( terminal, "Check requests", "Neighbor Net", { Name = "TerminalPrompt", MaxActivationDistance = 10 } )
]=])
S:SetAttribute("CozyNext",16)
print("Project Cozy: part 15/41 done. Paste part 16 next.")
