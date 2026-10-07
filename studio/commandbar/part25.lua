-- PROJECT COZY · PART 25 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=25 then warn("Project Cozy: this is part 25, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("StarterPlayer/StarterPlayerScripts/Client/Main",[=[
--!strict
local Controllers = script.Parent:WaitForChild("Controllers")
local controllers = { require(Controllers:WaitForChild("CameraController")), require(Controllers:WaitForChild("AmbientController")), require(Controllers:WaitForChild("PlantVisuals")), require(Controllers:WaitForChild("HudController")), require(Controllers:WaitForChild("RainController")), require(Controllers:WaitForChild("AudioController")), require(Controllers:WaitForChild("HomePanels")), }
for _, controller in controllers do
task.spawn(controller.start)
end
]=])
S:SetAttribute("CozyNext",26)
print("Project Cozy: part 25/41 done. Paste part 26 next.")
