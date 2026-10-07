--!strict
-- Juice: the springy squash-and-stretch that makes the world feel like a toy.
-- Client-side only. The server owns state; the client makes it bounce.
--
--   Juice.squash(part, 1)   -- jelly wobble on a single part, base stays planted
--   Juice.pop(model, 1)     -- uniform springy scale bump on a model (or part)
--   Juice.popIn(model)      -- grow from nothing with an overshoot
--   Juice.popOut(model)     -- shrink away, then call onDone
--   Juice.hop(model, 3)     -- little happy jump

local RunService = game:GetService("RunService")

-- Damped spring --------------------------------------------------------------

export type Spring = {
	x: number,
	v: number,
	target: number,
	stiffness: number,
	damping: number,
}

local function newSpring(stiffness: number, damping: number): Spring
	return { x = 0, v = 0, target = 0, stiffness = stiffness, damping = damping }
end

local MAX_STEP = 1 / 120

local function stepSpring(s: Spring, dt: number)
	-- Fixed substeps keep stiff springs stable on low frame rates.
	while dt > 0 do
		local h = math.min(dt, MAX_STEP)
		local force = -s.stiffness * (s.x - s.target) - s.damping * s.v
		s.v += force * h
		s.x += s.v * h
		dt -= h
	end
end

local function isResting(s: Spring): boolean
	return math.abs(s.x - s.target) < 1e-3 and math.abs(s.v) < 1e-3
end

-- Feel presets. Lower damping = more wobble.
local JELLY = { stiffness = 320, damping = 11 }
local BOUNCE = { stiffness = 260, damping = 14 }

-- Active animations ----------------------------------------------------------

type Anim = {
	spring: Spring,
	apply: (x: number) -> (),
	finish: () -> (),
}

local active: { [Instance]: Anim } = {}
local connection: RBXScriptConnection? = nil

local function ensureLoop()
	if connection then
		return
	end
	connection = RunService.Heartbeat:Connect(function(dt)
		for target, anim in active do
			if target.Parent == nil then
				active[target] = nil
				continue
			end
			stepSpring(anim.spring, dt)
			if isResting(anim.spring) then
				active[target] = nil
				anim.finish()
			else
				anim.apply(anim.spring.x)
			end
		end
		if next(active) == nil and connection then
			connection:Disconnect()
			connection = nil
		end
	end)
end

local Juice = {}

-- Part squash: volume-ish preserving. x > 0 = squashed flat, x < 0 = stretched tall.
local partRest: { [BasePart]: { size: Vector3, cframe: CFrame } } = setmetatable({}, { __mode = "k" }) :: any

function Juice.squash(part: BasePart, strength: number?)
	local existing = active[part]
	if existing then
		existing.spring.v += 6 * (strength or 1)
		return
	end

	local rest = { size = part.Size, cframe = part.CFrame }
	partRest[part] = rest

	local spring = newSpring(JELLY.stiffness, JELLY.damping)
	spring.v = 6 * (strength or 1)

	active[part] = {
		spring = spring,
		apply = function(x)
			local squash = math.clamp(x * 0.35, -0.4, 0.4)
			local y = rest.size.Y * (1 - squash)
			local xz = 1 + squash * 0.5
			part.Size = Vector3.new(rest.size.X * xz, y, rest.size.Z * xz)
			-- Keep the bottom face planted so objects squish into the ground, not the air.
			part.CFrame = rest.cframe * CFrame.new(0, (y - rest.size.Y) / 2, 0)
		end,
		finish = function()
			part.Size = rest.size
			part.CFrame = rest.cframe
			partRest[part] = nil
		end,
	}
	ensureLoop()
end

-- Model scale animations ----------------------------------------------------

local function scaleAnim(model: Model, startX: number, velocity: number, preset, onDone: (() -> ())?)
	local existing = active[model]
	if existing then
		-- Already animating: finish snaps back to its base scale first.
		existing.finish()
		active[model] = nil
	end
	local base = model:GetScale()

	local spring = newSpring(preset.stiffness, preset.damping)
	spring.x = startX
	spring.v = velocity

	local function apply(x: number)
		model:ScaleTo(base * math.max(0.02, 1 + x))
	end
	apply(startX)

	active[model] = {
		spring = spring,
		apply = apply,
		finish = function()
			model:ScaleTo(base)
			if onDone then
				onDone()
			end
		end,
	}
	ensureLoop()
end

function Juice.pop(target: Instance, strength: number?)
	if target:IsA("BasePart") then
		Juice.squash(target, strength)
	elseif target:IsA("Model") then
		scaleAnim(target, 0, 2.5 * (strength or 1), JELLY)
	end
end

function Juice.popIn(model: Model)
	scaleAnim(model, -0.98, 0, BOUNCE)
end

function Juice.popOut(model: Model, onDone: (() -> ())?)
	-- Spring toward "almost nothing" with a little anticipation bump first.
	local existing = active[model]
	if existing then
		existing.finish()
		active[model] = nil
	end
	local base = model:GetScale()
	local spring = newSpring(BOUNCE.stiffness, BOUNCE.damping)
	spring.v = 2
	spring.target = -0.98
	active[model] = {
		spring = spring,
		apply = function(x)
			model:ScaleTo(base * math.max(0.02, 1 + x))
		end,
		finish = function()
			if onDone then
				onDone()
			end
		end,
	}
	ensureLoop()
end

function Juice.hop(model: Model, height: number?)
	local h = height or 3
	local existing = active[model]
	if existing then
		existing.finish()
		active[model] = nil
	end
	local start = model:GetPivot()
	local spring = newSpring(BOUNCE.stiffness * 0.5, BOUNCE.damping * 0.6)
	spring.v = h * 9
	active[model] = {
		spring = spring,
		apply = function(x)
			model:PivotTo(start + Vector3.new(0, math.max(0, x), 0))
		end,
		finish = function()
			model:PivotTo(start)
		end,
	}
	ensureLoop()
end

Juice.newSpring = newSpring
Juice.stepSpring = stepSpring

return Juice
