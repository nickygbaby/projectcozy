-- PROJECT COZY · PART 8 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=8 then warn("Project Cozy: this is part 8, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("ServerScriptService/Server/Services/AtmosphereService",[=[
local isDay = clock >= 7 and clock < 17.5
local rate = if isDay then Config.DayRushMultiplier else 1
Lighting.ClockTime = (clock + dt * rate / secondsPerHour) % 24
accumulator += dt
if accumulator < 0.25 then return
end
accumulator = 0
local k = sample(Lighting.ClockTime)
Lighting.Ambient = k.ambient
Lighting.OutdoorAmbient = k.outdoor
Lighting.Brightness = k.brightness
atmosphere.Color = k.haze
atmosphere.Decay = k.decay
atmosphere.Density = k.density
end)
end
return AtmosphereService
]=])
S:SetAttribute("CozyNext",9)
print("Project Cozy: part 8/41 done. Paste part 9 next.")
