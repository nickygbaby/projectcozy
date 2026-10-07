--!strict
-- Point-in-box checks for the named areas in Config.Zones (Home, Indoors, Rooftop).

local Config = require(script.Parent.Config)

local Zones = {}

function Zones.contains(name: string, position: Vector3): boolean
	local zone = (Config.Zones :: any)[name]
	if not zone then
		return false
	end
	local offset = position - zone.Center
	local half = zone.Size / 2
	return math.abs(offset.X) <= half.X and math.abs(offset.Y) <= half.Y and math.abs(offset.Z) <= half.Z
end

-- The most specific zone the position is in, for audio/camera: "Indoors" > "Home" >
-- "Rooftop" > "Street".
function Zones.at(position: Vector3): string
	if Zones.contains("Indoors", position) then
		return "Indoors"
	elseif Zones.contains("Home", position) then
		return "Home"
	elseif Zones.contains("Rooftop", position) then
		return "Rooftop"
	end
	return "Street"
end

return Zones
