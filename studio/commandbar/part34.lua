-- PROJECT COZY · PART 34 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=34 then warn("Project Cozy: this is part 34, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("StarterPlayer/StarterPlayerScripts/Client/Controllers/HomePanels",[=[
local function card( order: number, heading: string, sub: string, detail: string, button: string, ready: boolean, accent: Color3, onClick: () -> () )
local c = make( "Frame", { LayoutOrder = order, Size = UDim2.new(1, -6, 0, 92), BackgroundColor3 = Palette.Indigo }, list )
round(c, 14)
make("UIStroke", { Color = accent, Thickness = 1.5, Transparency = 0.3 }, c)
local function line(y: number, h: number, text: string, color: Color3, font: Enum.Font)
make("TextLabel", { BackgroundTransparency = 1, Position = UDim2.fromOffset(14, y), Size = UDim2.new(1, -140, 0, h), Text = text, TextColor3 = color, Font = font, TextScaled = true, TextXAlignment = Enum.TextXAlignment.Left, }, c)
end
line(8, 24, heading, Palette.Cream, Enum.Font.FredokaOne)
line(34, 16, sub, Palette.Lilac, Enum.Font.FredokaOne)
line(56, 26, detail, accent, Enum.Font.FredokaOne)
local b = make("TextButton", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(108, 40), BackgroundColor3 = if ready then accent else Palette.Violet, AutoButtonColor = ready, Text = button, TextColor3 = if ready then Palette.Ink else Palette.Concrete, Font = Enum.Font.FredokaOne, TextSize = 20, }, c)
round(b, 20)
b.Activated:Connect(function()
local s = make("UIScale", { Scale = 0.85 }, b)
TweenService
:Create(s, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })
:Play()
onClick()
end)
end
local function render()
for _, child in list:GetChildren() do
if child:IsA("Frame") then child:Destroy()
end
end
if mode == "orders" then title.Text = "NEIGHBOR NET"
stroke.Color = Palette.NeonCyan
local friends = decode("Friends")
for i, order in decode("Orders") do
local item = ItemsModule.Items[order.Item]
if item then local have = count(order.Item)
card( i, `{order.Neighbor}  ·  {FLOORS[order.Neighbor] or ""}  {hearts( friends[order.Neighbor] or 0 )}`, BLURBS[order.Neighbor] or "", `{order.Count}x {item.Name}  ({have}/{order.Count})  →  {order.Reward} cr`, "Deliver", have >= order.Count, item.Color, function()
remote:FireServer("deliver", order.Id)
end )
end
end elseif mode == "kitchen" then title.Text = "KITCHENETTE"
stroke.Color = Palette.NeonAmber
for i, recipe in ItemsModule.HomeRecipes do
local makes = ItemsModule.Items[recipe.Makes]
local ready = true
for id, n in recipe.Needs do
if count(id) < n then ready = false
end
end
card( i, `{recipe.Icon} {makes.Name}`, `You have {count(recipe.Makes)}`, ItemsModule.describeNeeds(recipe.Needs), "Make", ready, makes.Color, function()
remote:FireServer("cook", recipe.Id)
end )
end
end
end
local function open(newMode: string, at: BasePart)
mode, anchor = newMode, at
render()
gui.Enabled = true
close.Modal = true -- unlock the first-person mouse
scale.Scale = 0.6
TweenService
:Create( scale, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 } )
:Play()
end
local function hide()
mode, anchor = nil, nil
gui.Enabled = false
close.Modal = false
end
close.Activated:Connect(hide)
local function toggle(newMode: string, at: BasePart)
if mode == newMode then hide()
else
open(newMode, at)
end
end
local function addTarget(inst: Instance)
local detector = inst:FindFirstChildOfClass("ClickDetector")
local panelMode = inst:GetAttribute("Panel")
if inst:IsA("BasePart") and detector and typeof(panelMode) == "string" then detector.MouseClick:Connect(function(who)
]=])
S:SetAttribute("CozyNext",35)
print("Project Cozy: part 34/41 done. Paste part 35 next.")
