-- PROJECT COZY · PART 35 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=35 then warn("Project Cozy: this is part 35, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("StarterPlayer/StarterPlayerScripts/Client/Controllers/HomePanels",[=[
if mode and (name == "Orders" or name == "Friends" or string.sub(name, 1, 4) == "Inv_") then render()
end
end)
RunService.Heartbeat:Connect(function()
if not (mode and anchor) then return
end
local character = player.Character
local root = character and character:FindFirstChild("HumanoidRootPart") :: BasePart?
if not root or (root.Position - anchor.Position).Magnitude > 14 then hide()
end
end)
end
return HomePanels
]=])
S:SetAttribute("CozyNext",36)
print("Project Cozy: part 35/41 done. Paste part 36 next.")
