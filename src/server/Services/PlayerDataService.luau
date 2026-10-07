--!strict
-- Owns each player's credits and inventory. Saves to DataStore and mirrors values onto
-- player attributes ("Credits", "Inv_<ItemId>", plus JSON "Orders"/"Friends") so the client
-- UI can read them for free.

local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local Config = require(Shared.Config)
local ItemsModule = require(Shared.Items)

export type Order = { Id: string, Neighbor: string, Item: string, Count: number, Reward: number }

export type Profile = {
	Credits: number,
	Inventory: { [string]: number },
	Stats: { Served: number, Harvested: number },
	Orders: { Order },
	Friends: { [string]: number }, -- neighbor name -> hearts
}

local PlayerDataService = {}

local profiles: { [Player]: Profile } = {}
-- If a load fails we still let the player play, but never save over their real data.
local canSave: { [Player]: boolean } = {}

local store: DataStore? = nil
do
	local ok, result = pcall(function()
		return DataStoreService:GetDataStore(Config.DataStoreName)
	end)
	if ok then
		store = result
	else
		warn("[PlayerData] DataStore unavailable, progress will not save:", result)
	end
end

local function defaultProfile(): Profile
	local inventory = {}
	for id in ItemsModule.Items do
		inventory[id] = Config.StartingInventory[id] or 0
	end
	return {
		Credits = Config.StartingCredits,
		Inventory = inventory,
		Stats = { Served = 0, Harvested = 0 },
		Orders = {},
		Friends = {},
	}
end

local function reconcile(saved: any): Profile
	local profile = defaultProfile()
	if typeof(saved) ~= "table" then
		return profile
	end
	if typeof(saved.Credits) == "number" then
		profile.Credits = saved.Credits
	end
	if typeof(saved.Inventory) == "table" then
		for id in profile.Inventory do
			if typeof(saved.Inventory[id]) == "number" then
				profile.Inventory[id] = saved.Inventory[id]
			end
		end
	end
	if typeof(saved.Stats) == "table" then
		profile.Stats.Served = tonumber(saved.Stats.Served) or 0
		profile.Stats.Harvested = tonumber(saved.Stats.Harvested) or 0
	end
	if typeof(saved.Orders) == "table" then
		for _, order in saved.Orders do
			if
				typeof(order) == "table"
				and typeof(order.Id) == "string"
				and ItemsModule.Items[order.Item]
				and typeof(order.Count) == "number"
				and typeof(order.Reward) == "number"
				and typeof(order.Neighbor) == "string"
			then
				table.insert(profile.Orders, order)
			end
		end
	end
	if typeof(saved.Friends) == "table" then
		for name, hearts in saved.Friends do
			if typeof(name) == "string" and typeof(hearts) == "number" then
				profile.Friends[name] = hearts
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
	if store then
		for attempt = 1, 3 do
			local ok, result = pcall(function()
				return (store :: DataStore):GetAsync(keyFor(player))
			end)
			if ok then
				saved = result
				loaded = true
				break
			end
			warn(`[PlayerData] Load attempt {attempt} failed for {player.Name}:`, result)
			task.wait(attempt)
		end
	end

	if player.Parent == nil then
		return
	end
	local profile = reconcile(saved)
	profiles[player] = profile
	canSave[player] = loaded and store ~= nil
	mirror(player, profile)
	for _, callback in loadedCallbacks do
		task.spawn(callback, player, profile)
	end
end

local function save(player: Player)
	local profile = profiles[player]
	if not (profile and store and canSave[player]) then
		return
	end
	local ok, err = pcall(function()
		(store :: DataStore):SetAsync(keyFor(player), profile)
	end)
	if not ok then
		warn(`[PlayerData] Save failed for {player.Name}:`, err)
	end
end

-- Public API -----------------------------------------------------------------

function PlayerDataService.get(player: Player): Profile?
	return profiles[player]
end

function PlayerDataService.addCredits(player: Player, amount: number)
	local profile = profiles[player]
	if not profile then
		return
	end
	profile.Credits = math.max(0, profile.Credits + amount)
	mirror(player, profile)
end

function PlayerDataService.spendCredits(player: Player, amount: number): boolean
	local profile = profiles[player]
	if not profile or profile.Credits < amount then
		return false
	end
	profile.Credits -= amount
	mirror(player, profile)
	return true
end

function PlayerDataService.addItem(player: Player, id: string, count: number)
	local profile = profiles[player]
	if not profile or profile.Inventory[id] == nil then
		return
	end
	profile.Inventory[id] += count
	mirror(player, profile)
end

function PlayerDataService.hasItems(player: Player, needs: { [string]: number }): boolean
	local profile = profiles[player]
	if not profile then
		return false
	end
	for id, count in needs do
		if (profile.Inventory[id] or 0) < count then
			return false
		end
	end
	return true
end

function PlayerDataService.takeItems(player: Player, needs: { [string]: number }): boolean
	if not PlayerDataService.hasItems(player, needs) then
		return false
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
	if profile then
		profile.Stats[stat] += 1
	end
end

-- Call after changing profile.Orders / profile.Friends directly, to push them to the client.
function PlayerDataService.sync(player: Player)
	local profile = profiles[player]
	if profile then
		mirror(player, profile)
	end
end

-- Runs once per player as soon as their profile is ready (including players already loaded).
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
