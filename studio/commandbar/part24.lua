-- PROJECT COZY · PART 24 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=24 then warn("Project Cozy: this is part 24, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("ServerScriptService/Server/Services/StallService",[=[
local bar = Instance.new("Frame")
bar.Name = "Patience"
bar.AnchorPoint = Vector2.new(0.5, 0)
bar.Position = UDim2.new(0.5, 0, 1, 4)
bar.Size = UDim2.new(0.7, 0, 0, 5)
bar.BackgroundColor3 = Palette.NeonLime
bar.BorderSizePixel = 0
bar.Parent = bubble
local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(1, 0)
barCorner.Parent = bar
gui.Parent = model.PrimaryPart
end
local function leave(spotIndex: number, model: Model, mood: "happy" | "sad")
if occupied[spotIndex] ~= model then return
end
occupied[spotIndex] = nil
model:SetAttribute("Mood", mood)
local promptObj = model:FindFirstChildWhichIsA("ProximityPrompt", true)
if promptObj then promptObj.Enabled = false
end
task.delay(1.4, function()
model:Destroy()
end)
end
local function spawnCustomer(spotIndex: number, seat: CFrame, pot: BasePart)
local recipeId = ItemsModule.RecipeOrder[rng:NextInteger(1, #ItemsModule.RecipeOrder)]
local recipe = ItemsModule.Recipes[recipeId]
local name = NAMES[rng:NextInteger(1, #NAMES)]
local model = buildCustomer(seat)
model:SetAttribute("Recipe", recipeId)
model:SetAttribute("Patience", Config.CustomerPatienceSeconds)
model:SetAttribute("SpawnedAt", workspace:GetServerTimeNow())
orderBubble(model, recipe, name)
local promptObj = Instance.new("ProximityPrompt")
promptObj.ActionText = `Serve {recipe.Name}`
promptObj.ObjectText = name
promptObj.HoldDuration = 0.4
promptObj.MaxActivationDistance = 9
promptObj.RequiresLineOfSight = false
promptObj.Parent = model.PrimaryPart
local spawnedAt = os.clock()
promptObj.Triggered:Connect(function(player)
if occupied[spotIndex] ~= model then return
end
if not PlayerData.takeItems(player, recipe.Needs) then Notify.toast(player, `Need {ItemsModule.describeNeeds(recipe.Needs)}`, "nope")
return
end
local waited = os.clock() - spawnedAt
local patienceLeft = math.clamp(1 - waited / Config.CustomerPatienceSeconds, 0, 1)
local tip = math.floor(recipe.Price * Config.MaxTipFraction * patienceLeft + 0.5)
PlayerData.addCredits(player, recipe.Price + tip)
PlayerData.bumpStat(player, "Served")
Notify.pop(pot, 1.2)
local thanks = GREETINGS[rng:NextInteger(1, #GREETINGS)]
Notify.toast( player, `{name}: "{thanks}"  +{recipe.Price} cr` .. (if tip > 0 then ` (+{tip} tip)` else ""), "good" )
leave(spotIndex, model, "happy")
end)
model:AddTag("Customer")
model:AddTag("Bob")
model.Parent = workspace
occupied[spotIndex] = model
task.delay(Config.CustomerPatienceSeconds, function()
leave(spotIndex, model, "sad")
end)
end
function StallService.start(spots: { CFrame }, pot: BasePart)
task.spawn(function()
while true do
local range = Config.CustomerSpawnInterval
task.wait(rng:NextNumber(range.Min, range.Max))
if #Players:GetPlayers() == 0 then continue
end
local free = {}
for i in spots do
if not occupied[i] then table.insert(free, i)
end
end
if #free > 0 then local i = free[rng:NextInteger(1, #free)]
spawnCustomer(i, spots[i], pot)
end
end
end)
end
return StallService
]=])
S:SetAttribute("CozyNext",25)
print("Project Cozy: part 24/41 done. Paste part 25 next.")
