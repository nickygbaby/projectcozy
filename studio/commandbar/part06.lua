-- PROJECT COZY · PART 6 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=6 then warn("Project Cozy: this is part 6, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("ReplicatedStorage/Shared/Zones",[=[
--!strict
local Config = require(script.Parent.Config)
local Zones = {}
function Zones.contains(name: string, position: Vector3): boolean
local zone = (Config.Zones :: any)[name]
if not zone then return false
end
local offset = position - zone.Center
local half = zone.Size / 2
return math.abs(offset.X) <= half.X and math.abs(offset.Y) <= half.Y and math.abs(offset.Z) <= half.Z
end
function Zones.at(position: Vector3): string
if Zones.contains("Indoors", position) then return "Indoors" elseif Zones.contains("Home", position) then return "Home" elseif Zones.contains("Rooftop", position) then return "Rooftop"
end
return "Street"
end
return Zones
]=])
a("ServerScriptService/Server/Main",[=[
--!strict
local Services = script.Parent.Services
local AtmosphereService = require(Services.AtmosphereService)
local DistrictBuilder = require(Services.DistrictBuilder)
local PlayerDataService = require(Services.PlayerDataService)
local GardenService = require(Services.GardenService)
local StallService = require(Services.StallService)
local InteractionsService = require(Services.InteractionsService)
local HomeService = require(Services.HomeService)
AtmosphereService.start()
PlayerDataService.start()
local district = DistrictBuilder.build()
GardenService.start(district.Planters)
StallService.start(district.CustomerSpots, district.StallPot)
InteractionsService.start(district.Vending, district.RoboCat, district.Elevators)
HomeService.start(district.Terminal, district.Kitchen)
print("[ProjectCozy] Lantern Row is open. Stay cozy, choom.")
]=])
S:SetAttribute("CozyNext",7)
print("Project Cozy: part 6/41 done. Paste part 7 next.")
