-- PROJECT COZY · PART 5 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=5 then warn("Project Cozy: this is part 5, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("ReplicatedStorage/Shared/Juice",[=[
model:ScaleTo(base * math.max(0.02, 1 + x))
end, finish = function()
if onDone then onDone()
end
end, }
ensureLoop()
end
function Juice.hop(model: Model, height: number?)
local h = height or 3
local existing = active[model]
if existing then existing.finish()
active[model] = nil
end
local start = model:GetPivot()
local spring = newSpring(BOUNCE.stiffness * 0.5, BOUNCE.damping * 0.6)
spring.v = h * 9
active[model] = { spring = spring, apply = function(x)
model:PivotTo(start + Vector3.new(0, math.max(0, x), 0))
end, finish = function()
model:PivotTo(start)
end, }
ensureLoop()
end
Juice.newSpring = newSpring
Juice.stepSpring = stepSpring
return Juice
]=])
a("ReplicatedStorage/Shared/Neighbors",[=[
--!strict
export type Neighbor = { Name: string, Floor: string, Blurb: string, Likes: { string }, -- item ids they ask for
}
local Neighbors: { Neighbor } = { { Name = "Mrs. Oda", Floor = "4F", Blurb = "Retired netrunner. Still hacks her toaster.", Likes = { "GlowJam", "Glowshroom", "PickledScallion" }, }, { Name = "Kiko", Floor = "12F", Blurb = "Courier. Always running, always hungry.", Likes = { "Scallion", "ChiliOil", "Noodles" }, }, { Name = "Rook", Floor = "9F", Blurb = "Ex chrome-boxer who took up knitting.", Likes = { "EmberChili", "ChiliOil" }, }, { Name = "Lumi", Floor = "21F", Blurb = "Hacker. Only eats things that glow.", Likes = { "Glowshroom", "GlowJam" }, }, { Name = "Grandpa Tetsu", Floor = "2F", Blurb = "Remembers when the sky was blue.", Likes = { "PickledScallion", "Scallion", "GlowJam" }, }, { Name = "Ami & Yui", Floor = "15F", Blurb = "Twin streamers. Want everything 'aesthetic'.", Likes = { "GlowJam", "ChiliOil", "Glowshroom" }, }, }
return Neighbors
]=])
a("ReplicatedStorage/Shared/Palette",[=[
--!strict
local function hex(code: string): Color3
return Color3.fromHex(code)
end
local Palette = { Ink = hex("#0f0e1a"), Indigo = hex("#1c1a2c"), Violet = hex("#2f2b45"), Asphalt = hex("#23212e"), Concrete = hex("#43414f"), Brick = hex("#4d4757"), Steel = hex("#6b6c78"), Cream = hex("#fff1d6"), Peach = hex("#ffb59e"), Coral = hex("#ff8a80"), Mint = hex("#9ff2c4"), Sky = hex("#9fd8ff"), Butter = hex("#ffe38a"), Lilac = hex("#c7b3ff"), Wood = hex("#8a5a44"), Soil = hex("#3b2a2a"), Leaf = hex("#5fd38a"), LeafDeep = hex("#2f9e5f"), SoilDry = hex("#7a6150"), Terracotta = hex("#d9825b"), NeonPink = hex("#ff4fa3"), NeonCyan = hex("#3ff0ff"), NeonLime = hex("#b6ff5a"), NeonAmber = hex("#ffb347"), NeonPurple = hex("#a970ff"), NeonRed = hex("#ff3b5c"), }
Palette.NeonSet = { Palette.NeonPink, Palette.NeonCyan, Palette.NeonLime, Palette.NeonAmber, Palette.NeonPurple, }
Palette.ToySet = { Palette.Cream, Palette.Peach, Palette.Coral, Palette.Mint, Palette.Sky, Palette.Butter, Palette.Lilac, }
return Palette
]=])
S:SetAttribute("CozyNext",6)
print("Project Cozy: part 5/41 done. Paste part 6 next.")
