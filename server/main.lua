PerformHttpRequest(Config.DiscordWebhook, function(err, text, headers) end, 'POST', json.encode({
    ['username'] = Config.WebhookName,
    ['avatar_url'] = Config.WebhookAvatarUrl,
    ['embeds'] = {{
        ['author'] = {
            ['name'] = 'M4CH ANTICHEAT',
            ['icon_url'] = 'https://cdn.discordapp.com/attachments/870246085938020421/885491043867451412/image.png'
        },
        ['footer'] = {
            ['text'] = 'm4ch-anticheat 1.2'
        },
        ['color'] = 12914,
        ['description'] = 'Anticheat Active',
        ['timestamp'] = os.date('!%Y-%m-%dT%H:%M:%SZ')
    }}
}), {['Content-Type'] = 'application/json' })


AddEventHandler('entityCreated', function(entity)
    if DoesEntityExist(entity) then
        if GetEntityType(entity) == 3 then
            for _, blacklistedProps in pairs(Config.BlacklistProps) do
                if GetEntityModel(entity) == GetHashKey(blacklistedProps) then
                    local src = NetworkGetEntityOwner(entity)
                    local xPlayer = ESX.GetPlayerFromId(src)
                    if Config.AntiPropLog then
                        dclog(xPlayer, 'Blacklist Prop Removed Prop: '..blacklistedProps..'\n**Prop:** https://plebmasters.de/?search='..blacklistedProps..'&app=objects \n**Google:** https://www.google.com/search?q='..blacklistedProps..' \n **Mwojtasik:** https://mwojtasik.dev/tools/gtav/objects/search?name='..blacklistedProps)
                    end
                    if Config.AntiPropDrop then
                        xPlayer.kick(Config.KickMessage)
                    end
                    TriggerClientEvent('m4ch-anticheat:antiProp', -1)
                    CancelEvent()
                    return
                end
            end
        elseif GetEntityType(entity) == 2 then
            for _, blacklistedVeh in pairs(Config.BlacklistVehicles) do
                if GetEntityModel(entity) == GetHashKey(blacklistedVeh) then
                    local src = NetworkGetEntityOwner(entity)
                    local xPlayer = ESX.GetPlayerFromId(src)
                    if Config.AntiVehLog then
                        dclog(xPlayer, 'Blacklist Vehicle Spawned: '..blacklistedVeh..'\n **The tool the cheater is trying to take out:** https://www.gtabase.com/search?searchword='..blacklistedVeh)
                    end
                    if Config.AntiVehDrop then
                        xPlayer.kick(Config.KickMessage)
                    end
                    TriggerClientEvent('m4ch-anticheat:AntiVehicle', -1)
                    CancelEvent()
                    return
                end
            end
        elseif GetEntityType(entity) == 1 then
            for _, blacklistedPed in pairs(Config.BlacklistPeds) do
                if GetEntityModel(entity) == GetHashKey(blacklistedPed) then
                    local src = NetworkGetEntityOwner(entity)
                    local xPlayer = ESX.GetPlayerFromId(src)
                    if Config.AntiPedLog then
                        dclog(xPlayer, 'Blacklist Ped Spawned Name of ped: '..blacklistedPed..'\n **Picture of the Ped:** https://docs.fivem.net/peds/'..blacklistedPed..'.png')
                    end
                    if Config.AntiPedDrop then
                        xPlayer.kick(Config.KickMessage)
                    end
                    TriggerClientEvent('m4ch-anticheat:antiPed', -1)
                    CancelEvent()
                    return
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    for k, v in pairs(Config.BlacklistEvents) do
        if Config.EventDetection then
            RegisterServerEvent(tostring(v))
            AddEventHandler(tostring(v), function()
                local src = source
                local xPlayer = ESX.GetPlayerFromId(src)

                if Config.AntiEventLog then
                    dclog(xPlayer, 'Blacklisted event triggered Event: '..v)
                end
                if Config.AntiEventDrop then
                    xPlayer.kick(Config.KickMessage)
                end
            end)
        end
    end
end)

