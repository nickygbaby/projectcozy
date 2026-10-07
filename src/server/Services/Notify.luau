--!strict
-- Tiny wrapper around the client-facing remotes.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Toast = Remotes:WaitForChild("Toast") :: RemoteEvent
local Pop = Remotes:WaitForChild("Pop") :: RemoteEvent

local Notify = {}

-- A little bubble message for one player. `tone` picks the color: "good" | "info" | "nope".
function Notify.toast(player: Player, text: string, tone: string?)
	Toast:FireClient(player, text, tone or "info")
end

-- Ask every client to give an instance a springy bounce.
function Notify.pop(target: Instance, strength: number?)
	Pop:FireAllClients(target, strength or 1)
end

return Notify
