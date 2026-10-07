-- PROJECT COZY · PART 37 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=37 then warn("Project Cozy: this is part 37, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("StarterPlayer/StarterPlayerScripts/Client/Controllers/HudController",[=[
local bar = make("Frame", { Name = "Inventory", AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -16), Size = UDim2.fromOffset(0, 46), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, }, gui)
make("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, }, bar)
for order, id in ItemsModule.ItemOrder do
local item = ItemsModule.Items[id]
local chip = pill(bar, id, UDim2.fromOffset(150, 46), UDim2.new(), Vector2.zero, item.Color)
chip.LayoutOrder = order
local dot = make("Frame", { Size = UDim2.fromOffset(18, 18), Position = UDim2.new(0, 14, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = item.Color, }, chip)
make("UICorner", { CornerRadius = UDim.new(1, 0) }, dot)
local label = text(chip, "", Palette.Cream, { Size = UDim2.new(1, -44, 0.62, 0), Position = UDim2.new(0, 38, 0.19, 0), TextXAlignment = Enum.TextXAlignment.Left, })
local attr = `Inv_{id}`
local function refresh()
local count = (player:GetAttribute(attr) :: number?) or 0
label.Text = `{item.Name}  {count}`
chip.BackgroundTransparency = if count > 0 then 0.15 else 0.5
chip.Visible = not item.Jar or count > 0
bump(chip)
end
player:GetAttributeChangedSignal(attr):Connect(refresh)
refresh()
end
local hint = text(gui, "Z / C rotate  ·  wheel zoom  ·  V camera", Palette.Lilac, { Size = UDim2.fromOffset(420, 22), AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -70), TextTransparency = 0.2, })
task.delay(12, function()
TweenService:Create(hint, TweenInfo.new(2), { TextTransparency = 1 }):Play()
end)
local toasts = make("Frame", { Name = "Toasts", AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 16), Size = UDim2.fromOffset(520, 200), BackgroundTransparency = 1, }, gui)
make("UIListLayout", { HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, }, toasts)
local toastCount = 0
local toastRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Toast") :: RemoteEvent
toastRemote.OnClientEvent:Connect(function(message: string, tone: string)
toastCount += 1
local color = TONES[tone] or Palette.NeonCyan
local toast = pill(toasts, "Toast", UDim2.fromOffset(0, 38), UDim2.new(), Vector2.zero, color)
toast.AutomaticSize = Enum.AutomaticSize.X
toast.LayoutOrder = toastCount
make("UIPadding", { PaddingLeft = UDim.new(0, 18), PaddingRight = UDim.new(0, 18) }, toast)
local label = text(toast, message, Palette.Cream, { Size = UDim2.fromScale(0, 1), AutomaticSize = Enum.AutomaticSize.X, TextScaled = false, TextSize = 20, })
local scale = make("UIScale", { Scale = 0.2 }, toast)
TweenService
:Create(scale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })
:Play()
local children = {}
for _, child in toasts:GetChildren() do
if child:IsA("Frame") then table.insert(children, child)
end
end
if #children > 3 then table.sort(children, function(a, b)
return a.LayoutOrder < b.LayoutOrder
end)
children[1]:Destroy()
end
task.delay(3.2, function()
if not toast.Parent then return
end
local out = TweenService:Create( scale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Scale = 0 } )
TweenService:Create(label, TweenInfo.new(0.25), { TextTransparency = 1 }):Play()
out:Play()
]=])
S:SetAttribute("CozyNext",38)
print("Project Cozy: part 37/41 done. Paste part 38 next.")
