-- PROJECT COZY · PART 18 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=18 then warn("Project Cozy: this is part 18, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("ServerScriptService/Server/Services/HomeService",[=[
--!strict
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared.Config)
local ItemsModule = require(Shared.Items)
local Neighbors = require(Shared.Neighbors)
local PlayerData = require(script.Parent.PlayerDataService)
local Notify = require(script.Parent.Notify)
local HomeService = {}
local rng = Random.new()
local lastAction: { [Player]: number } = {}
local function heartsOf(profile: PlayerData.Profile, name: string): number
return profile.Friends[name] or 0
end
local function makeOrder(profile: PlayerData.Profile): PlayerData.Order
local busy = {}
for _, order in profile.Orders do
busy[order.Neighbor] = true
end
local pool = {}
for _, n in Neighbors do
if not busy[n.Name] then table.insert(pool, n)
end
end
if #pool == 0 then pool = Neighbors
end
local neighbor = pool[rng:NextInteger(1, #pool)]
local itemId = neighbor.Likes[rng:NextInteger(1, #neighbor.Likes)]
local item = ItemsModule.Items[itemId]
local count = if item.Jar then rng:NextInteger(1, 2) else rng:NextInteger(2, 4)
local bonus = 1 + Config.Orders.HeartBonus * math.min(heartsOf(profile, neighbor.Name), Config.Orders.MaxBonusHearts)
return { Id = HttpService:GenerateGUID(false), Neighbor = neighbor.Name, Item = itemId, Count = count, Reward = math.floor(item.Value * count * Config.Orders.RewardMultiplier * bonus + 0.5), }
end
local function fillOrders(player: Player, profile: PlayerData.Profile)
while #profile.Orders < Config.Orders.Slots do
table.insert(profile.Orders, makeOrder(profile))
end
PlayerData.sync(player)
end
local function near(player: Player, target: BasePart, range: number): boolean
local character = player.Character
local root = character and character:FindFirstChild("HumanoidRootPart") :: BasePart?
return root ~= nil and (root.Position - target.Position).Magnitude <= range
end
local function deliver(player: Player, profile: PlayerData.Profile, orderId: string, terminal: BasePart)
local index, order = nil, nil
for i, o in profile.Orders do
if o.Id == orderId then index, order = i, o
break
end
end
if not (index and order) then return
end
local item = ItemsModule.Items[order.Item]
if not PlayerData.takeItems(player, { [order.Item] = order.Count }) then Notify.toast(player, `Need {order.Count}x {item.Name}`, "nope")
return
end
table.remove(profile.Orders, index)
profile.Friends[order.Neighbor] = heartsOf(profile, order.Neighbor) + 1
PlayerData.addCredits(player, order.Reward)
PlayerData.sync(player)
Notify.pop(terminal, 0.6)
Notify.toast(player, `{order.Neighbor}: "Thank you, dear!"  +{order.Reward} cr  ♥`, "good")
task.delay(Config.Orders.RefillSeconds, function()
if PlayerData.get(player) == profile then fillOrders(player, profile)
end
end)
end
local function cook(player: Player, recipeId: string, kitchen: BasePart)
local recipe = nil
for _, r in ItemsModule.HomeRecipes do
if r.Id == recipeId then recipe = r
break
end
end
if not recipe then return
end
if not PlayerData.takeItems(player, recipe.Needs) then Notify.toast(player, `Need {ItemsModule.describeNeeds(recipe.Needs)}`, "nope")
return
end
PlayerData.addItem(player, recipe.Makes, 1)
Notify.pop(kitchen, 0.8)
Notify.sfx("Cook", kitchen.Position)
Notify.toast(player, `+1 {ItemsModule.Items[recipe.Makes].Name} {recipe.Icon}`, "good")
end
]=])
S:SetAttribute("CozyNext",19)
print("Project Cozy: part 18/41 done. Paste part 19 next.")
