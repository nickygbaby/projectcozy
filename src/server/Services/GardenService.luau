--!strict
-- Planters (rooftop, windowsill, balcony): Plant -> Water -> grow a stage -> soil dries ->
-- Water -> ... -> Harvest. Plants only grow while their soil is wet. This little daily
-- ritual is the heart of Tiny Eden; nothing ever wilts or dies if you forget.
--
-- The server only tracks state on attributes ("Crop", "Stage", "Thirsty"); the client draws
-- the plants, darkens wet soil and does all the bouncing (client/Controllers/PlantVisuals).

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
	local thirsty = planter:GetAttribute("Thirsty") == true
	promptObj.ObjectText = ItemsModule.Items[crop].Name
	if stage == 0 then
		promptObj.Enabled = true
		promptObj.ActionText = "Plant"
	elseif stage >= RIPE then
		promptObj.Enabled = true
		promptObj.ActionText = "Harvest"
	elseif thirsty then
		promptObj.Enabled = true
		promptObj.ActionText = "Water"
	else
		-- Growing: nothing to do but enjoy it.
		promptObj.Enabled = false
	end
end

local function setup(planter: Model)
	local soil = planter:FindFirstChild("Soil") :: BasePart
	local promptObj = soil:FindFirstChild("GardenPrompt") :: ProximityPrompt
	-- Bumped on every replant so an old growth timer can't advance a new crop.
	local generation = 0
	local stepTime = Config.GrowSeconds / (RIPE - 1)

	local function set(stage: number, thirsty: boolean)
		planter:SetAttribute("Stage", stage)
		planter:SetAttribute("Thirsty", thirsty)
		refreshPrompt(planter, promptObj)
	end

	set(planter:GetAttribute("Stage") :: number? or 0, false)

	promptObj.Triggered:Connect(function(player)
		local stage = planter:GetAttribute("Stage") :: number
		local crop = planter:GetAttribute("Crop") :: string
		local thirsty = planter:GetAttribute("Thirsty") == true

		if stage == 0 then
			generation += 1
			set(1, true)
			Notify.pop(planter, 0.6) -- the client plays the "Pop" sound with every pop
		elseif stage < RIPE and thirsty then
			local myGeneration = generation
			set(stage, false)
			Notify.sfx("Water", soil.Position)
			task.delay(stepTime, function()
				if generation ~= myGeneration or not planter.Parent then
					return
				end
				local nextStage = stage + 1
				-- Soil dries out after each growth spurt until the plant is ripe.
				set(nextStage, nextStage < RIPE)
			end)
		elseif stage >= RIPE then
			generation += 1
			set(0, false)
			PlayerData.addItem(player, crop, Config.HarvestYield)
			PlayerData.bumpStat(player, "Harvested")
			Notify.sfx("Harvest", soil.Position)
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
