-- PROJECT COZY · PART 19 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=19 then warn("Project Cozy: this is part 19, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("ServerScriptService/Server/Services/HomeService",[=[
function HomeService.start(terminal: BasePart, kitchen: BasePart)
PlayerData.onLoaded(fillOrders)
local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("HomeAction") :: RemoteEvent
remote.OnServerEvent:Connect(function(player, action: any, arg: any)
local now = os.clock()
if (lastAction[player] or 0) + 0.25 > now then return
end
lastAction[player] = now
local profile = PlayerData.get(player)
if not profile or typeof(arg) ~= "string" then return
end
if action == "deliver" and near(player, terminal, 16) then deliver(player, profile, arg, terminal) elseif action == "cook" and near(player, kitchen, 16) then cook(player, arg, kitchen)
end
end)
game:GetService("Players").PlayerRemoving:Connect(function(player)
lastAction[player] = nil
end)
end
return HomeService
]=])
a("ServerScriptService/Server/Services/InteractionsService",[=[
--!strict
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local Config = require(Shared.Config)
local PlayerData = require(script.Parent.PlayerDataService)
local Notify = require(script.Parent.Notify)
local PURRS = { "Byte purrs in binary. 01110000 01110101 01110010 01110010", "Byte headbutts your hand. Firmware: content.", "Byte's tail LED blinks pink. That means love.", "Byte rolls over. Belly panel slightly warm.", }
local InteractionsService = {}
export type Elevators = { Up: BasePart, Down: BasePart, HomeArrival: CFrame, StreetArrival: CFrame }
local function wireElevator(door: BasePart, arrival: CFrame)
local promptObj = door:FindFirstChild("ElevatorPrompt") :: ProximityPrompt
promptObj.Triggered:Connect(function(player)
local character = player.Character
if not character then return
end
Notify.sfx("Elevator", nil, player)
character:PivotTo(arrival)
end)
end
function InteractionsService.start(vending: BasePart, cat: Model, elevators: Elevators)
wireElevator(elevators.Up, elevators.HomeArrival)
wireElevator(elevators.Down, elevators.StreetArrival)
local buy = vending:FindFirstChild("BuyPrompt") :: ProximityPrompt
buy.ObjectText = `Vending · {Config.NoodleBrickPrice} cr`
buy.Triggered:Connect(function(player)
if PlayerData.spendCredits(player, Config.NoodleBrickPrice) then PlayerData.addItem(player, "Noodles", 1)
Notify.pop(vending, 0.8)
Notify.toast(player, "+1 Noodle Brick", "good")
else
Notify.toast(player, "Not enough credits. Serve a bowl or two!", "nope")
end
end)
local pet = (cat.PrimaryPart :: BasePart):FindFirstChild("PetPrompt") :: ProximityPrompt
local lastPet: { [Player]: number } = {}
pet.Triggered:Connect(function(player)
local now = os.clock()
if (lastPet[player] or 0) + 1.5 > now then return
end
lastPet[player] = now
Notify.pop(cat, 1)
Notify.sfx("Purr", (cat.PrimaryPart :: BasePart).Position)
Notify.toast(player, PURRS[math.random(1, #PURRS)], "info")
end)
end
return InteractionsService
]=])
S:SetAttribute("CozyNext",20)
print("Project Cozy: part 19/41 done. Paste part 20 next.")
