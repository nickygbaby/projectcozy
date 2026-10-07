--!strict
-- Soft, constant drizzle that follows the player. (Rain *sound* lives in AudioController.)
-- Rain is the bridge between the two moods: it's cozy (listen to it from under the awning)
-- and it's cyberpunk (neon smeared on wet asphalt).

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local Palette = require(Shared.Palette)
local Zones = require(Shared.Zones)

local RainController = {}

function RainController.start()
	local emitterPart = Instance.new("Part")
	emitterPart.Name = "RainCloud"
	emitterPart.Anchored = true
	emitterPart.CanCollide = false
	emitterPart.CanQuery = false
	emitterPart.CanTouch = false
	emitterPart.Transparency = 1
	emitterPart.Size = Vector3.new(120, 1, 120)
	emitterPart.Parent = workspace

	local rain = Instance.new("ParticleEmitter")
	rain.Name = "Rain"
	rain.EmissionDirection = Enum.NormalId.Bottom
	rain.Rate = 600
	rain.Lifetime = NumberRange.new(0.9, 1.1)
	rain.Speed = NumberRange.new(70, 80)
	rain.SpreadAngle = Vector2.new(4, 4)
	rain.Size = NumberSequence.new(0.12)
	-- Stretch each particle into a streak. Tune in Studio; swap in a real streak texture later.
	rain.Squash = NumberSequence.new(2.5)
	rain.Orientation = Enum.ParticleOrientation.VelocityParallel
	rain.Transparency = NumberSequence.new(0.55)
	rain.Color = ColorSequence.new(Palette.Sky)
	rain.LightEmission = 0.4
	rain.LightInfluence = 0.6
	rain.Parent = emitterPart

	local player = Players.LocalPlayer
	RunService.Heartbeat:Connect(function()
		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart") :: BasePart?
		local center = if root then root.Position else workspace.CurrentCamera.Focus.Position
		if Zones.contains("Home", center) then
			-- At home: rain only outside the window line (z < 22) so the room stays dry and
			-- you watch it fall past the glass onto the balcony and the street below.
			emitterPart.Size = Vector3.new(80, 1, 30)
			emitterPart.CFrame = CFrame.new(center.X, center.Y + 40, 6)
		else
			emitterPart.Size = Vector3.new(120, 1, 120)
			emitterPart.CFrame = CFrame.new(center.X, center.Y + 60, center.Z)
		end
	end)
end

return RainController
