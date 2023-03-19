fx_version 'cerulean'

game 'gta5'

author 'Giana - github.com/Giana'
description 'g-mysterybox'
version '0.0.1'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/target.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/log.lua'
}

dependencies {
    'oxmysql',
    'qb-core',
    'qb-inventory',
    'qb-target'
}

lua54 'yes'