ESX = nil
local players = {}

TriggerEvent('arp:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
	while true do
		local xPlayers = ESX.GetPlayers()
		for k, v in pairs(xPlayers) do
			local c = GetEntityCoords(GetPlayerPed(v))
			local n = GetPlayerName(v)
			players[tostring(v)] = {["coords"] = c, ["name"] = n}
		end
		Citizen.Wait(1500)
	end
end)

AddEventHandler('playerDropped', function()
	if players[tostring(source)] then
		players[tostring(source)] = nil
	end
end)

ESX.RegisterServerCallback('infinity_blips:fetch', function(source, cb)
	cb(players)
end)



