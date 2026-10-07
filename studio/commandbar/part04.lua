-- PROJECT COZY · PART 4 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=4 then warn("Project Cozy: this is part 4, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("ReplicatedStorage/Shared/Juice",[=[
--!strict
local RunService = game:GetService("RunService")
export type Spring = { x: number, v: number, target: number, stiffness: number, damping: number, }
local function newSpring(stiffness: number, damping: number): Spring
return { x = 0, v = 0, target = 0, stiffness = stiffness, damping = damping }
end
local MAX_STEP = 1 / 120
local function stepSpring(s: Spring, dt: number)
while dt > 0 do
local h = math.min(dt, MAX_STEP)
local force = -s.stiffness * (s.x - s.target) - s.damping * s.v
s.v += force * h
s.x += s.v * h
dt -= h
end
end
local function isResting(s: Spring): boolean
return math.abs(s.x - s.target) < 1e-3 and math.abs(s.v) < 1e-3
end
local JELLY = { stiffness = 320, damping = 11 }
local BOUNCE = { stiffness = 260, damping = 14 }
type Anim = { spring: Spring, apply: (x: number) -> (), finish: () -> (), }
local active: { [Instance]: Anim } = {}
local connection: RBXScriptConnection? = nil
local function ensureLoop()
if connection then return
end
connection = RunService.Heartbeat:Connect(function(dt)
for target, anim in active do
if target.Parent == nil then active[target] = nil
continue
end
stepSpring(anim.spring, dt)
if isResting(anim.spring) then active[target] = nil
anim.finish()
else
anim.apply(anim.spring.x)
end
end
if next(active) == nil and connection then connection:Disconnect()
connection = nil
end
end)
end
local Juice = {}
local partRest: { [BasePart]: { size: Vector3, cframe: CFrame } } = setmetatable({}, { __mode = "k" }) :: any
function Juice.squash(part: BasePart, strength: number?)
local existing = active[part]
if existing then existing.spring.v += 6 * (strength or 1)
return
end
local rest = { size = part.Size, cframe = part.CFrame }
partRest[part] = rest
local spring = newSpring(JELLY.stiffness, JELLY.damping)
spring.v = 6 * (strength or 1)
active[part] = { spring = spring, apply = function(x)
local squash = math.clamp(x * 0.35, -0.4, 0.4)
local y = rest.size.Y * (1 - squash)
local xz = 1 + squash * 0.5
part.Size = Vector3.new(rest.size.X * xz, y, rest.size.Z * xz)
part.CFrame = rest.cframe * CFrame.new(0, (y - rest.size.Y) / 2, 0)
end, finish = function()
part.Size = rest.size
part.CFrame = rest.cframe
partRest[part] = nil
end, }
ensureLoop()
end
local function scaleAnim(model: Model, startX: number, velocity: number, preset, onDone: (() -> ())?)
local existing = active[model]
if existing then existing.finish()
active[model] = nil
end
local base = model:GetScale()
local spring = newSpring(preset.stiffness, preset.damping)
spring.x = startX
spring.v = velocity
local function apply(x: number)
model:ScaleTo(base * math.max(0.02, 1 + x))
end
apply(startX)
active[model] = { spring = spring, apply = apply, finish = function()
model:ScaleTo(base)
if onDone then onDone()
end
end, }
ensureLoop()
end
function Juice.pop(target: Instance, strength: number?)
if target:IsA("BasePart") then Juice.squash(target, strength) elseif target:IsA("Model") then scaleAnim(target, 0, 2.5 * (strength or 1), JELLY)
end
end
function Juice.popIn(model: Model)
scaleAnim(model, -0.98, 0, BOUNCE)
end
function Juice.popOut(model: Model, onDone: (() -> ())?)
local existing = active[model]
if existing then existing.finish()
active[model] = nil
end
local base = model:GetScale()
local spring = newSpring(BOUNCE.stiffness, BOUNCE.damping)
spring.v = 2
spring.target = -0.98
active[model] = { spring = spring, apply = function(x)
]=])
S:SetAttribute("CozyNext",5)
print("Project Cozy: part 4/41 done. Paste part 5 next.")
