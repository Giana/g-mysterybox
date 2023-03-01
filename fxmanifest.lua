fx_version 'cerulean'

game 'gta5'

author 'Giana - github.com/Giana'
description 'g-mysterybox'
version '0.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

dependencies {
    'qb-core'
}

lua54 'yes'