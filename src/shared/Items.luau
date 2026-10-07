--!strict
-- Ingredients and the dishes they make.

local Palette = require(script.Parent.Palette)

export type Item = {
	Id: string,
	Name: string,
	Color: Color3,
	Grown: boolean,
}

export type Recipe = {
	Id: string,
	Name: string,
	Icon: string,
	Price: number,
	Needs: { [string]: number },
}

local Items: { [string]: Item } = {
	Noodles = { Id = "Noodles", Name = "Noodle Brick", Color = Palette.Butter, Grown = false },
	Scallion = { Id = "Scallion", Name = "Synth Scallion", Color = Palette.NeonLime, Grown = true },
	Glowshroom = { Id = "Glowshroom", Name = "Glowshroom", Color = Palette.NeonCyan, Grown = true },
	EmberChili = { Id = "EmberChili", Name = "Ember Chili", Color = Palette.NeonRed, Grown = true },
}

-- Display order for UI
local ItemOrder = { "Noodles", "Scallion", "Glowshroom", "EmberChili" }

local Recipes: { [string]: Recipe } = {
	NeonShoyu = {
		Id = "NeonShoyu",
		Name = "Neon Shoyu",
		Icon = "🍜",
		Price = 18,
		Needs = { Noodles = 1, Scallion = 1 },
	},
	GlowMiso = {
		Id = "GlowMiso",
		Name = "Glow Miso",
		Icon = "🍄",
		Price = 24,
		Needs = { Noodles = 1, Glowshroom = 1 },
	},
	ChromeChili = {
		Id = "ChromeChili",
		Name = "Chrome Chili",
		Icon = "🌶️",
		Price = 40,
		Needs = { Noodles = 1, Scallion = 1, EmberChili = 1 },
	},
}

local RecipeOrder = { "NeonShoyu", "GlowMiso", "ChromeChili" }

local function describeNeeds(needs: { [string]: number }): string
	local parts = {}
	for _, id in ItemOrder do
		local count = needs[id]
		if count then
			table.insert(parts, `{count}x {Items[id].Name}`)
		end
	end
	return table.concat(parts, ", ")
end

return {
	Items = Items,
	ItemOrder = ItemOrder,
	Recipes = Recipes,
	RecipeOrder = RecipeOrder,
	describeNeeds = describeNeeds,
}
