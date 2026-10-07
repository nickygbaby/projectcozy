-- PROJECT COZY · PART 23 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=23 then warn("Project Cozy: this is part 23, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("ServerScriptService/Server/Services/StallService",[=[
--!strict
local Players = game:GetService("Players")
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local Config = require(Shared.Config)
local Palette = require(Shared.Palette)
local ItemsModule = require(Shared.Items)
local PlayerData = require(script.Parent.PlayerDataService)
local Notify = require(script.Parent.Notify)
local StallService = {}
local rng = Random.new()
local occupied: { [number]: Model } = {}
local NAMES = { "Kiko", "Zed", "Momo", "Rook", "Lumi", "Taro", "Nyx", "Pip", "Juno", "Hex", "Mochi", "Vee" }
local GREETINGS = { "Long shift. Need noodles.", "Rain's nice tonight, huh?", "My cyberdeck crashed again...", "Smells like home in here.", "Extra glow, please!", "Byte! Hi Byte!", }
local function makePart( parent: Instance, name: string, size: Vector3, cframe: CFrame, color: Color3, material: Enum.Material? ): Part
local p = Instance.new("Part")
p.Name = name
p.Anchored = true
p.CanCollide = false
p.Size = size
p.CFrame = cframe
p.Color = color
p.Material = material or Enum.Material.SmoothPlastic
p.TopSurface = Enum.SurfaceType.Smooth
p.BottomSurface = Enum.SurfaceType.Smooth
p.Parent = parent
return p
end
local function buildCustomer(seat: CFrame): Model
local model = Instance.new("Model")
model.Name = "Customer"
local outfit = Palette.ToySet[rng:NextInteger(1, #Palette.ToySet)]
local glow = Palette.NeonSet[rng:NextInteger(1, #Palette.NeonSet)]
local body = makePart(model, "Body", Vector3.new(1.6, 1.6, 1.6), seat * CFrame.new(0, 0.8, 0), outfit)
body.Shape = Enum.PartType.Ball
model.PrimaryPart = body
local head = makePart(model, "Head", Vector3.new(2.2, 2.2, 2.2), seat * CFrame.new(0, 2.5, 0), Palette.Peach)
head.Shape = Enum.PartType.Ball
makePart( model, "Visor", Vector3.new(1.7, 0.45, 0.4), seat * CFrame.new(0, 2.65, -0.95), glow, Enum.Material.Neon )
makePart(model, "Hair", Vector3.new(2.3, 0.8, 2.3), seat * CFrame.new(0, 3.35, 0.1), outfit)
local antenna = makePart( model, "Antenna", Vector3.new(0.4, 0.4, 0.4), seat * CFrame.new(0.6, 4.1, 0), glow, Enum.Material.Neon )
antenna.Shape = Enum.PartType.Ball
model:SetAttribute("BobAmplitude", 0.08)
model:SetAttribute("BobSpeed", rng:NextNumber(1.6, 2.6))
return model
end
local function orderBubble(model: Model, recipe: ItemsModule.Recipe, name: string)
local gui = Instance.new("BillboardGui")
gui.Name = "Order"
gui.Size = UDim2.fromOffset(150, 64)
gui.StudsOffsetWorldSpace = Vector3.new(0, 4.6, 0)
gui.AlwaysOnTop = true
gui.LightInfluence = 0
gui.MaxDistance = 90
local bubble = Instance.new("Frame")
bubble.Size = UDim2.fromScale(1, 1)
bubble.BackgroundColor3 = Palette.Cream
bubble.Parent = gui
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.5, 0)
corner.Parent = bubble
local stroke = Instance.new("UIStroke")
stroke.Color = Palette.NeonPink
stroke.Thickness = 2
stroke.Parent = bubble
local label = Instance.new("TextLabel")
label.BackgroundTransparency = 1
label.Size = UDim2.fromScale(1, 0.62)
label.Text = `{recipe.Icon} {recipe.Name}`
label.TextColor3 = Palette.Ink
label.TextScaled = true
label.Font = Enum.Font.FredokaOne
label.Parent = bubble
local who = Instance.new("TextLabel")
who.BackgroundTransparency = 1
who.Position = UDim2.fromScale(0, 0.58)
who.Size = UDim2.fromScale(1, 0.34)
who.Text = name
who.TextColor3 = Palette.Brick
who.TextScaled = true
who.Font = Enum.Font.FredokaOne
who.Parent = bubble
]=])
S:SetAttribute("CozyNext",24)
print("Project Cozy: part 23/41 done. Paste part 24 next.")
