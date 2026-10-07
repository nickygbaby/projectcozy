"""Package src/ into small numbered snippets for Roblox Studio's Command Bar.

The Command Bar silently truncates long pastes (we saw only the last ~5,200 characters of an
83 KB paste run), so each part is kept under LIMIT characters. Part 1 creates every
script empty; the remaining parts append source in order. Each part refuses to run out of
order, so a skipped or doubled paste can't corrupt a script.

Usage: python3 studio/build_commandbar.py .
"""
import json
import os
import sys

LIMIT = 4000
root = sys.argv[1] if len(sys.argv) > 1 else "."
out_dir = os.path.join(root, "studio", "commandbar")


def scripts():
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
    return entries


JOIN_AFTER = ("(", "{", "[", ",", "=", "..", "+", "-", "*", "/", " and", " or", " then", " else")
JOIN_BEFORE = (")", "}", "]", "..", "*", "/", "+ ", "and ", "or ", "then", "else ", "elseif")


def minify(src):
    # Safe because no source file uses long-bracket strings or multi-line strings:
    # drop indentation, blank lines and whole-line comments (keep --!strict), then glue
    # lines that are only split for formatting (inside brackets / around operators).
    out = []
    for line in src.splitlines():
        s = line.strip()
        if not s:
            continue
        if s.startswith("--") and not s.startswith("--!"):
            continue
        prev = out[-1] if out else ""
        if out and "--" not in prev and (prev.endswith(JOIN_AFTER) or s.startswith(JOIN_BEFORE)):
            # "if ... then" / "else" lines are statement boundaries too; a space keeps them valid.
            out[-1] = prev + " " + s
        else:
            out.append(s)
    return "\n".join(out) + "\n"


def bracket(text):
    level = 1
    while ("]" + "=" * level + "]") in text:
        level += 1
    eq = "=" * level
    return f"[{eq}[\n{text}]{eq}]"


entries = scripts()
for rel, *_ in entries:
    body = open(os.path.join(root, rel)).read()
    assert "[[" not in body and "[=" not in body, f"{rel}: long brackets break minify()"

# Split every script into line-aligned pieces small enough for one part.
PIECE = LIMIT - 600  # room for the per-part header/footer
pieces = []  # (path, text)
for rel, parent, name, cls in entries:
    text = minify(open(os.path.join(root, rel)).read())
    cur = ""
    for line in text.splitlines(keepends=True):
        if len(cur) + len(line) > PIECE and cur:
            pieces.append((f"{parent}/{name}", cur))
            cur = ""
        cur += line
    if cur:
        pieces.append((f"{parent}/{name}", cur))

# Pack pieces into parts.
groups = []
cur, size = [], 0
for path, text in pieces:
    cost = len(text) + len(path) + 30
    if cur and size + cost > PIECE:
        groups.append(cur)
        cur, size = [], 0
    cur.append((path, text))
    size += cost
if cur:
    groups.append(cur)

total = len(groups) + 1

setup_rows = ",".join(f'{{"{parent}","{name}","{cls}"}}' for _, parent, name, cls in entries)
part1 = f"""-- PROJECT COZY · PART 1 of {total} · paste into View > Command Bar, press Enter
local S=game:GetService("ServerScriptService")
local RS=game:GetService("ReplicatedStorage")
local SP=game:GetService("StarterPlayer")
for _,p in {{{{RS,"Shared"}},{{RS,"Remotes"}},{{S,"Server"}},{{SP.StarterPlayerScripts,"Client"}}}} do local o=p[1]:FindFirstChild(p[2]) if o then o:Destroy() end end
local function dir(path) local node=game for _,n in string.split(path,"/") do local c=node:FindFirstChild(n) if not c then c=Instance.new("Folder") c.Name=n c.Parent=node end node=c end return node end
for _,r in {{{setup_rows}}} do local s=Instance.new(r[3]) s.Name=r[2] s.Disabled=(r[3]~="ModuleScript") s.Parent=dir(r[1]) end
local rem=Instance.new("Folder") rem.Name="Remotes"
for _,n in {{"Toast","Pop","Sfx","HomeAction"}} do local e=Instance.new("RemoteEvent") e.Name=n e.Parent=rem end
rem.Parent=RS
pcall(function() game:GetService("Lighting").Technology=Enum.Technology.Future end)
local b=workspace:FindFirstChild("Baseplate") if b then b:Destroy() end
S:SetAttribute("CozyNext",2)
print("Project Cozy: part 1/{total} done. Paste part 2 next.")
"""
assert "Disabled" in part1

os.makedirs(out_dir, exist_ok=True)
for f in os.listdir(out_dir):
    os.remove(os.path.join(out_dir, f))
parts = [part1]
for i, group in enumerate(groups, start=2):
    lines = [
        f"-- PROJECT COZY · PART {i} of {total} · paste into View > Command Bar, press Enter",
        'local S=game:GetService("ServerScriptService")',
        f'if S:GetAttribute("CozyNext")~={i} then warn("Project Cozy: this is part {i}, but part "..tostring(S:GetAttribute("CozyNext") or 1).." is next") return end',
        'local function a(p,s) local o=game for _,n in string.split(p,"/") do o=o:FindFirstChild(n) end o.Source=o.Source..s end',
    ]
    for path, text in group:
        lines.append(f'a("{path}",{bracket(text)})')
    if i == total:
        lines.append(
            'for _,d in S.Server:GetDescendants() do if d:IsA("Script") then d.Disabled=false end end '
            'for _,d in game:GetService("StarterPlayer").StarterPlayerScripts.Client:GetDescendants() do if d:IsA("LocalScript") then d.Disabled=false end end'
        )
        lines.append('S:SetAttribute("CozyNext",nil)')
        lines.append(f'print("Project Cozy: all {total} parts installed! Press Play.")')
    else:
        lines.append(f'S:SetAttribute("CozyNext",{i + 1})')
        lines.append(f'print("Project Cozy: part {i}/{total} done. Paste part {i + 1} next.")')
    parts.append("\n".join(lines) + "\n")

for i, p in enumerate(parts, start=1):
    assert len(p) <= LIMIT, (i, len(p))
    with open(os.path.join(out_dir, f"part{i:02d}.lua"), "w") as fh:
        fh.write(p)
print(f"{total} parts, largest {max(len(p) for p in parts)} chars, total {sum(len(p) for p in parts)}")

# Manifest for the one-paste HTTP loader (studio/CommandBarLoader.lua).
manifest = {
    "remotes": ["Toast", "Pop", "Sfx", "HomeAction"],
    "files": [{"src": rel, "parent": parent, "name": name, "class": cls} for rel, parent, name, cls in entries],
}
with open(os.path.join(root, "studio", "manifest.json"), "w") as fh:
    json.dump(manifest, fh, indent=1)
    fh.write("\n")
print("manifest:", len(manifest["files"]), "files")
