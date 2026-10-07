--!strict
-- Client-side life: things that bob, spin, flicker and pop. Driven entirely by tags and
-- attributes the server sets, so art can be swapped without touching code.
--
--   Tag "Bob"         Model gently floats (attributes BobAmplitude, BobSpeed)
--   Tag "Spin"        Part/Model turns slowly around Y
--   Tag "NeonFlicker" Sign or light occasionally stutters like a cheap neon tube
--   Tag "Customer"    Pops in on arrival; hops (happy) or shrinks away (sad) on leaving
--   Remote "Pop"      Server asks for a springy bounce on any instance

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Juice = require(Shared.Juice)
local Palette = require(Shared.Palette)

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local AmbientController = {}

-- Bob & Spin ---------------------------------------------------------------

type Floater = { base: CFrame, phase: number }
local bobbing: { [Model]: Floater } = {}
local spinning: { [Instance]: CFrame } = {}

local function pivotOf(inst: Instance): CFrame?
	if inst:IsA("Model") then
		return inst:GetPivot()
	elseif inst:IsA("BasePart") then
		return inst.CFrame
	end
	return nil
end

local function setPivot(inst: Instance, cf: CFrame)
	if inst:IsA("Model") then
		inst:PivotTo(cf)
	elseif inst:IsA("BasePart") then
		inst.CFrame = cf
	end
end

local function onTag(tag: string, added: (Instance) -> (), removed: ((Instance) -> ())?)
	for _, inst in CollectionService:GetTagged(tag) do
		task.spawn(added, inst)
	end
	CollectionService:GetInstanceAddedSignal(tag):Connect(added)
	if removed then
		CollectionService:GetInstanceRemovedSignal(tag):Connect(removed)
	end
end

-- Flicker ------------------------------------------------------------------

local function flickerLoop(inst: Instance)
	local rng = Random.new()
	while inst.Parent do
		task.wait(rng:NextNumber(2, 9))
		if not inst.Parent then
			break
		end
		-- A short burst of off/on stutters, like a tube that needs replacing.
		for _ = 1, rng:NextInteger(2, 5) do
			local on = false
			for _, d in inst:GetDescendants() do
				if d:IsA("Light") or d:IsA("SurfaceGui") then
					d.Enabled = on
				end
			end
			if inst:IsA("BasePart") and inst.Material == Enum.Material.Neon then
				inst.LocalTransparencyModifier = 0.85
			end
			task.wait(rng:NextNumber(0.03, 0.12))
			for _, d in inst:GetDescendants() do
				if d:IsA("Light") or d:IsA("SurfaceGui") then
					d.Enabled = true
				end
			end
			if inst:IsA("BasePart") then
				inst.LocalTransparencyModifier = 0
			end
			task.wait(rng:NextNumber(0.04, 0.2))
		end
	end
end

-- Customers ----------------------------------------------------------------

local function watchPatience(model: Model)
	local bar = model:FindFirstChild("Patience", true) :: Frame?
	if not bar then
		return
	end
	local total = model:GetAttribute("Patience") :: number
	local spawnedAt = model:GetAttribute("SpawnedAt") :: number
	local fullWidth = bar.Size.X.Scale
	local conn: RBXScriptConnection
	conn = RunService.Heartbeat:Connect(function()
		if not model.Parent or model:GetAttribute("Mood") then
			conn:Disconnect()
			return
		end
		local left = math.clamp(1 - (workspace:GetServerTimeNow() - spawnedAt) / total, 0, 1)
		bar.Size = UDim2.new(fullWidth * left, 0, 0, bar.Size.Y.Offset)
		bar.BackgroundColor3 = if left > 0.5
			then Palette.NeonLime
			elseif left > 0.2 then Palette.NeonAmber
			else Palette.NeonRed
	end)
end

local function onCustomer(inst: Instance)
	if not inst:IsA("Model") then
		return
	end
	local model = inst
	Juice.popIn(model)
	task.spawn(watchPatience, model)
	model:GetAttributeChangedSignal("Mood"):Connect(function()
		local mood = model:GetAttribute("Mood")
		bobbing[model] = nil
		local order = model:FindFirstChild("Order", true)
		if order and order:IsA("BillboardGui") then
			order.Enabled = false
		end
		if mood == "happy" then
			Juice.hop(model, 3)
			task.delay(0.8, function()
				if model.Parent then
					Juice.popOut(model)
				end
			end)
		else
			Juice.popOut(model)
		end
	end)
end

-- Start --------------------------------------------------------------------

function AmbientController.start()
	onTag("Bob", function(inst)
		if inst:IsA("Model") then
			local base = inst:GetPivot()
			bobbing[inst] = { base = base, phase = math.random() * math.pi * 2 }
		end
	end, function(inst)
		if inst:IsA("Model") then
			bobbing[inst] = nil
		end
	end)

	onTag("Spin", function(inst)
		local cf = pivotOf(inst)
		if cf then
			spinning[inst] = cf
		end
	end, function(inst)
		spinning[inst] = nil
	end)

	onTag("NeonFlicker", function(inst)
		task.spawn(flickerLoop, inst)
	end)

	onTag("Customer", onCustomer)

	local pop = Remotes:WaitForChild("Pop") :: RemoteEvent
	pop.OnClientEvent:Connect(function(target: Instance?, strength: number?)
		if target and target.Parent then
			Juice.pop(target, strength)
		end
	end)

	local t = 0
	RunService.RenderStepped:Connect(function(dt)
		t += dt
		for model, floater in bobbing do
			if not model.Parent then
				bobbing[model] = nil
				continue
			end
			local amp = (model:GetAttribute("BobAmplitude") :: number?) or 0.2
			local speed = (model:GetAttribute("BobSpeed") :: number?) or 1.5
			local y = math.sin(t * speed + floater.phase) * amp
			-- A whisper of sway sells "hanging" / "breathing" better than pure vertical motion.
			local sway = math.sin(t * speed * 0.5 + floater.phase) * amp * 0.15
			model:PivotTo(floater.base * CFrame.new(0, y, 0) * CFrame.Angles(0, 0, sway))
		end
		for inst, base in spinning do
			if not inst.Parent then
				spinning[inst] = nil
				continue
			end
			setPivot(inst, base * CFrame.Angles(0, t * 1.2, 0))
		end
	end)
end

return AmbientController
