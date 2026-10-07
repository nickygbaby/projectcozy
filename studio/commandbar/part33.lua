-- PROJECT COZY · PART 33 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=33 then warn("Project Cozy: this is part 33, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("StarterPlayer/StarterPlayerScripts/Client/Controllers/HomePanels",[=[
--!strict
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Palette = require(Shared.Palette)
local ItemsModule = require(Shared.Items)
local Neighbors = require(Shared.Neighbors)
local HomePanels = {}
local player = Players.LocalPlayer
local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("HomeAction") :: RemoteEvent
local function make(className: string, props: { [string]: any }, parent: Instance?): any
local inst = Instance.new(className :: any)
for key, value in props do
(inst :: any)[key] = value
end
if parent then inst.Parent = parent
end
return inst
end
local function round(inst: Instance, radius: number)
make("UICorner", { CornerRadius = UDim.new(0, radius) }, inst)
end
local function count(id: string): number
return (player:GetAttribute(`Inv_{id}`) :: number?) or 0
end
local function decode(attr: string): any
local raw = player:GetAttribute(attr)
if typeof(raw) ~= "string" then return {}
end
local ok, value = pcall(HttpService.JSONDecode, HttpService, raw)
return if ok then value else {}
end
local function hearts(n: number): string
local shown = math.min(n, 5)
return string.rep("♥", shown) .. string.rep("♡", 5 - shown) .. (if n > 5 then ` +{n - 5}` else "")
end
local BLURBS: { [string]: string } = {}
local FLOORS: { [string]: string } = {}
for _, n in Neighbors do
BLURBS[n.Name] = n.Blurb
FLOORS[n.Name] = n.Floor
end
function HomePanels.start()
local gui = make( "ScreenGui", { Name = "HomePanels", ResetOnSpawn = false, Enabled = false }, player:WaitForChild("PlayerGui") )
local panel = make("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(460, 400), BackgroundColor3 = Palette.Ink, BackgroundTransparency = 0.05, }, gui)
round(panel, 22)
local stroke = make("UIStroke", { Thickness = 2, Color = Palette.NeonCyan }, panel)
local scale = make("UIScale", { Scale = 1 }, panel)
make("UISizeConstraint", { MaxSize = Vector2.new(460, 400) }, panel)
local title = make("TextLabel", { BackgroundTransparency = 1, Position = UDim2.fromOffset(20, 12), Size = UDim2.new(1, -70, 0, 34), Font = Enum.Font.Michroma, TextScaled = true, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = Palette.NeonCyan, }, panel)
local close = make("TextButton", { AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 12), Size = UDim2.fromOffset(34, 34), BackgroundColor3 = Palette.Violet, Text = "✕", TextColor3 = Palette.Cream, Font = Enum.Font.FredokaOne, TextSize = 20, }, panel)
round(close, 17)
local list = make("ScrollingFrame", { Position = UDim2.fromOffset(14, 58), Size = UDim2.new(1, -28, 1, -72), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 4, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), }, panel)
make("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, list)
local mode: string? = nil
local anchor: BasePart? = nil
]=])
S:SetAttribute("CozyNext",34)
print("Project Cozy: part 33/41 done. Paste part 34 next.")
