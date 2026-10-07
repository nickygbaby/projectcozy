--!strict
-- The Lantern Row palette: soft "toybox" colors for anything you touch, hot neon for
-- anything that glows. Rule of thumb: cozy colors on surfaces, neon only on light sources.

local function hex(code: string): Color3
	return Color3.fromHex(code)
end

local Palette = {
	-- Night sky & city mass
	Ink = hex("#0f0c1f"),
	Indigo = hex("#1b1538"),
	Violet = hex("#2e2257"),
	Asphalt = hex("#221d36"),
	Concrete = hex("#3c3558"),
	Brick = hex("#5a3f63"),

	-- Toybox (cozy, matte, rounded)
	Cream = hex("#fff1d6"),
	Peach = hex("#ffb59e"),
	Coral = hex("#ff8a80"),
	Mint = hex("#9ff2c4"),
	Sky = hex("#9fd8ff"),
	Butter = hex("#ffe38a"),
	Lilac = hex("#c7b3ff"),
	Wood = hex("#8a5a44"),
	Soil = hex("#3b2a2a"),
	Leaf = hex("#5fd38a"),

	-- Neon (emissive only)
	NeonPink = hex("#ff4fa3"),
	NeonCyan = hex("#3ff0ff"),
	NeonLime = hex("#b6ff5a"),
	NeonAmber = hex("#ffb347"),
	NeonPurple = hex("#a970ff"),
	NeonRed = hex("#ff3b5c"),
}

Palette.NeonSet = {
	Palette.NeonPink,
	Palette.NeonCyan,
	Palette.NeonLime,
	Palette.NeonAmber,
	Palette.NeonPurple,
}

Palette.ToySet = {
	Palette.Cream,
	Palette.Peach,
	Palette.Coral,
	Palette.Mint,
	Palette.Sky,
	Palette.Butter,
	Palette.Lilac,
}

return Palette
