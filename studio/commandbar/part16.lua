-- PROJECT COZY · PART 16 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=16 then warn("Project Cozy: this is part 16, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("ServerScriptService/Server/Services/DistrictBuilder",[=[
neon( home, "FridgeLED", Vector3.new(0.3, 0.3, 0.1), CFrame.new(-0.7, y0 + 5.2, zBack - 2.55), Palette.NeonLime )
fridge:SetAttribute("SoundKey", "Fridge")
fridge:AddTag("AudioEmitter")
cylinder(home, "Kettle", 0.9, 0.9, Vector3.new(-6, y0 + 3.95, zBack - 1.4), Palette.Coral)
for _, pos in { Vector3.new(-6.5, y0 + 8.4, cz - 2), Vector3.new(3.5, y0 + 8.4, cz - 3) } do
local hanger = make("Model", { Name = "HangingPlant" }, home)
local potPart = part( hanger, "Pot", Vector3.new(1.4, 1, 1.4), CFrame.new(pos), Palette.Terracotta, { CanCollide = false } )
hanger.PrimaryPart = potPart
for k = 0, 4 do
local a = k * math.pi * 2 / 5
part( hanger, "Vine", Vector3.new(0.35, 2.2 + (k % 2), 0.35), CFrame.new(pos + Vector3.new(math.cos(a) * 0.6, -1.4 - (k % 2) * 0.5, math.sin(a) * 0.6)), Palette.LeafDeep, { CanCollide = false } )
end
hanger:SetAttribute("BobAmplitude", 0.05)
hanger:SetAttribute("BobSpeed", 0.9)
hanger:AddTag("Bob")
end
cylinder(home, "CatBed", 0.6, 2.6, Vector3.new(-6.5, y0 + 0.5, cz - 1.5), Palette.Coral)
local down = neon( home, "ElevatorDown", Vector3.new(0.2, 6, 3), CFrame.new(x1 - 0.7, y0 + 3, 24.6), Palette.NeonCyan )
down.Transparency = 0.5
sign( home, "↓ STREET", Vector2.new(3, 0.8), Vector3.new(x1 - 0.75, y0 + 6.7, 24.6), Vector3.new(-1, 0, 0), Palette.NeonCyan )
local homeArrival = CFrame.lookAt(Vector3.new(2, y0 + 3, 26), Vector3.new(2, y0 + 3, zFront))
return { Planters = planters, Down = down, HomeArrival = homeArrival, Terminal = terminal, Kitchen = counterTop, }
end
local function buildElevatorUp(root: Model): (BasePart, CFrame)
local model = make("Model", { Name = "ElevatorStreet" }, root)
part(model, "Frame", Vector3.new(3.4, 7, 0.4), CFrame.new(-10.2, SIDEWALK_Y + 3.5, 21.8), Palette.Steel)
local door = neon( model, "ElevatorUp", Vector3.new(3, 6, 0.2), CFrame.new(-10.2, SIDEWALK_Y + 3, 21.5), Palette.NeonCyan, 8 )
door.Transparency = 0.5
sign( model, "↑ HOME", Vector2.new(3, 0.8), Vector3.new(-10.2, SIDEWALK_Y + 7.4, 21.5), Vector3.new(0, 0, -1), Palette.NeonCyan )
local arrival = CFrame.lookAt(Vector3.new(-10.2, SIDEWALK_Y + 3, 18), Vector3.new(-10.2, SIDEWALK_Y + 3, 10))
return door, arrival
end
local DistrictBuilder = {}
function DistrictBuilder.build(): District
local existing = workspace:FindFirstChild("LanternRow")
if existing then existing:Destroy()
end
local root = make("Model", { Name = "LanternRow" }) :: Model
buildGround(root)
buildSkyline(root)
local pot, spots = buildStall(root)
local vending = buildVending(root)
local cat = buildRoboCat(root)
local planters = buildGarden(root)
local apartment = buildApartment(root)
local elevatorDown, homeArrival = apartment.Down, apartment.HomeArrival
for _, planter in apartment.Planters do
table.insert(planters, planter)
end
local elevatorUp, streetArrival = buildElevatorUp(root)
pot:SetAttribute("SoundKey", "BrothSimmer")
pot:AddTag("AudioEmitter")
vending:SetAttribute("SoundKey", "VendingHum")
vending:AddTag("AudioEmitter")
prompt(elevatorUp, "Go home", "Elevator", { Name = "ElevatorPrompt" })
prompt(elevatorDown, "Go down", "Elevator", { Name = "ElevatorPrompt" })
prompt(vending, "Buy Noodle Brick", "Vending", { Name = "BuyPrompt" })
prompt(cat.PrimaryPart :: BasePart, "Pet", "Byte", { Name = "PetPrompt", MaxActivationDistance = 7 })
root.Parent = workspace
]=])
S:SetAttribute("CozyNext",17)
print("Project Cozy: part 16/41 done. Paste part 17 next.")
