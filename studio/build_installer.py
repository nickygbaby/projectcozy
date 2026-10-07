import os, sys
root = sys.argv[1]
# (source file, service path, instance name, class)
entries = []
def add(rel, parent, name, cls):
    entries.append((rel, parent, name, cls))
for f in ["Config","Palette","Items","Juice"]:
    add(f"src/shared/{f}.luau", "ReplicatedStorage/Shared", f, "ModuleScript")
add("src/server/Main.server.luau", "ServerScriptService/Server", "Main", "Script")
for f in sorted(os.listdir(f"{root}/src/server/Services")):
    add(f"src/server/Services/{f}", "ServerScriptService/Server/Services", f[:-5], "ModuleScript")
add("src/client/Main.client.luau", "StarterPlayer/StarterPlayerScripts/Client", "Main", "LocalScript")
for f in sorted(os.listdir(f"{root}/src/client/Controllers")):
    add(f"src/client/Controllers/{f}", "StarterPlayer/StarterPlayerScripts/Client/Controllers", f[:-5], "ModuleScript")

out = []
out.append('''-- ===========================================================================
-- PROJECT COZY: one-paste installer for Roblox Studio
-- HOW TO USE:
--   1. Open a new Baseplate in Studio and delete the "Baseplate" part in Workspace.
--   2. View tab -> Command Bar.
--   3. Paste this ENTIRE file into the Command Bar and press Enter.
--   4. Press Play.
-- Safe to run again: it replaces the previous install.
-- GENERATED from src/ by studio/build_installer.py. Do not edit by hand.
-- ===========================================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local StarterPlayer = game:GetService("StarterPlayer")
local Lighting = game:GetService("Lighting")

-- Clean out any previous install
for _, pair in {
	{ ReplicatedStorage, "Shared" },
	{ ReplicatedStorage, "Remotes" },
	{ ServerScriptService, "Server" },
	{ StarterPlayer.StarterPlayerScripts, "Client" },
} do
	local old = pair[1]:FindFirstChild(pair[2])
	if old then
		old:Destroy()
	end
end

local function folder(path: string): Instance
	local node: Instance = game
	for _, name in string.split(path, "/") do
		local child = node:FindFirstChild(name)
		if not child then
			if node == game then
				child = game:GetService(name)
			else
				child = Instance.new("Folder")
				child.Name = name
				child.Parent = node
			end
		end
		node = child
	end
	return node
end

local function install(path: string, name: string, className: string, source: string)
	local s = Instance.new(className)
	s.Name = name
	s.Source = source
	s.Parent = folder(path)
end

local remotes = Instance.new("Folder")
remotes.Name = "Remotes"
for _, name in { "Toast", "Pop" } do
	local r = Instance.new("RemoteEvent")
	r.Name = name
	r.Parent = remotes
end
remotes.Parent = ReplicatedStorage

pcall(function()
	Lighting.Technology = Enum.Technology.Future
end)
''')
for rel, parent, name, cls in entries:
    src = open(f"{root}/{rel}").read()
    level = 1
    while ("]" + "="*level + "]") in src: level += 1
    eq = "="*level
    out.append(f'\ninstall("{parent}", "{name}", "{cls}", [{eq}[\n{src}]{eq}])\n')
out.append('\nprint("[ProjectCozy] Installed! Press Play. (If Lighting isn\'t Future, set Lighting > Technology = Future.)")\n')
open(f"{root}/studio/InstallProjectCozy.lua","w").write("".join(out))
print(len(entries), "scripts")
