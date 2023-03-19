Config = {}

Config.EnableWebhookLogs = true         -- If webhook logs are enabled
Config.NotifyEveryoneOnOpen = true      -- If webhook log should @everyone in channel when mystery box is opened
Config.WebhookLink = ''                 -- Webhook link

Config.EnablePrintLogs = true       -- If printing logs to server console is enabled

--[[
    - Config.OpenBoxMethod: How mystery box coords are approached by player to open & get reward(s)
        - Options:
            - 'walkup'
                - Player can open if they walk up to coords and press E (popup message will appear)
            - 'target'
                - Player can open if they target at coords
]]
Config.OpenBoxMethod = 'target'

--[[
    - Config.OpenBoxView: How mystery box contents are viewed when the player opens it
        - Options:
            - 'shop'
                - Player sees "shop" UI they can drag items from into their inventory
            - 'none'
                - Player sees no UI and automatically gets all items
]]
Config.OpenBoxView = 'shop'

Config.BoxShopName = 'mysteryboxshop'     -- Name of the mystery box "shop"

Config.BoxSpawning = {
    model = 'gr_prop_gr_rsply_crate01a', -- Model name for mystery box players see (check https://gta-objects.xyz/objects for more options)
    renderDistance = 50, -- Render distance for mystery box (lower == better performance, higher == better immersion)
    newSpawnOnRestart = false, -- true == box will spawn at any "random" location in config on server/script restart, false == box will spawn from what's last saved in database (or will pick location randomly if nothing saved yet)
    respawnAfterOpen = true, -- true == box will respawn at different location after being opened, false == box will only respawn after server restart or resetMysteryBoxCommand
    resetMysteryBoxCommand = 'resetmysterybox', -- Command to spawn mystery box at different location
    commandAceGroup = 'mysterybox', -- Ace group required to use resetMysteryBoxCommand
    --[[
    For each Config.BoxSpawning.locations[x]:
    - coords: Box spawn coordinates
    - isCurrentSpawn: If location is current box spawn/location for server (always keep this set to false!)
        - Server will automatically set true for one on startup depending on above settings, so just always keep this false by default
    ****************************************************************************************************************************************************************************
    - Note: You should have at least two locations, ideally more, otherwise anyone who finds a mystery box knows the one place it spawns and can farm rewards at every restart
    ****************************************************************************************************************************************************************************
    ]]
    locations = {
        [1] = {
            coords = vector4(-445.12, 4533.13, 97.66, 165.96),
            isCurrentSpawn = false
        },
        [2] = {
            coords = vector4(2244.02, 6725.69, 33.96, 58.07),
            isCurrentSpawn = false
        },
        [3] = {
            coords = vector4(1940.47, 4664.15, 40.63, 60.51),
            isCurrentSpawn = false
        },
        [4] = {
            coords = vector4(-1053.44, 1604.44, 265.57, 21.92),
            isCurrentSpawn = false
        },
        [5] = {
            coords = vector4(1840.31, 285.22, 161.54, 263.12),
            isCurrentSpawn = false
        },
        [6] = {
            coords = vector4(1606.31, -1982.0, 98.55, 228.81),
            isCurrentSpawn = false
        },
        [7] = {
            coords = vector4(-1914.99, -3039.31, 23.59, 320.64),
            isCurrentSpawn = false
        },
        [8] = {
            coords = vector4(734.96, 503.94, 134.92, 274.94),
            isCurrentSpawn = false
        },
        [9] = {
            coords = vector4(59.32, -1618.31, 29.42, 228.79),
            isCurrentSpawn = false
        },
        [10] = {
            coords = vector4(1555.15, 3599.87, 38.78, 263.77),
            isCurrentSpawn = false
        }
    }
}

--[[
    For each Config.RewardBoxes[x]:
    - name: Name of mystery box loot (for logging)
    - moneyRewards:
        - ['moneyType'] (name of money type) = moneyAmount (amount of money to reward)
    - itemConfig:
        - label: Label to display in shop UI
        - slots: Item slots in shop UI
        - For each Config.RewardBoxes[x].itemConfig.items[y]:
            - name: Item name
            - price: Item price
            - amount: Item amount
            - info: Item info
            - type: Item type
            - slot: Item slot
]]
Config.RewardBoxes = {
    [1] = {
        name = 'Pawn Box',
        moneyRewards = {
            ['cash'] = math.random(10000, 20000)
        },
        itemConfig = {
            label = 'Mystery Box',
            slots = 30,
            items = {
                [1] = {
                    name = 'rolex',
                    price = 0,
                    amount = math.random(10, 20),
                    info = {},
                    type = 'item',
                    slot = 1
                },
                [2] = {
                    name = 'diamond_ring',
                    price = 0,
                    amount = math.random(10, 20),
                    info = {},
                    type = 'item',
                    slot = 2
                },
                [3] = {
                    name = 'goldchain',
                    price = 0,
                    amount = math.random(10, 20),
                    info = {},
                    type = 'item',
                    slot = 3
                },
                [4] = {
                    name = '10kgoldchain',
                    price = 0,
                    amount = math.random(10, 20),
                    info = {},
                    type = 'item',
                    slot = 4
                }
            }
        }
    },
    [2] = {
        name = 'Drug Box',
        moneyRewards = {
            ['cash'] = math.random(5000, 10000),
            ['crypto'] = math.random(1, 3)
        },
        itemConfig = {
            label = 'Mystery Box',
            slots = 30,
            items = {
                [1] = {
                    name = 'joint',
                    price = 0,
                    amount = math.random(10, 20),
                    info = {},
                    type = 'item',
                    slot = 1
                },
                [2] = {
                    name = 'cokebaggy',
                    price = 0,
                    amount = math.random(10, 20),
                    info = {},
                    type = 'item',
                    slot = 2
                },
                [3] = {
                    name = 'crack_baggy',
                    price = 0,
                    amount = math.random(10, 20),
                    info = {},
                    type = 'item',
                    slot = 3
                },
                [4] = {
                    name = 'xtcbaggy',
                    price = 0,
                    amount = math.random(10, 20),
                    info = {},
                    type = 'item',
                    slot = 4
                },
                [5] = {
                    name = 'oxy',
                    price = 0,
                    amount = math.random(10, 20),
                    info = {},
                    type = 'item',
                    slot = 5
                },
                [6] = {
                    name = 'painkillers',
                    price = 0,
                    amount = math.random(10, 20),
                    info = {},
                    type = 'item',
                    slot = 6
                }
            }
        }
    },
    [3] = {
        name = 'Pistol Box',
        moneyRewards = {
            ['cash'] = math.random(10000, 20000)
        },
        itemConfig = {
            label = 'Mystery Box',
            slots = 30,
            items = {
                [1] = {
                    name = 'weapon_pistol',
                    price = 0,
                    amount = 1,
                    info = {},
                    type = 'item',
                    slot = 1
                },
                [2] = {
                    name = 'pistol_suppressor',
                    price = 0,
                    amount = 1,
                    info = {},
                    type = 'item',
                    slot = 2
                },
                [3] = {
                    name = 'pistol_extendedclip',
                    price = 0,
                    amount = 1,
                    info = {},
                    type = 'item',
                    slot = 3
                },
                [4] = {
                    name = 'pistol_ammo',
                    price = 0,
                    amount = 10,
                    info = {},
                    type = 'item',
                    slot = 4
                }
            }
        }
    },
    [4] = {
        name = 'SMG Box',
        moneyRewards = {
            ['cash'] = math.random(10000, 20000)
        },
        itemConfig = {
            label = 'Mystery Box',
            slots = 30,
            items = {
                [1] = {
                    name = 'weapon_microsmg',
                    price = 0,
                    amount = 1,
                    info = {},
                    type = 'item',
                    slot = 1
                },
                [2] = {
                    name = 'smg_suppressor',
                    price = 0,
                    amount = 1,
                    info = {},
                    type = 'item',
                    slot = 2
                },
                [3] = {
                    name = 'microsmg_extendedclip',
                    price = 0,
                    amount = 1,
                    info = {},
                    type = 'item',
                    slot = 3
                },
                [4] = {
                    name = 'smg_ammo',
                    price = 0,
                    amount = 5,
                    info = {},
                    type = 'item',
                    slot = 4
                }
            }
        }
    },
    [5] = {
        name = 'Assault Rifle Box',
        moneyRewards = {
            ['cash'] = math.random(10000, 20000)
        },
        itemConfig = {
            label = 'Mystery Box',
            slots = 30,
            items = {
                [1] = {
                    name = 'weapon_assaultrifle',
                    price = 0,
                    amount = 1,
                    info = {},
                    type = 'item',
                    slot = 1
                },
                [2] = {
                    name = 'rifle_suppressor',
                    price = 0,
                    amount = 1,
                    info = {},
                    type = 'item',
                    slot = 2
                },
                [3] = {
                    name = 'assaultrifle_extendedclip',
                    price = 0,
                    amount = 1,
                    info = {},
                    type = 'item',
                    slot = 3
                },
                [4] = {
                    name = 'rifle_ammo',
                    price = 0,
                    amount = 2,
                    info = {},
                    type = 'item',
                    slot = 4
                }
            }
        }
    },
}