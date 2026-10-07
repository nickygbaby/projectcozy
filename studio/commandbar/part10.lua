-- PROJECT COZY · PART 10 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=10 then warn("Project Cozy: this is part 10, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("ServerScriptService/Server/Services/DistrictBuilder",[=[
make("UIStroke", { Color = color, Thickness = 1.5, Transparency = 0.65 }, label)
make("UIPadding", { PaddingTop = UDim.new(0.12, 0), PaddingBottom = UDim.new(0.12, 0), PaddingLeft = UDim.new(0.06, 0), PaddingRight = UDim.new(0.06, 0), }, label)
local t = 0.25
neon(board, "FrameTop", Vector3.new(size.X + t, t, t), cf * CFrame.new(0, size.Y / 2, -0.2), color)
neon(board, "FrameBottom", Vector3.new(size.X + t, t, t), cf * CFrame.new(0, -size.Y / 2, -0.2), color)
make("SurfaceLight", { Face = Enum.NormalId.Front, Color = color, Range = LightCfg.SignLightRange, Brightness = LightCfg.SignLightBrightness, Angle = 70, }, board)
if flicker then board:AddTag("NeonFlicker")
end
return board
end
local function buildGround(root: Model)
local ground = make("Folder", { Name = "Ground" }, root)
part(ground, "Underlay", Vector3.new(400, 1, 400), CFrame.new(0, -0.5, 0), Palette.Ink)
part( ground, "Street", Vector3.new(140, 0.2, 24), CFrame.new(0, 0.1, 0), Palette.Asphalt, { Reflectance = 0.12 } )
for x = -60, 60, 12 do
neon(ground, "LaneDash", Vector3.new(5, 0.05, 0.4), CFrame.new(x, 0.22, 0), Palette.NeonAmber)
end
part( ground, "SidewalkNorth", Vector3.new(140, SIDEWALK_Y, 10), CFrame.new(0, SIDEWALK_Y / 2, 17), Palette.Concrete )
part( ground, "SidewalkSouth", Vector3.new(140, SIDEWALK_Y, 10), CFrame.new(0, SIDEWALK_Y / 2, -17), Palette.Concrete )
neon( ground, "CurbGlowNorth", Vector3.new(140, 0.15, 0.15), CFrame.new(0, SIDEWALK_Y, 12), Palette.NeonCyan )
neon( ground, "CurbGlowSouth", Vector3.new(140, 0.15, 0.15), CFrame.new(0, SIDEWALK_Y, -12), Palette.NeonPink )
for _ = 1, 9 do
local d = rng:NextNumber(3, 7)
cylinder( ground, "Puddle", 0.05, d, Vector3.new(rng:NextNumber(-60, 60), 0.23, rng:NextNumber(-9, 9)), Palette.Violet, { Material = Enum.Material.Glass, Reflectance = 0.35, Transparency = 0.3, CanCollide = false } )
end
for _, x in { -71, 71 } do
part( ground, "Boundary", Vector3.new(2, 40, 120), CFrame.new(x, 20, 0), Palette.Ink, { Transparency = 1 } )
for z = -10, 10, 5 do
cylinder(ground, "Bollard", 2.4, 0.8, Vector3.new(x * 0.98, 1.2, z), Palette.Concrete)
neon( ground, "BollardCap", Vector3.new(0.9, 0.3, 0.9), CFrame.new(x * 0.98, 2.5, z), Palette.NeonAmber )
end
end
make("SpawnLocation", { Name = "Spawn", Anchored = true, Neutral = true, Size = Vector3.new(6, 0.2, 6), CFrame = CFrame.new(-30, 0.3, 0), Color = Palette.Violet, Material = Enum.Material.SmoothPlastic, TopSurface = Enum.SurfaceType.Smooth, Duration = 0, }, ground)
end
local SIGN_WORDS = { "SYNTH", "24/7", "CHROME", "KARAOKE", "PIXEL BAR", "SOBA", "REPAIR", "★ COZY ★", "LOFI", "TEA" }
local function building(parent: Instance, x0: number, x1: number, zNear: number, zFar: number, height: number)
local model = make("Model", { Name = "Building" }, parent)
local width = x1 - x0
local depth = math.abs(zFar - zNear)
local cx = (x0 + x1) / 2
local cz = (zNear + zFar) / 2
local facing = if zNear > 0 then Vector3.new(0, 0, -1) else Vector3.new(0, 0, 1)
local tones = { Palette.Concrete, Palette.Brick, Palette.Violet, Palette.Indigo }
local body = part( model, "Body", Vector3.new(width, height, depth), CFrame.new(cx, height / 2, cz), tones[rng:NextInteger(1, #tones)] )
model.PrimaryPart = body
part( model, "RoofLip", Vector3.new(width + 1, 1, depth + 1), CFrame.new(cx, height + 0.5, cz), Palette.Concrete )
]=])
S:SetAttribute("CozyNext",11)
print("Project Cozy: part 10/41 done. Paste part 11 next.")
