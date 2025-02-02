fx_version 'cerulean'
game 'gta5'
lua54 'yes'
autor 'vule.gg'
deskripcija 'Da debli ne koriste od mrtvog lakica ono mrtvo sranje.'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/*.lua',
}

client_script 'client/*.lua'
server_script 'server/*.lua'

dependencies {
    'ox_lib',
    'ox_inventory'
}