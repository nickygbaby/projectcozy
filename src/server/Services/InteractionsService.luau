--!strict
-- Small one-off interactions around the street: the noodle vending machine and Byte the cat.

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

function InteractionsService.start(vending: BasePart, cat: Model)
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
		Notify.toast(player, PURRS[math.random(1, #PURRS)], "info")
	end)
end

return InteractionsService
