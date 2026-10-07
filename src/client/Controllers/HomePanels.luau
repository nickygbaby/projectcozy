--!strict
-- The two home screens: Neighbor Net (deliver requests) and the Kitchenette (cook jars).
-- Opened by the "TerminalPrompt" / "KitchenPrompt" prompts (press E) or by clicking the
-- terminal / counter itself (tag "HomePanelTarget"). Closed with ✕, by walking away, or
-- by clicking the object again. The server validates every button press (HomeService).
--
-- Home is first person, which locks the mouse to the screen center. While a panel is open
-- the close button is Modal, which frees the mouse so the buttons can be clicked.

local CollectionService = game:GetService("CollectionService")
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
	if parent then
		inst.Parent = parent
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
	if typeof(raw) ~= "string" then
		return {}
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
	local gui = make(
		"ScreenGui",
		{ Name = "HomePanels", ResetOnSpawn = false, Enabled = false },
		player:WaitForChild("PlayerGui")
	)
	local panel = make("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(460, 400),
		BackgroundColor3 = Palette.Ink,
		BackgroundTransparency = 0.05,
	}, gui)
	round(panel, 22)
	local stroke = make("UIStroke", { Thickness = 2, Color = Palette.NeonCyan }, panel)
	local scale = make("UIScale", { Scale = 1 }, panel)
	make("UISizeConstraint", { MaxSize = Vector2.new(460, 400) }, panel)

	local title = make("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(20, 12),
		Size = UDim2.new(1, -70, 0, 34),
		Font = Enum.Font.Michroma,
		TextScaled = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = Palette.NeonCyan,
	}, panel)
	local close = make("TextButton", {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -12, 0, 12),
		Size = UDim2.fromOffset(34, 34),
		BackgroundColor3 = Palette.Violet,
		Text = "✕",
		TextColor3 = Palette.Cream,
		Font = Enum.Font.FredokaOne,
		TextSize = 20,
	}, panel)
	round(close, 17)

	local list = make("ScrollingFrame", {
		Position = UDim2.fromOffset(14, 58),
		Size = UDim2.new(1, -28, 1, -72),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 4,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(),
	}, panel)
	make("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, list)

	local mode: string? = nil
	local anchor: BasePart? = nil

	local function card(
		order: number,
		heading: string,
		sub: string,
		detail: string,
		button: string,
		ready: boolean,
		accent: Color3,
		onClick: () -> ()
	)
		local c = make(
			"Frame",
			{ LayoutOrder = order, Size = UDim2.new(1, -6, 0, 92), BackgroundColor3 = Palette.Indigo },
			list
		)
		round(c, 14)
		make("UIStroke", { Color = accent, Thickness = 1.5, Transparency = 0.3 }, c)
		local function line(y: number, h: number, text: string, color: Color3, font: Enum.Font)
			make("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(14, y),
				Size = UDim2.new(1, -140, 0, h),
				Text = text,
				TextColor3 = color,
				Font = font,
				TextScaled = true,
				TextXAlignment = Enum.TextXAlignment.Left,
			}, c)
		end
		line(8, 24, heading, Palette.Cream, Enum.Font.FredokaOne)
		line(34, 16, sub, Palette.Lilac, Enum.Font.FredokaOne)
		line(56, 26, detail, accent, Enum.Font.FredokaOne)
		local b = make("TextButton", {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -12, 0.5, 0),
			Size = UDim2.fromOffset(108, 40),
			BackgroundColor3 = if ready then accent else Palette.Violet,
			AutoButtonColor = ready,
			Text = button,
			TextColor3 = if ready then Palette.Ink else Palette.Concrete,
			Font = Enum.Font.FredokaOne,
			TextSize = 20,
		}, c)
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
			if child:IsA("Frame") then
				child:Destroy()
			end
		end
		if mode == "orders" then
			title.Text = "NEIGHBOR NET"
			stroke.Color = Palette.NeonCyan
			local friends = decode("Friends")
			for i, order in decode("Orders") do
				local item = ItemsModule.Items[order.Item]
				if item then
					local have = count(order.Item)
					card(
						i,
						`{order.Neighbor}  ·  {FLOORS[order.Neighbor] or ""}  {hearts(
							friends[order.Neighbor] or 0
						)}`,
						BLURBS[order.Neighbor] or "",
						`{order.Count}x {item.Name}  ({have}/{order.Count})  →  {order.Reward} cr`,
						"Deliver",
						have >= order.Count,
						item.Color,
						function()
							remote:FireServer("deliver", order.Id)
						end
					)
				end
			end
		elseif mode == "kitchen" then
			title.Text = "KITCHENETTE"
			stroke.Color = Palette.NeonAmber
			for i, recipe in ItemsModule.HomeRecipes do
				local makes = ItemsModule.Items[recipe.Makes]
				local ready = true
				for id, n in recipe.Needs do
					if count(id) < n then
						ready = false
					end
				end
				card(
					i,
					`{recipe.Icon} {makes.Name}`,
					`You have {count(recipe.Makes)}`,
					ItemsModule.describeNeeds(recipe.Needs),
					"Make",
					ready,
					makes.Color,
					function()
						remote:FireServer("cook", recipe.Id)
					end
				)
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
			:Create(
				scale,
				TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
				{ Scale = 1 }
			)
			:Play()
	end

	local function hide()
		mode, anchor = nil, nil
		gui.Enabled = false
		close.Modal = false
	end
	close.Activated:Connect(hide)

	local function toggle(newMode: string, at: BasePart)
		if mode == newMode then
			hide()
		else
			open(newMode, at)
		end
	end

	-- Click (or tap) the terminal / counter directly. In first person this hits whatever
	-- is under the crosshair.
	local function addTarget(inst: Instance)
		local detector = inst:FindFirstChildOfClass("ClickDetector")
		local panelMode = inst:GetAttribute("Panel")
		if inst:IsA("BasePart") and detector and typeof(panelMode) == "string" then
			detector.MouseClick:Connect(function(who)
				if who == player then
					toggle(panelMode, inst)
				end
			end)
		end
	end
	for _, inst in CollectionService:GetTagged("HomePanelTarget") do
		addTarget(inst)
	end
	CollectionService:GetInstanceAddedSignal("HomePanelTarget"):Connect(addTarget)

	ProximityPromptService.PromptTriggered:Connect(function(promptObj, who)
		if who ~= player then
			return
		end
		local parent = promptObj.Parent
		if not (parent and parent:IsA("BasePart")) then
			return
		end
		if promptObj.Name == "TerminalPrompt" then
			open("orders", parent)
		elseif promptObj.Name == "KitchenPrompt" then
			open("kitchen", parent)
		end
	end)

	-- Live refresh while open, and close when you walk away.
	player.AttributeChanged:Connect(function(name)
		if mode and (name == "Orders" or name == "Friends" or string.sub(name, 1, 4) == "Inv_") then
			render()
		end
	end)
	RunService.Heartbeat:Connect(function()
		if not (mode and anchor) then
			return
		end
		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart") :: BasePart?
		if not root or (root.Position - anchor.Position).Magnitude > 14 then
			hide()
		end
	end)
end

return HomePanels
