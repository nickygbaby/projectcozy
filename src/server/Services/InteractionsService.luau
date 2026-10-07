--!strict
-- Small one-off interactions: the noodle vending machine, Byte the cat and the home elevator.

local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local Config = require(Shared.Config)

local PlayerData = require(script.Parent.PlayerDataService)
local Notify = require(script.Parent.Notify)

local PURRS = {
	"Byte purrs in binary. 01110000 01110101 01110010 01110010",
	"Byte headbutts your hand. Firmware: content.",
	"Byte's tail LED blinks pink. That means love.",
	"Byte rolls over. Belly panel slightly warm.",
}

local InteractionsService = {}

export type Elevators = { Up: BasePart, Down: BasePart, HomeArrival: CFrame, StreetArrival: CFrame }

local function wireElevator(door: BasePart, arrival: CFrame)
	local promptObj = door:FindFirstChild("ElevatorPrompt") :: ProximityPrompt
	promptObj.Triggered:Connect(function(player)
		local character = player.Character
		if not character then
			return
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
		if PlayerData.spendCredits(player, Config.NoodleBrickPrice) then
			PlayerData.addItem(player, "Noodles", 1)
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
		if (lastPet[player] or 0) + 1.5 > now then
			return
		end
		lastPet[player] = now
		Notify.pop(cat, 1)
		Notify.sfx("Purr", (cat.PrimaryPart :: BasePart).Position)
		Notify.toast(player, PURRS[math.random(1, #PURRS)], "info")
	end)
end

return InteractionsService
