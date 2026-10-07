-- PROJECT COZY · PART 36 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=36 then warn("Project Cozy: this is part 36, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("StarterPlayer/StarterPlayerScripts/Client/Controllers/HudController",[=[
--!strict
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Palette = require(Shared.Palette)
local ItemsModule = require(Shared.Items)
local HudController = {}
local player = Players.LocalPlayer
local TONES = { good = Palette.NeonLime, info = Palette.NeonCyan, nope = Palette.NeonPink, }
local function make(className: string, props: { [string]: any }, parent: Instance?): any
local inst = Instance.new(className :: any)
for key, value in props do
(inst :: any)[key] = value
end
if parent then inst.Parent = parent
end
return inst
end
local function pill( parent: Instance, name: string, size: UDim2, position: UDim2, anchor: Vector2, stroke: Color3 ): Frame
local frame = make("Frame", { Name = name, Size = size, Position = position, AnchorPoint = anchor, BackgroundColor3 = Palette.Ink, BackgroundTransparency = 0.15, }, parent)
make("UICorner", { CornerRadius = UDim.new(1, 0) }, frame)
make("UIStroke", { Color = stroke, Thickness = 2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, frame)
return frame
end
local function text(parent: Instance, value: string, color: Color3, props: { [string]: any }?): TextLabel
local label = make("TextLabel", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Text = value, TextColor3 = color, TextScaled = true, Font = Enum.Font.FredokaOne, }, parent)
if props then for key, v in props do
(label :: any)[key] = v
end
end
return label
end
local function bump(guiObject: GuiObject)
local scale = guiObject:FindFirstChildOfClass("UIScale") or make("UIScale", {}, guiObject)
scale.Scale = 1.18
TweenService
:Create(scale, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })
:Play()
end
function HudController.start()
local gui = make("ScreenGui", { Name = "CozyHud", ResetOnSpawn = false, IgnoreGuiInset = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, }, player:WaitForChild("PlayerGui"))
local credits = pill( gui, "Credits", UDim2.fromOffset(170, 44), UDim2.fromOffset(16, 16), Vector2.zero, Palette.NeonAmber )
make("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14), PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6), }, credits)
local creditsLabel = text(credits, "0 cr", Palette.Cream, { TextXAlignment = Enum.TextXAlignment.Left })
local function refreshCredits()
local value = (player:GetAttribute("Credits") :: number?) or 0
creditsLabel.Text = `◆ {value} cr`
bump(credits)
end
player:GetAttributeChangedSignal("Credits"):Connect(refreshCredits)
refreshCredits()
local clock = pill( gui, "Clock", UDim2.fromOffset(120, 44), UDim2.new(1, -16, 0, 16), Vector2.new(1, 0), Palette.NeonPurple )
make("UIPadding", { PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6) }, clock)
local clockLabel = text(clock, "--:--", Palette.Cream, { Font = Enum.Font.Michroma })
local lastMinute = -1
RunService.Heartbeat:Connect(function()
local t = Lighting.ClockTime
local hours = math.floor(t)
local minutes = math.floor((t - hours) * 60)
if minutes ~= lastMinute then lastMinute = minutes
clockLabel.Text = string.format("%02d:%02d", hours, minutes)
end
end)
]=])
S:SetAttribute("CozyNext",37)
print("Project Cozy: part 36/41 done. Paste part 37 next.")
