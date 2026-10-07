--!strict
-- The people in your building. They post requests on Neighbor Net; every delivery makes
-- them a little fonder of you (hearts), and fond neighbors pay a little extra.

export type Neighbor = {
	Name: string,
	Floor: string,
	Blurb: string,
	Likes: { string }, -- item ids they ask for
}

local Neighbors: { Neighbor } = {
	{
		Name = "Mrs. Oda",
		Floor = "4F",
		Blurb = "Retired netrunner. Still hacks her toaster.",
		Likes = { "GlowJam", "Glowshroom", "PickledScallion" },
	},
	{
		Name = "Kiko",
		Floor = "12F",
		Blurb = "Courier. Always running, always hungry.",
		Likes = { "Scallion", "ChiliOil", "Noodles" },
	},
	{
		Name = "Rook",
		Floor = "9F",
		Blurb = "Ex chrome-boxer who took up knitting.",
		Likes = { "EmberChili", "ChiliOil" },
	},
	{
		Name = "Lumi",
		Floor = "21F",
		Blurb = "Hacker. Only eats things that glow.",
		Likes = { "Glowshroom", "GlowJam" },
	},
	{
		Name = "Grandpa Tetsu",
		Floor = "2F",
		Blurb = "Remembers when the sky was blue.",
		Likes = { "PickledScallion", "Scallion", "GlowJam" },
	},
	{
		Name = "Ami & Yui",
		Floor = "15F",
		Blurb = "Twin streamers. Want everything 'aesthetic'.",
		Likes = { "GlowJam", "ChiliOil", "Glowshroom" },
	},
}

return Neighbors
