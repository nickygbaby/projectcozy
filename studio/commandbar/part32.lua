-- PROJECT COZY · PART 32 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=32 then warn("Project Cozy: this is part 32, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("StarterPlayer/StarterPlayerScripts/Client/Controllers/CameraController",[=[
targetYaw += math.rad(cfg.RotateStep) * dir
return Enum.ContextActionResult.Sink
end, false, Enum.KeyCode.Z, Enum.KeyCode.C, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
ContextActionService:BindAction("CozyToggleCamera", function(_, state)
if state == Enum.UserInputState.Begin then enabled = not enabled
apply()
end
return Enum.ContextActionResult.Sink
end, false, Enum.KeyCode.V)
UserInputService.InputChanged:Connect(function(input, processed)
if processed or not enabled then return
end
if input.UserInputType == Enum.UserInputType.MouseWheel then targetDistance = math.clamp(targetDistance - input.Position.Z * 6, cfg.MinDistance, cfg.MaxDistance)
end
end)
player.CharacterAdded:Connect(function()
task.defer(apply)
end)
RunService:BindToRenderStep("CozyCamera", Enum.RenderPriority.Camera.Value + 1, function(dt)
local character = player.Character
local root = character and character:FindFirstChild("HumanoidRootPart") :: BasePart?
if not (character and root) then return
end
local home = Zones.contains("Home", root.Position)
if home ~= atHome then atHome = home
focus = nil
apply()
end
if atHome or not enabled then return
end
if camera.CameraType ~= Enum.CameraType.Scriptable then camera.CameraType = Enum.CameraType.Scriptable
end
local goal = root.Position + Vector3.new(0, 1.5, 0)
if focus then local alpha = 1 - math.exp(-cfg.FollowSharpness * dt)
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
dof.InFocusRadius = currentDistance * 0.55
updateOcclusion(camera, f, character)
end)
end
return CameraController
]=])
S:SetAttribute("CozyNext",33)
print("Project Cozy: part 32/41 done. Paste part 33 next.")
