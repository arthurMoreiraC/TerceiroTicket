
local ProfileHandler = {}

local ProfileStore = require(script.ProfileStore)
local profileTemplate = require(game.ReplicatedStorage.Domain.Repositories.ProfileTemplate)

local Players = game:GetService("Players")

local PlayerStore = ProfileStore.New("PlayerStore", profileTemplate)
local Profiles: {[Player]: typeof(PlayerStore:StartSessionAsync())} = {}

local function PlayerAdded(player)
	local profile = PlayerStore:StartSessionAsync(`{player.UserId}`, {
		Cancel = function()
			return player.Parent ~= Players
		end,
	})
	
	if profile ~= nil then
		profile:AddUserId(player.UserId)
		profile:Reconcile()
		
		profile.OnSessionEnd:Connect(function()
			Profiles[player] = nil
			player:Kick(`Profile session end - Please rejoin`)
		end)
		
		if player.Parent == Players then
			Profiles[player] = profile
			print(`Profile loaded for {player.DisplayName}!`)
			
			
		else
			profile:EndSession()
		end
	else
		player:Kick(`Profile load fail - Please rejoin`)
	end
end

for _, player in Players:GetPlayers() do
	task.spawn(PlayerAdded, player)
end

Players.PlayerAdded:Connect(PlayerAdded)

Players.PlayerRemoving:Connect(function(player)
	local profile = Profiles[player]
	if profile ~= nil then
		profile:EndSession()
	end
end)

type Template = typeof(profileTemplate)
type TemplateKeys = keyof<Template>

local function waitForProfile(player: Player)
	local profile = Profiles[player]
	while not profile do
		profile = Profiles[player]
		task.wait()
	end
	return profile
end

function ProfileHandler:getData(player: Player): Template
	local profile = waitForProfile(player)
	return profile.Data
end

function ProfileHandler:setValue(player: Player, key: TemplateKeys, value: any): ()
	local profile = waitForProfile(player)
	profile.Data[key] = value
end

return ProfileHandler
