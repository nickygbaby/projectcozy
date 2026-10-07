-- PROJECT COZY · PART 21 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=21 then warn("Project Cozy: this is part 21, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("ServerScriptService/Server/Services/PlayerDataService",[=[
--!strict
local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local Config = require(Shared.Config)
local ItemsModule = require(Shared.Items)
export type Order = { Id: string, Neighbor: string, Item: string, Count: number, Reward: number }
export type Profile = { Credits: number, Inventory: { [string]: number }, Stats: { Served: number, Harvested: number }, Orders: { Order }, Friends: { [string]: number }, -- neighbor name -> hearts
}
local PlayerDataService = {}
local profiles: { [Player]: Profile } = {}
local canSave: { [Player]: boolean } = {}
local store: DataStore? = nil
do
local ok, result = pcall(function()
return DataStoreService:GetDataStore(Config.DataStoreName)
end)
if ok then store = result
else
warn("[PlayerData] DataStore unavailable, progress will not save:", result)
end
end
local function defaultProfile(): Profile
local inventory = {}
for id in ItemsModule.Items do
inventory[id] = Config.StartingInventory[id] or 0
end
return { Credits = Config.StartingCredits, Inventory = inventory, Stats = { Served = 0, Harvested = 0 }, Orders = {}, Friends = {}, }
end
local function reconcile(saved: any): Profile
local profile = defaultProfile()
if typeof(saved) ~= "table" then return profile
end
if typeof(saved.Credits) == "number" then profile.Credits = saved.Credits
end
if typeof(saved.Inventory) == "table" then for id in profile.Inventory do
if typeof(saved.Inventory[id]) == "number" then profile.Inventory[id] = saved.Inventory[id]
end
end
end
if typeof(saved.Stats) == "table" then profile.Stats.Served = tonumber(saved.Stats.Served) or 0
profile.Stats.Harvested = tonumber(saved.Stats.Harvested) or 0
end
if typeof(saved.Orders) == "table" then for _, order in saved.Orders do
if
typeof(order) == "table" and typeof(order.Id) == "string" and ItemsModule.Items[order.Item] and typeof(order.Count) == "number" and typeof(order.Reward) == "number" and typeof(order.Neighbor) == "string" then table.insert(profile.Orders, order)
end
end
end
if typeof(saved.Friends) == "table" then for name, hearts in saved.Friends do
if typeof(name) == "string" and typeof(hearts) == "number" then profile.Friends[name] = hearts
end
end
end
return profile
end
local function keyFor(player: Player): string
return `player_{player.UserId}`
end
local function mirror(player: Player, profile: Profile)
player:SetAttribute("Credits", profile.Credits)
for id, count in profile.Inventory do
player:SetAttribute(`Inv_{id}`, count)
end
player:SetAttribute("Orders", HttpService:JSONEncode(profile.Orders))
player:SetAttribute("Friends", HttpService:JSONEncode(profile.Friends))
end
local loadedCallbacks: { (Player, Profile) -> () } = {}
local function load(player: Player)
local saved = nil
local loaded = store == nil -- nothing to load means nothing to protect
if store then for attempt = 1, 3 do
local ok, result = pcall(function()
return (store :: DataStore):GetAsync(keyFor(player))
end)
if ok then saved = result
loaded = true
break
end
warn(`[PlayerData] Load attempt {attempt} failed for {player.Name}:`, result)
task.wait(attempt)
end
end
if player.Parent == nil then return
end
local profile = reconcile(saved)
profiles[player] = profile
canSave[player] = loaded and store ~= nil
mirror(player, profile)
]=])
S:SetAttribute("CozyNext",22)
print("Project Cozy: part 21/41 done. Paste part 22 next.")
