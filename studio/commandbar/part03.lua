-- PROJECT COZY · PART 3 of 41 · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
if S:GetAttribute("CozyNext")~=3 then warn("Project Cozy: this is part 3, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end
local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end
a("ReplicatedStorage/Shared/Items",[=[
--!strict
local Palette = require(script.Parent.Palette)
export type Item = { Id: string, Name: string, Color: Color3, Grown: boolean, Jar: boolean, -- cooked at home, Tiny Eden style preserves
Value: number, -- base worth for neighbor orders
}
export type Recipe = { Id: string, Name: string, Icon: string, Price: number, Needs: { [string]: number }, }
local Items: { [string]: Item } = { Noodles = { Id = "Noodles", Name = "Noodle Brick", Color = Palette.Butter, Grown = false, Jar = false, Value = 4, }, Scallion = { Id = "Scallion", Name = "Synth Scallion", Color = Palette.NeonLime, Grown = true, Jar = false, Value = 6, }, Glowshroom = { Id = "Glowshroom", Name = "Glowshroom", Color = Palette.NeonCyan, Grown = true, Jar = false, Value = 8, }, EmberChili = { Id = "EmberChili", Name = "Ember Chili", Color = Palette.NeonRed, Grown = true, Jar = false, Value = 12, }, PickledScallion = { Id = "PickledScallion", Name = "Scallion Pickles", Color = Palette.Mint, Grown = false, Jar = true, Value = 18, }, GlowJam = { Id = "GlowJam", Name = "Glowshroom Jam", Color = Palette.Sky, Grown = false, Jar = true, Value = 24, }, ChiliOil = { Id = "ChiliOil", Name = "Ember Chili Oil", Color = Palette.Coral, Grown = false, Jar = true, Value = 34, }, }
local ItemOrder = { "Noodles", "Scallion", "Glowshroom", "EmberChili", "PickledScallion", "GlowJam", "ChiliOil" }
export type HomeRecipe = { Id: string, Makes: string, Icon: string, Needs: { [string]: number } }
local HomeRecipes: { HomeRecipe } = { { Id = "Pickle", Makes = "PickledScallion", Icon = "🥒", Needs = { Scallion = 2 } }, { Id = "Jam", Makes = "GlowJam", Icon = "🫙", Needs = { Glowshroom = 2 } }, { Id = "Oil", Makes = "ChiliOil", Icon = "🌶️", Needs = { EmberChili = 2, Scallion = 1 } }, }
local Recipes: { [string]: Recipe } = { NeonShoyu = { Id = "NeonShoyu", Name = "Neon Shoyu", Icon = "🍜", Price = 18, Needs = { Noodles = 1, Scallion = 1 }, }, GlowMiso = { Id = "GlowMiso", Name = "Glow Miso", Icon = "🍄", Price = 24, Needs = { Noodles = 1, Glowshroom = 1 }, }, ChromeChili = { Id = "ChromeChili", Name = "Chrome Chili", Icon = "🌶️", Price = 40, Needs = { Noodles = 1, Scallion = 1, EmberChili = 1 }, }, }
local RecipeOrder = { "NeonShoyu", "GlowMiso", "ChromeChili" }
local function describeNeeds(needs: { [string]: number }): string
local parts = {}
for _, id in ItemOrder do
local count = needs[id]
if count then table.insert(parts, `{count}x {Items[id].Name}`)
end
end
return table.concat(parts, ", ")
end
return { Items = Items, ItemOrder = ItemOrder, Recipes = Recipes, RecipeOrder = RecipeOrder, HomeRecipes = HomeRecipes, describeNeeds = describeNeeds, }
]=])
S:SetAttribute("CozyNext",4)
print("Project Cozy: part 3/41 done. Paste part 4 next.")
