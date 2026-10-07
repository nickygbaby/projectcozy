--!strict
-- The Lantern Row palette: soft "toybox" colors for anything you touch, hot neon for
-- anything that glows. Rule of thumb: cozy colors on surfaces, neon only on light sources.

local function hex(code: string): Color3
	return Color3.fromHex(code)
end

local Palette = {
	-- Night sky & city mass. Deliberately muted and synthetic (Tiny Eden's grey megacity)
	-- so that plants, home and neon are the only saturated things on screen.
	Ink = hex("#0f0e1a"),
	Indigo = hex("#1c1a2c"),
	Violet = hex("#2f2b45"),
	Asphalt = hex("#23212e"),
	Concrete = hex("#43414f"),
	Brick = hex("#4d4757"),
	Steel = hex("#6b6c78"),

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
	LeafDeep = hex("#2f9e5f"),
	SoilDry = hex("#7a6150"),
	Terracotta = hex("#d9825b"),

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
