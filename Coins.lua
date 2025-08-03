--!strict
local profile = require(game.ServerStorage.ServicesServer.Profile)
local eventsFolder = game.ReplicatedStorage.Events.Currency
local coins = {}
coins.__index = coins

local function saveCoins(player: Player, amount: number)
	profile:setValue(player, "Coins", amount)
end

function coins.new(player: Player)
	local self = setmetatable({}, coins)
	local data = profile:getData(player)
	self.player = player
	self.amount = data.Coins
	return self
end

function coins:add(amount: number): number?
	if amount <= 0 then return nil end
	self.amount += amount
	saveCoins(self.player, self.amount)
	eventsFolder.UpdateUiCoins:FireClient(self.player, self.amount)
	return self.amount
end

function coins:remove(amount: number): number?
	if amount <= 0 then return nil end
	self.amount -= amount
	if self.amount < 0 then self.amount = 0 end
	saveCoins(self.player, self.amount)
	eventsFolder.UpdateUiCoins:FireClient(self.player, self.amount)
	return self.amount
end

function coins:updateUi(): ()
	eventsFolder.UpdateUiCoins:FireClient(self.player, self.amount)
end

function coins:get(): number?
	return self.amount
end

return coins
