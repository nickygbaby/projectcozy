-- PROJECT COZY · PART 17 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=17 then warn("Project Cozy: this is part 17, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("ServerScriptService/Server/Services/DistrictBuilder",[=[
return { Root = root, CustomerSpots = spots, StallPot = pot, Vending = vending, Planters = planters, RoboCat = cat, Elevators = { Up = elevatorUp, Down = elevatorDown, HomeArrival = homeArrival, StreetArrival = streetArrival, }, Terminal = apartment.Terminal, Kitchen = apartment.Kitchen, }
end
return DistrictBuilder
]=])
a("ServerScriptService/Server/Services/GardenService",[=[
--!strict
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
if stage == 0 then promptObj.Enabled = true
promptObj.ActionText = "Plant" elseif stage >= RIPE then promptObj.Enabled = true
promptObj.ActionText = "Harvest" elseif thirsty then promptObj.Enabled = true
promptObj.ActionText = "Water"
else
promptObj.Enabled = false
end
end
local function setup(planter: Model)
local soil = planter:FindFirstChild("Soil") :: BasePart
local promptObj = soil:FindFirstChild("GardenPrompt") :: ProximityPrompt
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
if stage == 0 then generation += 1
set(1, true)
Notify.pop(planter, 0.6) -- the client plays the "Pop" sound with every pop
elseif stage < RIPE and thirsty then local myGeneration = generation
set(stage, false)
Notify.sfx("Water", soil.Position)
task.delay(stepTime, function()
if generation ~= myGeneration or not planter.Parent then return
end
local nextStage = stage + 1
set(nextStage, nextStage < RIPE)
end) elseif stage >= RIPE then generation += 1
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
]=])
S:SetAttribute("CozyNext",18)
print("Project Cozy: part 17/41 done. Paste part 18 next.")
