--!strict
-- Rooftop planters: Plant -> (grows through 3 stages) -> Harvest.
-- The server only tracks state on attributes ("Crop", "Stage"); the client draws the plants
-- and does all the bouncing (see client/Controllers/PlantVisuals).

local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local Config = require(Shared.Config)
local ItemsModule = require(Shared.Items)

local PlayerData = require(script.Parent.PlayerDataService)
local Notify = require(script.Parent.Notify)

local RIPE = 3

local GardenService = {}

local function refreshPrompt(planter: Model, promptObj: ProximityPrompt)
	local crop = planter:GetAttribute("Crop") :: string
	local stage = planter:GetAttribute("Stage") :: number
	local name = ItemsModule.Items[crop].Name
	if stage == 0 then
		promptObj.Enabled = true
		promptObj.ActionText = "Plant"
		promptObj.ObjectText = name
	elseif stage >= RIPE then
		promptObj.Enabled = true
		promptObj.ActionText = "Harvest"
		promptObj.ObjectText = name
	else
		promptObj.Enabled = false
	end
end

local function setStage(planter: Model, promptObj: ProximityPrompt, stage: number)
	planter:SetAttribute("Stage", stage)
	refreshPrompt(planter, promptObj)
end

local function setup(planter: Model)
	local soil = planter:FindFirstChild("Soil") :: BasePart
	local promptObj = soil:FindFirstChild("GardenPrompt") :: ProximityPrompt
	-- Bumped on every replant so an old growth timer can't advance a new crop.
	local generation = 0

	refreshPrompt(planter, promptObj)

	promptObj.Triggered:Connect(function(player)
		local stage = planter:GetAttribute("Stage") :: number
		local crop = planter:GetAttribute("Crop") :: string

		if stage == 0 then
			generation += 1
			local myGeneration = generation
			setStage(planter, promptObj, 1)
			Notify.pop(planter, 0.6)
			local stepTime = Config.GrowSeconds / (RIPE - 1)
			for nextStage = 2, RIPE do
				task.delay(stepTime * (nextStage - 1), function()
					if generation == myGeneration and planter.Parent then
						setStage(planter, promptObj, nextStage)
					end
				end)
			end
		elseif stage >= RIPE then
			setStage(planter, promptObj, 0)
			PlayerData.addItem(player, crop, Config.HarvestYield)
			PlayerData.bumpStat(player, "Harvested")
			Notify.toast(player, `+{Config.HarvestYield} {ItemsModule.Items[crop].Name}`, "good")
		end
	end)
end

function GardenService.start(planters: { Model })
	for _, planter in planters do
		setup(planter)
	end
end

return GardenService
