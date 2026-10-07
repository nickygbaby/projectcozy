--!strict
-- Server entry point. The server owns state (data, timers, prompts); clients own visuals.

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