AddEventHandler('explosionEvent',function(source, ev)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if Config.BlackListExplosions[ev.explosionType] ~= nil then
        if Config.BlackListExplosions[ev.explosionType].block then
            CancelEvent() 
        end
        if Config.AntiExplosionLog then
            if Config.BlackListExplosions[ev.explosionType].log then
                dclog(xPlayer, 'Explosive Material Created! Name of Explosive Substance: '..Config.BlackListExplosions[ev.explosionType].name)
            end
        end
        if Config.AntiExplosionDrop then
            if Config.BlackListExplosions[ev.explosionType].drop then
                xPlayer.kick(Config.KickMessage)
            end
        end
    end
end)

AddEventHandler("playerConnecting", function(playerName, setKickReason)
	for name in pairs(Config.BlacklistNick) do
		if(string.gsub(string.gsub(string.gsub(string.gsub(playerName:lower(), "-", ""), ",", ""), "%.", ""), " ", ""):find(Config.BlacklistNick[name])) then
			print(playerName .. " kicked!")
			setKickReason("Your Name Is Not Valid Edit Your STEAM Name!")
			CancelEvent()
			break
		end
	end
end)

RegisterServerEvent('m4ch-anticheat:dropplayer')
AddEventHandler('m4ch-anticheat:dropplayer', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    xPlayer.kick(Config.KickMessage)
end)

RegisterServerEvent('m4ch-anticheat:dclog')
AddEventHandler('m4ch-anticheat:dclog', function(text)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    dclog(xPlayer, text)
end)

function dclog(xPlayer, text)
    local playerName = Sanitize(xPlayer.getName())
    
    for k, v in ipairs(GetPlayerIdentifiers(xPlayer.source)) do
        if string.match(v, 'discord:') then
            identifierDiscord = v
        end
        if string.match(v, 'ip:') then
            identifierIp = v
        end
    end
	
	local discord_webhook = GetConvar('discord_webhook', Config.DiscordWebhook)
	if discord_webhook == '' then
	  return
	end
	local headers = {
	  ['Content-Type'] = 'application/json'
	}
	local data = {
        ['username'] = Config.WebhookName,
        ['avatar_url'] = Config.WebhookAvatarUrl,
        ['embeds'] = {{
          ['author'] = {
            ['name'] = 'm4ch-anticheat',
            ['icon_url'] = 'https://cdn.discordapp.com/attachments/870246085938020421/885491043867451412/image.png'
          },
          ['footer'] = {
              ['text'] = 'm4ch-anticheat 1.2'
          },
          ['color'] = 12914,
          ['timestamp'] = os.date('!%Y-%m-%dT%H:%M:%SZ')
        }}
      }
    text = '**Description:** ' ..text..'\n**ID**: '..tonumber(xPlayer.source)..'\n**Steam:** '..xPlayer.identifier..'\n **Player IC Name:** '..xPlayer.getName()
    if identifierDiscord ~= nil then
        text = text..'\n**Discord:** <@'..string.sub(identifierDiscord, 9)..'>'
        identifierDiscord = nil
    end
    if identifierIp ~= nil then
        text = text..'\n**IP Adress:** '..string.sub(identifierIp, 4)
        identifierIp = nil
    end
    data['embeds'][1]['description'] = text
	PerformHttpRequest(discord_webhook, function(err, text, headers) end, 'POST', json.encode(data), headers)
end

function Sanitize(str)
	local replacements = {
		['&' ] = '&amp;',
		['<' ] = '&lt;',
		['>' ] = '&gt;',
		['\n'] = '<br/>'
	}

	return str
		:gsub('[&<>\n]', replacements)
		:gsub(' +', function(s)
			return ' '..('&nbsp;'):rep(#s-1)
		end)
end

print("^3[M4CH] ^0AC ACTIVE")
print([[
^2
$$$$      $$$$  $$        $$$$$$$$$  $$      $$
$$ $$    $$ $$  $$        $$         $$      $$
$$  $$  $$  $$  $$        $$         $$      $$
$$   $$$$   $$  $$$$$$$$  $$         $$$$$$$$$$
$$          $$        $$  $$         $$      $$
$$          $$        $$  $$$$$$$$$  $$      $$
^0]])
