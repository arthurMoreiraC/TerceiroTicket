--!strict
local profile = require(game.ServerStorage.ServicesServer.Profile)
local tokens = {}
tokens.__index = tokens

local function saveTokens(player: Player, amount: number)
	profile:setValue(player, "Tokens", amount)
end

function tokens.new(player: Player)
	local self = setmetatable({}, tokens)
	local data = profile:getData(player)
	self.player = player
	self.amount = data.Coins
	return self
end

function tokens:add(amount: number): number?
	if amount <= 0 then return nil end
	self.amount += amount
	saveTokens(self.player, self.amount)
	return self.amount
end

function tokens:remove(amount: number): number?
	if amount <= 0 then return nil end
	self.amount -= amount
	if self.amount < 0 then self.amount = 0 end
	saveTokens(self.player, self.amount)
	return self.amount
end

function tokens:get(): number?
	return self.amount
end

return tokens
