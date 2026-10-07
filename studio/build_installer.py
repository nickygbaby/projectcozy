import os, sys
root = sys.argv[1]
# (source file, service path, instance name, class)
entries = []
def add(rel, parent, name, cls):
    entries.append((rel, parent, name, cls))
for f in sorted(os.listdir(f"{root}/src/shared")):
    add(f"src/shared/{f}", "ReplicatedStorage/Shared", f[:-5], "ModuleScript")
add("src/server/Main.server.luau", "ServerScriptService/Server", "Main", "Script")
for f in sorted(os.listdir(f"{root}/src/server/Services")):
    add(f"src/server/Services/{f}", "ServerScriptService/Server/Services", f[:-5], "ModuleScript")
add("src/client/Main.client.luau", "StarterPlayer/StarterPlayerScripts/Client", "Main", "LocalScript")
for f in sorted(os.listdir(f"{root}/src/client/Controllers")):
    add(f"src/client/Controllers/{f}", "StarterPlayer/StarterPlayerScripts/Client/Controllers", f[:-5], "ModuleScript")

out = []
out.append('''-- ===========================================================================
-- PROJECT COZY: one-paste installer for Roblox Studio
-- EASIEST: skip this file and open studio/ProjectCozy.rbxlx in Studio instead.
--
-- HOW TO USE (this file is too big for the Command Bar, so install it as a plugin):
--   1. Open a new Baseplate in Studio and delete the "Baseplate" part in Workspace.
--   2. In Explorer, add a Script anywhere (e.g. ServerScriptService) and open it.
--   3. Select all of its text, then paste this ENTIRE file over it.
--   4. Right-click the Script in Explorer -> "Save as Local Plugin...", then Save.
--   5. Plugins tab -> "Project Cozy" -> click "Install". Delete the Script from step 2.
--   6. Press Play.
-- Safe to run again: it replaces the previous install.
-- GENERATED from src/ by studio/build_installer.py. Do not edit by hand.
-- ===========================================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local StarterPlayer = game:GetService("StarterPlayer")
local Lighting = game:GetService("Lighting")

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

local function installAll()
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

local remotes = Instance.new("Folder")
remotes.Name = "Remotes"
for _, name in { "Toast", "Pop", "Sfx" } do
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
out.append('''
print("[ProjectCozy] Installed! Press Play. (If Lighting isn't Future, set Lighting > Technology = Future.)")
end

local pluginRef = (getfenv() :: any).plugin
if pluginRef then
	-- Running as a plugin: only install when the button is clicked.
	if game:GetService("RunService"):IsRunning() then
		return
	end
	local toolbar = pluginRef:CreateToolbar("Project Cozy")
	local button = toolbar:CreateButton("Install", "Install Project Cozy into this place", "")
	button.ClickableWhenViewportHidden = true
	button.Click:Connect(function()
		installAll()
		game:GetService("ChangeHistoryService"):SetWaypoint("Install Project Cozy")
		button:SetActive(false)
	end)
elseif game:GetService("RunService"):IsRunning() then
	warn("[ProjectCozy] This installer is running as a game script. Delete it, then use the plugin or Command Bar.")
else
	installAll()
end
''')
open(f"{root}/studio/InstallProjectCozy.lua","w").write("".join(out))
print(len(entries), "scripts")
