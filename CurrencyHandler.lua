--!strict

export type currencyType<T> = {
	add: (self: any, amount: T) -> T,
	remove: (self: any, amount: T) -> T,
	get: (self: any) -> T,
	updateUi: (self: any) -> ()
}
local currencyInterface = require(game.ReplicatedStorage.Domain.Repositories.CurrencyScaling)
local cache = {}

local module = {}

function module.GetPlayerCurrencyData(player: Player, currencyType: currencyInterface.Currencies): currencyType<number>
	if not cache[player] then
		cache[player] = {}
	end
	if cache[player][currencyType] then
		return cache[player][currencyType]
	end
	local obj = require(script[currencyType]).new(player)
	cache[player][currencyType] = obj
	return obj
end

return module
