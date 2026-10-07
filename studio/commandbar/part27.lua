-- PROJECT COZY · PART 27 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=27 then warn("Project Cozy: this is part 27, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("StarterPlayer/StarterPlayerScripts/Client/Controllers/AmbientController",[=[
end
end)
onTag("Spin", function(inst)
local cf = pivotOf(inst)
if cf then spinning[inst] = cf
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
if target and target.Parent then Juice.pop(target, strength)
end
end)
local t = 0
RunService.RenderStepped:Connect(function(dt)
t += dt
for model, floater in bobbing do
if not model.Parent then bobbing[model] = nil
continue
end
local amp = (model:GetAttribute("BobAmplitude") :: number?) or 0.2
local speed = (model:GetAttribute("BobSpeed") :: number?) or 1.5
local y = math.sin(t * speed + floater.phase) * amp
local sway = math.sin(t * speed * 0.5 + floater.phase) * amp * 0.15
model:PivotTo(floater.base * CFrame.new(0, y, 0) * CFrame.Angles(0, 0, sway))
end
for inst, base in spinning do
if not inst.Parent then spinning[inst] = nil
continue
end
setPivot(inst, base * CFrame.Angles(0, t * 1.2, 0))
end
end)
end
return AmbientController
]=])
S:SetAttribute("CozyNext",28)
print("Project Cozy: part 27/41 done. Paste part 28 next.")
