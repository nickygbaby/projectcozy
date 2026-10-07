--!strict
-- The HUD: soft rounded "sticker" UI (cozy) with neon outlines (cyber).
-- Reads credits/inventory straight off player attributes set by PlayerDataService.

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

local TONES = {
	good = Palette.NeonLime,
	info = Palette.NeonCyan,
	nope = Palette.NeonPink,
}

local function make(className: string, props: { [string]: any }, parent: Instance?): any
	local inst = Instance.new(className :: any)
	for key, value in props do
		(inst :: any)[key] = value
	end
	if parent then
		inst.Parent = parent
	end
	return inst
end

-- A rounded dark pill with a neon outline: the basic HUD "sticker".
local function pill(
	parent: Instance,
	name: string,
	size: UDim2,
	position: UDim2,
	anchor: Vector2,
	stroke: Color3
): Frame
	local frame = make("Frame", {
		Name = name,
		Size = size,
		Position = position,
		AnchorPoint = anchor,
		BackgroundColor3 = Palette.Ink,
		BackgroundTransparency = 0.15,
	}, parent)
	make("UICorner", { CornerRadius = UDim.new(1, 0) }, frame)
	make("UIStroke", { Color = stroke, Thickness = 2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, frame)
	return frame
end

local function text(parent: Instance, value: string, color: Color3, props: { [string]: any }?): TextLabel
	local label = make("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Text = value,
		TextColor3 = color,
		TextScaled = true,
		Font = Enum.Font.FredokaOne,
	}, parent)
	if props then
		for key, v in props do
			(label :: any)[key] = v
		end
	end
	return label
end

-- Springy UI bump using a UIScale.
local function bump(guiObject: GuiObject)
	local scale = guiObject:FindFirstChildOfClass("UIScale") or make("UIScale", {}, guiObject)
	scale.Scale = 1.18
	TweenService
		:Create(scale, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })
		:Play()
end

function HudController.start()
	local gui = make("ScreenGui", {
		Name = "CozyHud",
		ResetOnSpawn = false,
		IgnoreGuiInset = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	}, player:WaitForChild("PlayerGui"))

	-- Credits -----------------------------------------------------------------
	local credits = pill(
		gui,
		"Credits",
		UDim2.fromOffset(170, 44),
		UDim2.fromOffset(16, 16),
		Vector2.zero,
		Palette.NeonAmber
	)
	make("UIPadding", {
		PaddingLeft = UDim.new(0, 14),
		PaddingRight = UDim.new(0, 14),
		PaddingTop = UDim.new(0, 6),
		PaddingBottom = UDim.new(0, 6),
	}, credits)
	local creditsLabel = text(credits, "0 cr", Palette.Cream, { TextXAlignment = Enum.TextXAlignment.Left })

	local function refreshCredits()
		local value = (player:GetAttribute("Credits") :: number?) or 0
		creditsLabel.Text = `◆ {value} cr`
		bump(credits)
	end
	player:GetAttributeChangedSignal("Credits"):Connect(refreshCredits)
	refreshCredits()

	-- Clock -------------------------------------------------------------------
	local clock = pill(
		gui,
		"Clock",
		UDim2.fromOffset(120, 44),
		UDim2.new(1, -16, 0, 16),
		Vector2.new(1, 0),
		Palette.NeonPurple
	)
	make("UIPadding", { PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6) }, clock)
	local clockLabel = text(clock, "--:--", Palette.Cream, { Font = Enum.Font.Michroma })
	local lastMinute = -1
	RunService.Heartbeat:Connect(function()
		local t = Lighting.ClockTime
		local hours = math.floor(t)
		local minutes = math.floor((t - hours) * 60)
		if minutes ~= lastMinute then
			lastMinute = minutes
			clockLabel.Text = string.format("%02d:%02d", hours, minutes)
		end
	end)

	-- Inventory ---------------------------------------------------------------
	local bar = make("Frame", {
		Name = "Inventory",
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 1, -16),
		Size = UDim2.fromOffset(0, 46),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
	}, gui)
	make("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		Padding = UDim.new(0, 10),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, bar)

	for order, id in ItemsModule.ItemOrder do
		local item = ItemsModule.Items[id]
		local chip = pill(bar, id, UDim2.fromOffset(150, 46), UDim2.new(), Vector2.zero, item.Color)
		chip.LayoutOrder = order
		local dot = make("Frame", {
			Size = UDim2.fromOffset(18, 18),
			Position = UDim2.new(0, 14, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundColor3 = item.Color,
		}, chip)
		make("UICorner", { CornerRadius = UDim.new(1, 0) }, dot)
		local label = text(chip, "", Palette.Cream, {
			Size = UDim2.new(1, -44, 0.62, 0),
			Position = UDim2.new(0, 38, 0.19, 0),
			TextXAlignment = Enum.TextXAlignment.Left,
		})
		local attr = `Inv_{id}`
		local function refresh()
			local count = (player:GetAttribute(attr) :: number?) or 0
			label.Text = `{item.Name}  {count}`
			chip.BackgroundTransparency = if count > 0 then 0.15 else 0.5
			-- Jars only show up once you've made some, so the bar stays short.
			chip.Visible = not item.Jar or count > 0
			bump(chip)
		end
		player:GetAttributeChangedSignal(attr):Connect(refresh)
		refresh()
	end

	-- Controls hint (fades after a while) --------------------------------------
	local hint = text(gui, "Z / C rotate  ·  wheel zoom  ·  V camera", Palette.Lilac, {
		Size = UDim2.fromOffset(420, 22),
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 1, -70),
		TextTransparency = 0.2,
	})
	task.delay(12, function()
		TweenService:Create(hint, TweenInfo.new(2), { TextTransparency = 1 }):Play()
	end)

	-- Toasts ------------------------------------------------------------------
	local toasts = make("Frame", {
		Name = "Toasts",
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 16),
		Size = UDim2.fromOffset(520, 200),
		BackgroundTransparency = 1,
	}, gui)
	make("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, toasts)
	local toastCount = 0

	local toastRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Toast") :: RemoteEvent
	toastRemote.OnClientEvent:Connect(function(message: string, tone: string)
		toastCount += 1
		local color = TONES[tone] or Palette.NeonCyan
		local toast = pill(toasts, "Toast", UDim2.fromOffset(0, 38), UDim2.new(), Vector2.zero, color)
		toast.AutomaticSize = Enum.AutomaticSize.X
		toast.LayoutOrder = toastCount
		make("UIPadding", { PaddingLeft = UDim.new(0, 18), PaddingRight = UDim.new(0, 18) }, toast)
		local label = text(toast, message, Palette.Cream, {
			Size = UDim2.fromScale(0, 1),
			AutomaticSize = Enum.AutomaticSize.X,
			TextScaled = false,
			TextSize = 20,
		})
		local scale = make("UIScale", { Scale = 0.2 }, toast)
		TweenService
			:Create(scale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })
			:Play()

		-- Keep the stack short.
		local children = {}
		for _, child in toasts:GetChildren() do
			if child:IsA("Frame") then
				table.insert(children, child)
			end
		end
		if #children > 3 then
			table.sort(children, function(a, b)
				return a.LayoutOrder < b.LayoutOrder
			end)
			children[1]:Destroy()
		end

		task.delay(3.2, function()
			if not toast.Parent then
				return
			end
			local out = TweenService:Create(
				scale,
				TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In),
				{ Scale = 0 }
			)
			TweenService:Create(label, TweenInfo.new(0.25), { TextTransparency = 1 }):Play()
			out:Play()
			out.Completed:Wait()
			toast:Destroy()
		end)
	end)
end

return HudController
