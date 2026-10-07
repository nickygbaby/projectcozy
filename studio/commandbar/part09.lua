-- PROJECT COZY · PART 9 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=9 then warn("Project Cozy: this is part 9, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("ServerScriptService/Server/Services/DistrictBuilder",[=[
--!strict
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local Palette = require(Shared.Palette)
local LightCfg = require(Shared.Config).Lighting
export type District = { Root: Model, CustomerSpots: { CFrame }, StallPot: BasePart, Vending: BasePart, Planters: { Model }, RoboCat: Model, Elevators: { Up: BasePart, Down: BasePart, HomeArrival: CFrame, StreetArrival: CFrame }, Terminal: BasePart, Kitchen: BasePart, }
type Apartment = { Planters: { Model }, Down: BasePart, HomeArrival: CFrame, Terminal: BasePart, Kitchen: BasePart, }
local SIDEWALK_Y = 0.6
local ROOF_Y = 10
local HOME_Y = 48 -- apartment floor height
local rng = Random.new(2077)
local function make(className: string, props: { [string]: any }, parent: Instance?): any
local inst = Instance.new(className :: any)
for key, value in props do
(inst :: any)[key] = value
end
if parent then inst.Parent = parent
end
return inst
end
local function part( parent: Instance, name: string, size: Vector3, cframe: CFrame, color: Color3, props: { [string]: any }? ): Part
local p = make("Part", { Name = name, Anchored = true, Size = size, CFrame = cframe, Color = color, Material = Enum.Material.SmoothPlastic, TopSurface = Enum.SurfaceType.Smooth, BottomSurface = Enum.SurfaceType.Smooth, })
if props then for key, value in props do
(p :: any)[key] = value
end
end
p.Parent = parent
return p
end
local function neon( parent: Instance, name: string, size: Vector3, cframe: CFrame, color: Color3, light: number? ): Part
local p = part( parent, name, size, cframe, color, { Material = Enum.Material.Neon, CastShadow = false, Transparency = LightCfg.NeonTransparency } )
if light then make( "PointLight", { Color = color, Range = light, Brightness = LightCfg.NeonLightBrightness, Shadows = false }, p )
end
return p
end
local UPRIGHT = CFrame.Angles(0, 0, math.rad(90))
local function cylinder( parent: Instance, name: string, height: number, diameter: number, position: Vector3, color: Color3, props: { [string]: any }? ): Part
local merged: { [string]: any } = { Shape = Enum.PartType.Cylinder }
if props then for key, value in props do
merged[key] = value
end
end
return part( parent, name, Vector3.new(height, diameter, diameter), CFrame.new(position) * UPRIGHT, color, merged )
end
local function prompt( parent: Instance, action: string, object: string, props: { [string]: any }? ): ProximityPrompt
local pp = make("ProximityPrompt", { ActionText = action, ObjectText = object, HoldDuration = 0, MaxActivationDistance = 10, RequiresLineOfSight = false, })
if props then for key, value in props do
(pp :: any)[key] = value
end
end
pp.Parent = parent
return pp
end
local function sign( parent: Instance, text: string, size: Vector2, position: Vector3, facing: Vector3, color: Color3, flicker: boolean? ): Part
local cf = CFrame.lookAt(position, position + facing)
local board = part(parent, "Sign", Vector3.new(size.X, size.Y, 0.4), cf, Palette.Ink, { CastShadow = false })
local gui = make("SurfaceGui", { Face = Enum.NormalId.Front, SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud, PixelsPerStud = 40, LightInfluence = 0, Brightness = LightCfg.SignTextBrightness, }, board)
local label = make("TextLabel", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = text, TextColor3 = color, TextScaled = true, Font = Enum.Font.Michroma, }, gui)
]=])
S:SetAttribute("CozyNext",10)
print("Project Cozy: part 9/41 done. Paste part 10 next.")
