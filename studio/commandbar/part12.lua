-- PROJECT COZY · PART 12 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=12 then warn("Project Cozy: this is part 12, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("ServerScriptService/Server/Services/DistrictBuilder",[=[
neon(stall, "MenuStrip", Vector3.new(10, 0.25, 0.1), CFrame.new(0, base + 6.5, 20.85), Palette.NeonCyan)
for _, px in { -7, 7 } do
cylinder(stall, "Post", 8.4, 0.6, Vector3.new(px, base + 4.2, 15.6), Palette.Wood)
end
local slats = 7
for i = 0, slats - 1 do
local sx = -7 + 1 + i * 2
local color = if i % 2 == 0 then Palette.Coral else Palette.Cream
part( stall, "Awning", Vector3.new(2, 0.35, 7), CFrame.new(sx, base + 9, 18) * CFrame.Angles(math.rad(-14), 0, 0), color, { CastShadow = true } )
end
for i = 0, 13 do
local bx = -6.5 + i
part( stall, "AwningEdge", Vector3.new(0.9, 0.9, 0.9), CFrame.new(bx, base + 7.75, 14.6), if i % 2 == 0 then Palette.Coral else Palette.Cream, { Shape = Enum.PartType.Ball, CastShadow = false } )
end
for _, lx in { -5.5, -1.8, 1.8, 5.5 } do
local lantern = make("Model", { Name = "StallLantern" }, stall)
local glow = neon( lantern, "Glow", Vector3.new(1.2, 1.2, 1.2), CFrame.new(lx, base + 6.4, 15.4), Palette.NeonRed, 10 )
glow.Shape = Enum.PartType.Ball
lantern.PrimaryPart = glow
lantern:SetAttribute("BobAmplitude", 0.12)
lantern:SetAttribute("BobSpeed", 1.8)
lantern:AddTag("Bob")
end
sign( stall, "LUCKY BYTE NOODLES", Vector2.new(13, 2.4), Vector3.new(0, base + 11.6, 17.6), Vector3.new(0, 0, -1), Palette.NeonPink )
local pot = cylinder(stall, "Pot", 1.6, 2.2, Vector3.new(3.5, base + 4.6, 18.4), Palette.Concrete)
local steamAt = make("Attachment", { Name = "Steam", Position = Vector3.new(0.9, 0, 0) }, pot)
make("ParticleEmitter", { Rate = 6, Lifetime = NumberRange.new(2, 3), Speed = NumberRange.new(1.5, 2.5), SpreadAngle = Vector2.new(12, 12), Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.6), NumberSequenceKeypoint.new(1, 2.2) }), Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.2, 0.6), NumberSequenceKeypoint.new(1, 1), }), Color = ColorSequence.new(Palette.Cream), LightInfluence = 0.3, Drag = 0.6, Acceleration = Vector3.new(0, 1, 0), EmissionDirection = Enum.NormalId.Right, }, steamAt)
make("PointLight", { Color = Palette.NeonAmber, Range = 8, Brightness = 1 }, pot)
local spots = {}
for _, sx in { -4.5, 0, 4.5 } do
cylinder(stall, "StoolLeg", 2, 0.4, Vector3.new(sx, base + 1, 14.6), Palette.Ink)
cylinder(stall, "StoolSeat", 0.4, 1.8, Vector3.new(sx, base + 2.1, 14.6), Palette.Peach)
local at = Vector3.new(sx, base + 2.3, 14.6)
table.insert(spots, CFrame.lookAt(at, at + Vector3.new(0, 0, 1)))
end
return pot, spots
end
local function buildVending(root: Model): BasePart
local model = make("Model", { Name = "NoodleVending" }, root)
local body = part(model, "Body", Vector3.new(4, 7, 2.6), CFrame.new(-14, SIDEWALK_Y + 3.5, 20.4), Palette.Indigo)
model.PrimaryPart = body
local panel = sign( model, "NOODLE\nBRICKS", Vector2.new(3.2, 3.2), Vector3.new(-14, SIDEWALK_Y + 4.6, 19.05), Vector3.new(0, 0, -1), Palette.NeonCyan )
panel.Name = "Panel"
neon( model, "Slot", Vector3.new(2.4, 0.5, 0.2), CFrame.new(-14, SIDEWALK_Y + 1.6, 19.05), Palette.NeonLime )
local coin = neon( model, "HoloCoin", Vector3.new(0.3, 2, 2), CFrame.new(-14, SIDEWALK_Y + 8.6, 20.4), Palette.NeonAmber, 6 )
coin.Shape = Enum.PartType.Cylinder
coin.Transparency = 0.3
coin:AddTag("Spin")
return body
end
local function buildRoboCat(root: Model): Model
local cat = make("Model", { Name = "Byte" }, root)
local p = Vector3.new(-9, SIDEWALK_Y, 14)
]=])
S:SetAttribute("CozyNext",13)
print("Project Cozy: part 12/41 done. Paste part 13 next.")
