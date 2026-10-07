-- PROJECT COZY · PART 20 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=20 then warn("Project Cozy: this is part 20, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("ServerScriptService/Server/Services/Notify",[=[
--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Toast = Remotes:WaitForChild("Toast") :: RemoteEvent
local Pop = Remotes:WaitForChild("Pop") :: RemoteEvent
local Sfx = Remotes:WaitForChild("Sfx") :: RemoteEvent
local Notify = {}
function Notify.toast(player: Player, text: string, tone: string?)
Toast:FireClient(player, text, tone or "info")
end
function Notify.pop(target: Instance, strength: number?)
Pop:FireAllClients(target, strength or 1)
end
function Notify.sfx(key: string, at: Vector3?, player: Player?)
if player then Sfx:FireClient(player, key, at)
else
Sfx:FireAllClients(key, at)
end
end
return Notify
]=])
S:SetAttribute("CozyNext",21)
print("Project Cozy: part 20/41 done. Paste part 21 next.")
