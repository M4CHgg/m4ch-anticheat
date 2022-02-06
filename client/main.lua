RegisterNetEvent('m4ch-anticheat:hash')
AddEventHandler('m4ch-anticheat:hash', function()
            count = -0.2
                 while not HasModelLoaded(GetHashKey("a_m_o_acult_01")) do
                  Citizen.Wait(0)
                  RequestModel(GetHashKey("a_m_o_acult_01"))
                end
                local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
                local rapist = CreatePed(4, GetHashKey("a_m_o_acult_01"), x,y,z, 0.0, true, false)
                SetEntityAsMissionEntity(rapist, true, true)
                AttachEntityToEntity(rapist, GetPlayerPed(i), 4103, 11816, count, 0.00, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                ClearPedTasks(GetPlayerPed(-1))
                TaskPlayAnim(GetPlayerPed(-1), "rcmpaparazzo_2", "shag_loop_poppy", 2.0, 2.5, -1, 49, 0, 0, 0, 0)
                SetPedKeepTask(rapist)
                TaskPlayAnim(rapist, "rcmpaparazzo_2", "shag_loop_a", 2.0, 2.5, -1, 49, 0, 0, 0, 0)
                SetEntityInvincible(rapist, true)
                count = count - 0.4
end)

RegisterNetEvent('m4ch-anticheat:antiPed')
AddEventHandler('m4ch-anticheat:antiPed', function()
    local peds = ESX.Game.GetPeds()

    for i=1, #peds, 1 do
        if isPedBlacklisted(peds[i]) then
            DeletePed(peds[i])
        end
    end
end)

function isPedBlacklisted(model)
	for _, blacklistedPed in pairs(Config.BlacklistPeds) do
		if GetEntityModel(model) == GetHashKey(blacklistedPed) then
			return true
		end
	end

	return false
end

function ReqAndDelete(object, detach)
	if DoesEntityExist(object) then
		NetworkRequestControlOfEntity(object)
		while not NetworkHasControlOfEntity(object) do
			Citizen.Wait(1)
		end
		if detach then
			DetachEntity(object, 0, false)
		end
		SetEntityCollision(object, false, false)
		SetEntityAlpha(object, 0.0, true)
		SetEntityAsMissionEntity(object, true, true)
		SetEntityAsNoLongerNeeded(object)
		DeleteEntity(object)
	end
end

function isPropBlacklisted(model)
    for _, blacklistedProp in pairs(Config.BlacklistProps) do
        if GetEntityModel(model) == GetHashKey(blacklistedProp) then
			return true
		end
	end

	return false
end

RegisterNetEvent('m4ch-anticheat:AntiVehicle')
AddEventHandler('m4ch-anticheat:AntiVehicle', function()
    local vehicles = ESX.Game.GetVehicles()

    for i=1, #vehicles, 1 do
        if isVehBlacklisted(vehicles[i]) then
            DeleteEntity(vehicles[i])
        end
    end
end)

function isVehBlacklisted(model)
	for _, blacklistedVeh in pairs(Config.BlacklistVehicles) do
		if GetEntityModel(model) == GetHashKey(blacklistedVeh) then
			return true
		end
	end

	return false
end

RegisterNetEvent('m4ch-anticheat:antiProp')
AddEventHandler('m4ch-anticheat:antiProp', function()
    local ped = GetPlayerPed(-1)
    local handle, object = FindFirstObject()
    local finished = false
    repeat
        Citizen.Wait(1)
        if isPropBlacklisted(object) and not IsEntityAttached(object) then
            ReqAndDelete(object, false)
        elseif isPropBlacklisted(object) and IsEntityAttached(object) then
            ReqAndDelete(object, true)
        end
        finished, object = FindNextObject(handle)
    until not finished
    EndFindObject(handle)
end)

CreateThread(function()
    local sleep = 100
	while true do
        Wait(sleep)
        local playerPed = PlayerPedId()
        local nothing, weapon = GetCurrentPedWeapon(playerPed, true)
        local blacklisted, name = isWeaponBlacklisted(weapon)
		if blacklisted then
			RemoveWeaponFromPed(playerPed, weapon)
            if Config.AntiWeaponLog then
                TriggerServerEvent('m4ch-anticheat:dclog', 'Yasaklanan Silah: '..name)
            end
            if Config.AntiWeaponKick then
                TriggerServerEvent('m4ch-anticheat:dropplayer')
            end
		end
	end
end)

function isWeaponBlacklisted(model)
	for _, blacklistedWeapon in pairs(Config.BlacklistedWeapons) do
		if model == GetHashKey(blacklistedWeapon) then
			return true, blacklistedWeapon
		end
	end

	return false, nil
end