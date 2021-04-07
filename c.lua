ESX = nil
local paalla = true
local players = {}
local blips = {}
local omaid = GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1)))

Citizen.CreateThread(function()
	while ESX == nil do
		Citizen.Wait(100)
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	end
	while true do
		Citizen.Wait(1)
		if IsControlJustReleased(0, 121) then
			ToggleBlips()
			Citizen.Wait(1500)
		end
	end
end)

function ToggleBlips()
	if paalla then
		for k, v in pairs(blips) do
			if DoesBlipExist(blips[k].id) then
				RemoveBlip(blips[k].id)
			end
		end
		blips = {}
		players = {}
	end
	paalla = not paalla
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1500)
		if paalla then
			ESX.TriggerServerCallback('infinity_blips:fetch', function(data)
				local oldplayers = players
				players = data
				for k, v in pairs(players) do
					if k ~= tostring(omaid) then
						if blips[k] then
							SetBlipCoords(blips[k].id, v.coords)
						else
							local blip = AddBlipForCoord(v.coords)
							SetBlipSprite(blip, 1)
							SetBlipDisplay(blip, 2)
							SetBlipScale(blip, 0.8)
							SetBlipColour(blip, 5)
							SetBlipAsShortRange(blip, true)
							BeginTextCommandSetBlipName('STRING')
							AddTextComponentSubstringPlayerName(players[k].name..' [ID: '..k..']')
							EndTextCommandSetBlipName(blip)
							blips[k] = {["id"] = blip}
						end
						oldplayers[k] = nil
					end
				end
				for k, v in pairs(oldplayers) do
					if blips[k] then
						if DoesBlipExist(blips[k].id) then
							RemoveBlip(blips[k].id)
						end
					end
				end
			end)
		end
	end
end)
