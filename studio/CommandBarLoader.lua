-- PROJECT COZY · ONE-PASTE LOADER
-- 1. Open a place in Studio. 2. View > Command Bar. 3. Paste ALL of this, press Enter.
-- Downloads every script from GitHub and installs it. Safe to run again (replaces old install).
local H = game:GetService("HttpService")
local was = H.HttpEnabled
H.HttpEnabled = true
local B = "https://raw.githubusercontent.com/nickygbaby/projectcozy/refs/heads/claude/optimistic-brown-aklke8/"
local ok, err = pcall(function()
	local m = H:JSONDecode(H:GetAsync(B .. "studio/manifest.json", true))
	-- Download everything first, so a failed download changes nothing.
	local src = {}
	for i, f in m.files do
		src[i] = H:GetAsync(B .. f.src, true)
	end
	local RS = game:GetService("ReplicatedStorage")
	local S = game:GetService("ServerScriptService")
	local SP = game:GetService("StarterPlayer")
	for _, p in { { RS, "Shared" }, { RS, "Remotes" }, { S, "Server" }, { SP.StarterPlayerScripts, "Client" } } do
		local o = p[1]:FindFirstChild(p[2])
		if o then
			o:Destroy()
		end
	end
	local function dir(path)
		local node = game
		for _, n in string.split(path, "/") do
			local c = node:FindFirstChild(n)
			if not c then
				c = Instance.new("Folder")
				c.Name = n
				c.Parent = node
			end
			node = c
		end
		return node
	end
	for i, f in m.files do
		local s = Instance.new(f.class)
		s.Name = f.name
		s.Source = src[i]
		s.Parent = dir(f.parent)
	end
	local rem = Instance.new("Folder")
	rem.Name = "Remotes"
	for _, n in m.remotes do
		Instance.new("RemoteEvent", rem).Name = n
	end
	rem.Parent = RS
	pcall(function()
		game:GetService("Lighting").Technology = Enum.Technology.Future
	end)
	local b = workspace:FindFirstChild("Baseplate")
	if b then
		b:Destroy()
	end
	print("Project Cozy: installed " .. #m.files .. " scripts. Press Play!")
end)
H.HttpEnabled = was
if not ok then
	warn("Project Cozy: install failed: " .. tostring(err))
end
