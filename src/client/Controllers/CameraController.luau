--!strict
-- Cozy diorama camera: high angle, narrow FOV, soft tilt-shift blur, smooth follow.
-- This is the single biggest lever for the "Tiny Eden" look: the city reads as a toy you
-- could hold in your hands.
--
--   Z / C  or  L1 / R1 : rotate 45° (E is the interact key, so we stay off it)
--   Mouse wheel        : zoom
--   V                  : toggle back to the default Roblox camera

local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local Config = require(Shared.Config)

local CameraController = {}

local cfg = Config.Camera
local player = Players.LocalPlayer

local enabled = true
local targetYaw = math.rad(cfg.StartYaw)
local currentYaw = targetYaw
local targetDistance = cfg.Distance
local currentDistance = cfg.Distance
local focus: Vector3? = nil

-- Parts we've faded because they block the view of the player.
local faded: { [BasePart]: boolean } = {}

local function damp(a: number, b: number, sharpness: number, dt: number): number
	return a + (b - a) * (1 - math.exp(-sharpness * dt))
end

local function updateOcclusion(camera: Camera, target: Vector3, character: Model)
	local still: { [BasePart]: boolean } = {}
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	local ignore: { Instance } = { character }

	local origin = camera.CFrame.Position
	for _ = 1, 6 do
		params.FilterDescendantsInstances = ignore
		local result = workspace:Raycast(origin, target - origin, params)
		if not result then
			break
		end
		local hit = result.Instance
		if hit:IsA("BasePart") and hit.Transparency < 1 then
			still[hit] = true
			hit.LocalTransparencyModifier = 0.75
		end
		table.insert(ignore, hit)
	end

	for p in faded do
		if not still[p] then
			p.LocalTransparencyModifier = 0
		end
	end
	faded = still
end

local function clearOcclusion()
	for p in faded do
		p.LocalTransparencyModifier = 0
	end
	faded = {}
end

function CameraController.start()
	local camera = workspace.CurrentCamera

	-- Tilt-shift: keep a band around the player crisp, soften the foreground and background.
	local dof = Instance.new("DepthOfFieldEffect")
	dof.Name = "TiltShift"
	dof.FarIntensity = 0.35
	dof.NearIntensity = 0.6
	dof.Parent = camera

	local function apply()
		if enabled then
			camera.CameraType = Enum.CameraType.Scriptable
			camera.FieldOfView = cfg.FieldOfView
			dof.Enabled = true
		else
			camera.CameraType = Enum.CameraType.Custom
			camera.FieldOfView = 70
			dof.Enabled = false
			clearOcclusion()
		end
	end
	apply()

	ContextActionService:BindAction("CozyRotate", function(_, state, input)
		if state ~= Enum.UserInputState.Begin then
			return Enum.ContextActionResult.Pass
		end
		local dir = if input.KeyCode == Enum.KeyCode.Z or input.KeyCode == Enum.KeyCode.ButtonL1
			then -1
			else 1
		targetYaw += math.rad(cfg.RotateStep) * dir
		return Enum.ContextActionResult.Sink
	end, false, Enum.KeyCode.Z, Enum.KeyCode.C, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)

	ContextActionService:BindAction("CozyToggleCamera", function(_, state)
		if state == Enum.UserInputState.Begin then
			enabled = not enabled
			apply()
		end
		return Enum.ContextActionResult.Sink
	end, false, Enum.KeyCode.V)

	UserInputService.InputChanged:Connect(function(input, processed)
		if processed or not enabled then
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseWheel then
			targetDistance =
				math.clamp(targetDistance - input.Position.Z * 6, cfg.MinDistance, cfg.MaxDistance)
		end
	end)

	-- Respawns reset CameraType; reclaim it.
	player.CharacterAdded:Connect(function()
		task.defer(apply)
	end)

	RunService:BindToRenderStep("CozyCamera", Enum.RenderPriority.Camera.Value + 1, function(dt)
		if not enabled then
			return
		end
		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart") :: BasePart?
		if not (character and root) then
			return
		end
		if camera.CameraType ~= Enum.CameraType.Scriptable then
			camera.CameraType = Enum.CameraType.Scriptable
		end

		local goal = root.Position + Vector3.new(0, 1.5, 0)
		if focus then
			local alpha = 1 - math.exp(-cfg.FollowSharpness * dt)
			focus = focus:Lerp(goal, alpha)
		else
			focus = goal
		end
		currentYaw = damp(currentYaw, targetYaw, cfg.RotateSharpness, dt)
		currentDistance = damp(currentDistance, targetDistance, cfg.RotateSharpness, dt)

		local f = focus :: Vector3
		local rotation = CFrame.Angles(0, currentYaw, 0) * CFrame.Angles(-math.rad(cfg.Pitch), 0, 0)
		local position = f + rotation:VectorToWorldSpace(Vector3.new(0, 0, currentDistance))
		camera.CFrame = CFrame.lookAt(position, f)
		camera.Focus = CFrame.new(f)

		dof.FocusDistance = currentDistance
		dof.InFocusRadius = currentDistance * 0.3

		updateOcclusion(camera, f, character)
	end)
end

return CameraController
