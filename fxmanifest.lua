fx_version 'cerulean'
game 'gta5'
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua'
}

client_scripts {
    '@oxmysql/lib/MySQL.lua',
    'client.lua',
    'functions.lua'
}

server_script 'server.lua'