--!strict
-- Client entry point. Everything here is presentation: camera, juice, HUD, weather.

local Controllers = script.Parent:WaitForChild("Controllers")

local controllers = {
	require(Controllers:WaitForChild("CameraController")),
	require(Controllers:WaitForChild("AmbientController")),
	require(Controllers:WaitForChild("PlantVisuals")),
	require(Controllers:WaitForChild("HudController")),
	require(Controllers:WaitForChild("RainController")),
	require(Controllers:WaitForChild("AudioController")),
}

for _, controller in controllers do
	task.spawn(controller.start)
end
