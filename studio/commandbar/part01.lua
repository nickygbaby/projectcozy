-- PROJECT COZY · PART 1 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
local RS=game:GetService("ReplicatedStorage")
local SP=game:GetService("StarterPlayer")
for _,p in {{RS,"Shared"},{RS,"Remotes"},{S,"Server"},{SP.StarterPlayerScripts,"Client"}} do local o=p[1]:FindFirstChild(p[2]) if o then o:Destroy() end end
local function dir(path) local node=game for _,n in string.split(path,"/") do local c=node:FindFirstChild(n) if not c then c=Instance.new("Folder") c.Name=n c.Parent=node end node=c end return node end
for _,r in {{"ReplicatedStorage/Shared","Config","ModuleScript"},{"ReplicatedStorage/Shared","Items","ModuleScript"},{"ReplicatedStorage/Shared","Juice","ModuleScript"},{"ReplicatedStorage/Shared","Neighbors","ModuleScript"},{"ReplicatedStorage/Shared","Palette","ModuleScript"},{"ReplicatedStorage/Shared","Zones","ModuleScript"},{"ServerScriptService/Server","Main","Script"},{"ServerScriptService/Server/Services","AtmosphereService","ModuleScript"},{"ServerScriptService/Server/Services","DistrictBuilder","ModuleScript"},{"ServerScriptService/Server/Services","GardenService","ModuleScript"},{"ServerScriptService/Server/Services","HomeService","ModuleScript"},{"ServerScriptService/Server/Services","InteractionsService","ModuleScript"},{"ServerScriptService/Server/Services","Notify","ModuleScript"},{"ServerScriptService/Server/Services","PlayerDataService","ModuleScript"},{"ServerScriptService/Server/Services","StallService","ModuleScript"},{"StarterPlayer/StarterPlayerScripts/Client","Main","LocalScript"},{"StarterPlayer/StarterPlayerScripts/Client/Controllers","AmbientController","ModuleScript"},{"StarterPlayer/StarterPlayerScripts/Client/Controllers","AudioController","ModuleScript"},{"StarterPlayer/StarterPlayerScripts/Client/Controllers","CameraController","ModuleScript"},{"StarterPlayer/StarterPlayerScripts/Client/Controllers","HomePanels","ModuleScript"},{"StarterPlayer/StarterPlayerScripts/Client/Controllers","HudController","ModuleScript"},{"StarterPlayer/StarterPlayerScripts/Client/Controllers","PlantVisuals","ModuleScript"},{"StarterPlayer/StarterPlayerScripts/Client/Controllers","RainController","ModuleScript"}} do local s=Instance.new(r[3]) s.Name=r[2] s.Disabled=(r[3]~="ModuleScript") s.Parent=dir(r[1]) end
local rem=Instance.new("Folder") rem.Name="Remotes"
for _,n in {"Toast","Pop","Sfx","HomeAction"} do local e=Instance.new("RemoteEvent") e.Name=n e.Parent=rem end
rem.Parent=RS
pcall(function() game:GetService("Lighting").Technology=Enum.Technology.Future end)
local b=workspace:FindFirstChild("Baseplate") if b then b:Destroy() end
S:SetAttribute("CozyNext",2)
print("Project Cozy: part 1/41 done. Paste part 2 next.")
