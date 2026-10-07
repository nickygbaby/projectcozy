-- PROJECT COZY · PART 30 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=30 then warn("Project Cozy: this is part 30, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("StarterPlayer/StarterPlayerScripts/Client/Controllers/AudioController",[=[
sound.Volume = damp(sound.Volume, mix[key] or 0, 1.5, dt)
end
local indoors = zone == "Indoors"
muffle.HighGain = damp(muffle.HighGain, if indoors then -30 else 0, 3, dt)
muffle.MidGain = damp(muffle.MidGain, if indoors then -10 else 0, 3, dt)
end)
SoundService.AmbientReverb = REVERB[zone]
end
return AudioController
]=])
S:SetAttribute("CozyNext",31)
print("Project Cozy: part 30/41 done. Paste part 31 next.")
