fx_version 'adamant'

game 'gta5'

client_scripts {
	'config.lua',
	'client/main.lua'
}

server_scripts {
	'config.lua',
	'server/main.lua',
	'server/vpn/antivpn.lua'
--	'server/mainEN'  ( If you want to translate to English, delete (server/main.lua) and activate (server/mainEN )
}
