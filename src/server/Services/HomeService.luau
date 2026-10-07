--!strict
-- Tiny Eden's loop at home: neighbors post requests on Neighbor Net, you grow and cook what
-- they want, deliver it from the terminal, and they warm up to you (hearts).
-- Clients only *ask* (HomeAction remote); everything is validated here.

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
	-- Prefer neighbors who don't already have an open request.
	local busy = {}
	for _, order in profile.Orders do
		busy[order.Neighbor] = true
	end
	local pool = {}
	for _, n in Neighbors do
		if not busy[n.Name] then
			table.insert(pool, n)
		end
	end
	if #pool == 0 then
		pool = Neighbors
	end
	local neighbor = pool[rng:NextInteger(1, #pool)]
	local itemId = neighbor.Likes[rng:NextInteger(1, #neighbor.Likes)]
	local item = ItemsModule.Items[itemId]
	local count = if item.Jar then rng:NextInteger(1, 2) else rng:NextInteger(2, 4)
	local bonus = 1
		+ Config.Orders.HeartBonus
			* math.min(heartsOf(profile, neighbor.Name), Config.Orders.MaxBonusHearts)
	return {
		Id = HttpService:GenerateGUID(false),
		Neighbor = neighbor.Name,
		Item = itemId,
		Count = count,
		Reward = math.floor(item.Value * count * Config.Orders.RewardMultiplier * bonus + 0.5),
	}
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
		if o.Id == orderId then
			index, order = i, o
			break
		end
	end
	if not (index and order) then
		return
	end
	local item = ItemsModule.Items[order.Item]
	if not PlayerData.takeItems(player, { [order.Item] = order.Count }) then
		Notify.toast(player, `Need {order.Count}x {item.Name}`, "nope")
		return
	end
	table.remove(profile.Orders, index)
	profile.Friends[order.Neighbor] = heartsOf(profile, order.Neighbor) + 1
	PlayerData.addCredits(player, order.Reward)
	PlayerData.sync(player)
	Notify.pop(terminal, 0.6)
	Notify.toast(player, `{order.Neighbor}: "Thank you, dear!"  +{order.Reward} cr  ♥`, "good")

	-- A fresh request pings in a moment later, like a real message.
	task.delay(Config.Orders.RefillSeconds, function()
		if PlayerData.get(player) == profile then
			fillOrders(player, profile)
		end
	end)
end

local function cook(player: Player, recipeId: string, kitchen: BasePart)
	local recipe = nil
	for _, r in ItemsModule.HomeRecipes do
		if r.Id == recipeId then
			recipe = r
			break
		end
	end
	if not recipe then
		return
	end
	if not PlayerData.takeItems(player, recipe.Needs) then
		Notify.toast(player, `Need {ItemsModule.describeNeeds(recipe.Needs)}`, "nope")
		return
	end
	PlayerData.addItem(player, recipe.Makes, 1)
	Notify.pop(kitchen, 0.8)
	Notify.sfx("Cook", kitchen.Position)
	Notify.toast(player, `+1 {ItemsModule.Items[recipe.Makes].Name} {recipe.Icon}`, "good")
end

function HomeService.start(terminal: BasePart, kitchen: BasePart)
	PlayerData.onLoaded(fillOrders)

	local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("HomeAction") :: RemoteEvent
	remote.OnServerEvent:Connect(function(player, action: any, arg: any)
		-- Light throttle: clients can't spam the remote.
		local now = os.clock()
		if (lastAction[player] or 0) + 0.25 > now then
			return
		end
		lastAction[player] = now

		local profile = PlayerData.get(player)
		if not profile or typeof(arg) ~= "string" then
			return
		end
		if action == "deliver" and near(player, terminal, 16) then
			deliver(player, profile, arg, terminal)
		elseif action == "cook" and near(player, kitchen, 16) then
			cook(player, arg, kitchen)
		end
	end)

	game:GetService("Players").PlayerRemoving:Connect(function(player)
		lastAction[player] = nil
	end)
end

return HomeService
