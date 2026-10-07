-- PROJECT COZY · PART 11 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=11 then warn("Project Cozy: this is part 11, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("ServerScriptService/Server/Services/DistrictBuilder",[=[
neon( model, "RoofTrim", Vector3.new(width + 1.1, 0.2, 0.2), CFrame.new(cx, height + 0.1, zNear + facing.Z * 0.6), Palette.NeonSet[rng:NextInteger(1, #Palette.NeonSet)] )
local facadeZ = zNear + facing.Z * 0.15
for y = 4, height - 3, 4.5 do
for x = x0 + 2.5, x1 - 2.5, 4 do
local roll = rng:NextNumber()
if roll < 0.62 then local color = if roll < 0.08 then Palette.NeonPink elseif roll < 0.14 then Palette.NeonCyan else Palette.Butter
local lit = neon(model, "Window", Vector3.new(2.2, 2.8, 0.3), CFrame.new(x, y, facadeZ), color)
lit.Transparency = LightCfg.WindowGlowTransparency
lit:SetAttribute("Lit", true)
else
part( model, "Window", Vector3.new(2.2, 2.8, 0.3), CFrame.new(x, y, facadeZ), Palette.Ink, { Reflectance = 0.25 } )
end
part( model, "Sill", Vector3.new(2.6, 0.3, 0.6), CFrame.new(x, y - 1.55, facadeZ + facing.Z * 0.3), Palette.Cream )
end
end
if width >= 10 and rng:NextNumber() < 0.75 then local word = SIGN_WORDS[rng:NextInteger(1, #SIGN_WORDS)]
sign( model, word, Vector2.new(math.min(width - 3, 10), 2.6), Vector3.new(cx, rng:NextNumber(6, math.max(7, height - 4)), zNear + facing.Z * 0.4), facing, Palette.NeonSet[rng:NextInteger(1, #Palette.NeonSet)], rng:NextNumber() < 0.5 )
end
return model
end
local function buildSkyline(root: Model)
local folder = make("Folder", { Name = "Buildings" }, root)
local x = -70
while x < 70 do
local w = rng:NextInteger(10, 18)
local x1 = math.min(x + w, 70)
if x >= -9 and x < 9 then building(folder, -9, 9, 22, 34, HOME_Y - 1)
x = 9
else
if x < -9 and x1 > -9 then x1 = -9
end
building(folder, x, x1, 22, 50, rng:NextInteger(18, 40))
x = x1
end
end
x = -70
while x < 70 do
local w = rng:NextInteger(10, 18)
local x1 = math.min(x + w, 70)
if x >= 20 and x < 50 then x = 50
else
if x1 > 20 and x < 20 then x1 = 20
end
building(folder, x, x1, -22, -50, rng:NextInteger(12, 20))
x = x1
end
end
for _ = 1, 10 do
local tx = rng:NextNumber(-120, 120)
local tz = if rng:NextNumber() < 0.5 then rng:NextNumber(70, 140) else rng:NextNumber(-140, -70)
local h = rng:NextNumber(60, 140)
part( folder, "Tower", Vector3.new(rng:NextNumber(14, 26), h, rng:NextNumber(14, 26)), CFrame.new(tx, h / 2, tz), Palette.Indigo )
neon(folder, "TowerBeacon", Vector3.new(1, 1, 1), CFrame.new(tx, h + 0.5, tz), Palette.NeonRed):AddTag( "NeonFlicker" )
end
for _, lx in { -40, -20, 22, 46 } do
part( folder, "LanternWire", Vector3.new(0.1, 0.1, 44), CFrame.new(lx, 15, 0), Palette.Ink, { CanCollide = false, CastShadow = false } )
for lz = -16, 16, 8 do
local color = if (lz // 8) % 2 == 0 then Palette.NeonPink else Palette.NeonAmber
local lantern = make("Model", { Name = "Lantern" }, folder)
local ball = neon(lantern, "Glow", Vector3.new(1.6, 1.6, 1.6), CFrame.new(lx, 14, lz), color, 12)
ball.Shape = Enum.PartType.Ball
lantern.PrimaryPart = ball
lantern:SetAttribute("BobAmplitude", 0.15)
lantern:SetAttribute("BobSpeed", 1.4)
lantern:AddTag("Bob")
end
end
end
local function buildStall(root: Model): (BasePart, { CFrame })
local stall = make("Model", { Name = "LuckyByteNoodles" }, root)
local base = SIDEWALK_Y
local counter = part(stall, "Counter", Vector3.new(14, 3.4, 3), CFrame.new(0, base + 1.7, 18), Palette.Wood)
stall.PrimaryPart = counter
part(stall, "CounterTop", Vector3.new(14.6, 0.4, 3.6), CFrame.new(0, base + 3.6, 17.9), Palette.Cream)
part(stall, "BackWall", Vector3.new(15, 9, 1), CFrame.new(0, base + 4.5, 21.4), Palette.Coral)
]=])
S:SetAttribute("CozyNext",12)
print("Project Cozy: part 11/41 done. Paste part 12 next.")
