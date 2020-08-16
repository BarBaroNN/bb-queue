fx_version 'cerulean'
game 'gta5' 

author 'BarBaroNN'
description 'Advanced FiveM Queue'
version '1.0.0'

client_script 'bb_c.lua'
server_scripts {
	'@mysql-async/lib/MySQL.lua',
  	'@es_extended/locale.lua',
  	'bb_config.lua',
  	'bb_s.lua',
}