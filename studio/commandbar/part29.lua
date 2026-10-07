-- PROJECT COZY · PART 29 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=29 then warn("Project Cozy: this is part 29, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("StarterPlayer/StarterPlayerScripts/Client/Controllers/AudioController",[=[
sound.PlaybackSpeed = spec.speed * rng:NextNumber(0.94, 1.06)
if spec.maxLength then local length = spec.maxLength
task.delay(length, function()
local holder = sound.Parent
if holder and holder:IsA("Attachment") then holder:Destroy() -- 3D one-shot: remove its anchor too
elseif holder then sound:Destroy()
end
end)
end
if at then local anchor = Instance.new("Attachment")
anchor.WorldPosition = at
anchor.Parent = workspace.Terrain
sound.SoundGroup = Groups.World
sound.RollOffMinDistance = 6
sound.RollOffMaxDistance = 60
sound.Parent = anchor
sound.Ended:Once(function()
anchor:Destroy()
end)
else
sound.SoundGroup = Groups.UI
sound.Parent = SoundService
sound.Ended:Once(function()
sound:Destroy()
end)
end
sound:Play()
end
local function positionOf(inst: Instance): Vector3?
if inst:IsA("BasePart") then return inst.Position elseif inst:IsA("Model") then return inst:GetPivot().Position
end
return nil
end
function AudioController.start()
local beds: { [string]: Sound } = {}
for key, info in BEDS do
local id = Sounds[key]
if id and id ~= "" then local sound = Instance.new("Sound")
sound.Name = key
sound.SoundId = id
sound.Looped = true
sound.Volume = 0
sound.SoundGroup = info.group
sound.Parent = SoundService
sound:Play()
beds[key] = sound
end
end
local muffle = Instance.new("EqualizerSoundEffect")
muffle.LowGain = 0
muffle.MidGain = 0
muffle.HighGain = 0
muffle.Parent = Groups.Outside
local function addEmitter(inst: Instance)
local key = inst:GetAttribute("SoundKey") :: string?
local id = key and Sounds[key]
if not (key and id and id ~= "" and inst:IsA("BasePart")) then return
end
local spec = EMITTERS[key] or { volume = 0.3, range = 20 }
local sound = Instance.new("Sound")
sound.Name = key
sound.SoundId = id
sound.Looped = true
sound.Volume = spec.volume
sound.RollOffMode = Enum.RollOffMode.InverseTapered
sound.RollOffMinDistance = 3
sound.RollOffMaxDistance = spec.range
sound.SoundGroup = Groups.World
sound.Parent = inst
sound.TimePosition = rng:NextNumber(0, 4) -- de-sync identical loops
sound:Play()
end
for _, inst in CollectionService:GetTagged("AudioEmitter") do
addEmitter(inst)
end
CollectionService:GetInstanceAddedSignal("AudioEmitter"):Connect(addEmitter)
local remotes = ReplicatedStorage:WaitForChild("Remotes");
(remotes:WaitForChild("Sfx") :: RemoteEvent).OnClientEvent:Connect(function(key: string, at: Vector3?)
playOneShot(key, at)
end);
(remotes:WaitForChild("Pop") :: RemoteEvent).OnClientEvent:Connect(function(target: Instance?)
if target then playOneShot("Pop", positionOf(target))
end
end);
(remotes:WaitForChild("Toast") :: RemoteEvent).OnClientEvent:Connect(function(_, tone: string)
if tone == "nope" then playOneShot("Nope")
end
end)
local lastCredits = player:GetAttribute("Credits") :: number?
player:GetAttributeChangedSignal("Credits"):Connect(function()
local now = player:GetAttribute("Credits") :: number?
if lastCredits and now and now > lastCredits then playOneShot("Coin")
end
lastCredits = now
end)
local zone = "Street"
RunService.Heartbeat:Connect(function(dt)
local character = player.Character
local root = character and character:FindFirstChild("HumanoidRootPart") :: BasePart?
if root then local current = Zones.at(root.Position)
if current ~= zone then zone = current
SoundService.AmbientReverb = REVERB[zone] or Enum.ReverbType.NoReverb
end
end
local mix = MIX[zone] or {}
for key, sound in beds do
]=])
S:SetAttribute("CozyNext",30)
print("Project Cozy: part 29/41 done. Paste part 30 next.")
