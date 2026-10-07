-- PROJECT COZY · PART 22 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=22 then warn("Project Cozy: this is part 22, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("ServerScriptService/Server/Services/PlayerDataService",[=[
for _, callback in loadedCallbacks do
task.spawn(callback, player, profile)
end
end
local function save(player: Player)
local profile = profiles[player]
if not (profile and store and canSave[player]) then return
end
local ok, err = pcall(function()
(store :: DataStore):SetAsync(keyFor(player), profile)
end)
if not ok then warn(`[PlayerData] Save failed for {player.Name}:`, err)
end
end
function PlayerDataService.get(player: Player): Profile?
return profiles[player]
end
function PlayerDataService.addCredits(player: Player, amount: number)
local profile = profiles[player]
if not profile then return
end
profile.Credits = math.max(0, profile.Credits + amount)
mirror(player, profile)
end
function PlayerDataService.spendCredits(player: Player, amount: number): boolean
local profile = profiles[player]
if not profile or profile.Credits < amount then return false
end
profile.Credits -= amount
mirror(player, profile)
return true
end
function PlayerDataService.addItem(player: Player, id: string, count: number)
local profile = profiles[player]
if not profile or profile.Inventory[id] == nil then return
end
profile.Inventory[id] += count
mirror(player, profile)
end
function PlayerDataService.hasItems(player: Player, needs: { [string]: number }): boolean
local profile = profiles[player]
if not profile then return false
end
for id, count in needs do
if (profile.Inventory[id] or 0) < count then return false
end
end
return true
end
function PlayerDataService.takeItems(player: Player, needs: { [string]: number }): boolean
if not PlayerDataService.hasItems(player, needs) then return false
end
local profile = profiles[player] :: Profile
for id, count in needs do
profile.Inventory[id] -= count
end
mirror(player, profile)
return true
end
function PlayerDataService.bumpStat(player: Player, stat: "Served" | "Harvested")
local profile = profiles[player]
if profile then profile.Stats[stat] += 1
end
end
function PlayerDataService.sync(player: Player)
local profile = profiles[player]
if profile then mirror(player, profile)
end
end
function PlayerDataService.onLoaded(callback: (Player, Profile) -> ())
table.insert(loadedCallbacks, callback)
for player, profile in profiles do
task.spawn(callback, player, profile)
end
end
function PlayerDataService.start()
Players.PlayerAdded:Connect(load)
for _, player in Players:GetPlayers() do
task.spawn(load, player)
end
Players.PlayerRemoving:Connect(function(player)
save(player)
profiles[player] = nil
canSave[player] = nil
end)
game:BindToClose(function()
for _, player in Players:GetPlayers() do
task.spawn(save, player)
end
task.wait(2)
end)
task.spawn(function()
while true do
task.wait(Config.AutosaveSeconds)
for _, player in Players:GetPlayers() do
task.spawn(save, player)
end
end
end)
end
return PlayerDataService
]=])
S:SetAttribute("CozyNext",23)
print("Project Cozy: part 22/41 done. Paste part 23 next.")
