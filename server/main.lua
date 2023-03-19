local QBCore = exports['qb-core']:GetCoreObject()

local isMysteryBoxOpen = false

-- Functions --

function pickRandomSpawnFromConfig()
    local randIndex = math.random(1, #Config.BoxSpawning.locations)
    setCurrentSpawnInConfig(randIndex, nil, nil, nil, nil)
end

function setCurrentSpawnInConfig(index, dbX, dbY, dbZ, dbW)
    if index then
        Config.BoxSpawning.locations[index].isCurrentSpawn = true
        TriggerClientEvent('g-mysterybox:client:setSpawnStateInConfig', -1, index, true)
        Wait(1000)
        saveCurrentBoxToDatabase()
    elseif dbX and dbY and dbZ and dbW then
        local matchFound = false
        for k, v in pairs(Config.BoxSpawning.locations) do
            local xMatch = round(v.coords.x) == round(dbX)
            local yMatch = round(v.coords.y) == round(dbY)
            local zMatch = round(v.coords.z) == round(dbZ)
            local wMatch = round(v.coords.w) == round(dbW)
            local allMatch = xMatch and yMatch and zMatch and wMatch
            if allMatch then
                matchFound = true
                v.isCurrentSpawn = true
                TriggerClientEvent('g-mysterybox:client:setSpawnStateInConfig', -1, k, true)
                TriggerEvent('g-mysterybox:server:log', Lang:t('success_log.previous_loaded'))
            end
        end
        if not matchFound then
            TriggerEvent('g-mysterybox:server:log', Lang:t('error_log.saving_no_match'))
            pickRandomSpawnFromConfig()
        end
    else
        TriggerEvent('g-mysterybox:server:log', Lang:t('error_log.saving_no_index_coords'))
    end
    TriggerEvent('g-mysterybox:server:setMysteryBoxOpenState', false)
end

function saveCurrentBoxToDatabase()
    local spawnSetInConfig = false
    local location = nil
    Wait(1000)
    for k, v in pairs(Config.BoxSpawning.locations) do
        if v.isCurrentSpawn then
            spawnSetInConfig = true
            location = v
            break
        end
    end
    if not spawnSetInConfig or not location then
        TriggerEvent('g-mysterybox:server:log', Lang:t('error_log.saving_spawn_not_set'))
        return
    end
    deleteCurrentBoxFromDatabase()
    local datetime = os.date('%Y-%m-%d %H:%M:%S')
    local sql = 'INSERT INTO mysterybox_current (spawn_date, spawn_coords_x, spawn_coords_y, spawn_coords_z, spawn_coords_w) VALUES (?, ?, ?, ?, ?)'
    MySQL.insert(sql, {
        datetime,
        location.coords.x,
        location.coords.y,
        location.coords.z,
        location.coords.w
    }, function(result)
        if result > 0 then
            TriggerEvent('g-mysterybox:server:log', Lang:t('success_log.saved_box_database'))
        else
            TriggerEvent('g-mysterybox:server:log', Lang:t('error_log.insert_database'))
        end
    end)
end

function deleteCurrentBoxFromDatabase()
    MySQL.query('DELETE FROM mysterybox_current', {})
end

function getCurrentBoxFromDatabase()
    local result = MySQL.query.await('SELECT * FROM mysterybox_current', {})
    if not result or not result[1] then
        return nil
    else
        return result[1]
    end
end

function chooseRandomLoot()
    local randIndex = math.random(1, #Config.RewardBoxes)
    return Config.RewardBoxes[randIndex]
end

function round(num)
    local mult = 10 ^ 4
    return math.floor(num * mult + 0.5) / mult
end

function unsetCurrentSpawnInConfig()
    for k, v in pairs(Config.BoxSpawning.locations) do
        if v.isCurrentSpawn then
            v.isCurrentSpawn = false
            TriggerClientEvent('g-mysterybox:client:setSpawnStateInConfig', -1, k, false)
        end
    end
end

function pickFreshRandomSpawnFromConfig(currentSpawnIndex)
    local randIndex = math.random(1, #Config.BoxSpawning.locations)
    if #Config.BoxSpawning.locations > 1 then
        while randIndex == currentSpawnIndex do
            randIndex = math.random(1, #Config.BoxSpawning.locations)
        end
        setCurrentSpawnInConfig(randIndex, nil, nil, nil, nil)
    else
        TriggerEvent('g-mysterybox:server:log', Lang:t('error_log.picking_not_enough'))
        TriggerEvent('g-mysterybox:server:setMysteryBoxOpenState', true)
    end
end

-- Events --

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end
    TriggerEvent('g-mysterybox:server:setBoxLocation', -1)
end)

RegisterNetEvent('g-mysterybox:server:setBoxLocation', function(currentSpawnIndex)
    if Config.BoxSpawning.newSpawnOnRestart then
        if currentSpawnIndex == -1 then
            pickRandomSpawnFromConfig()
        else
            pickFreshRandomSpawnFromConfig(currentSpawnIndex)
        end
    else
        local preexistingBox = getCurrentBoxFromDatabase()
        if preexistingBox then
            setCurrentSpawnInConfig(nil, preexistingBox.spawn_coords_x, preexistingBox.spawn_coords_y, preexistingBox.spawn_coords_z, preexistingBox.spawn_coords_w)
        else
            if currentSpawnIndex == -1 then
                pickRandomSpawnFromConfig()
            else
                pickFreshRandomSpawnFromConfig(currentSpawnIndex)
            end
        end
    end
end)

RegisterNetEvent('g-mysterybox:server:openMysteryBox', function()
    local src = source
    local loot = chooseRandomLoot()
    Wait(250)
    TriggerClientEvent('g-mysterybox:client:openMysteryBox', src, loot)
end)

RegisterNetEvent('g-mysterybox:server:deleteCurrentBoxSpawn', function()
    deleteCurrentBoxFromDatabase()
    unsetCurrentSpawnInConfig()
end)

RegisterNetEvent('g-mysterybox:server:autoGiveLoot', function(loot)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    for k, v in pairs(loot.itemConfig.items) do
        if player.Functions.AddItem(v.name, v.amount) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[v.name], 'add', v.amount)
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t('error.no_room'), 'primary')
            break
        end
    end
end)

RegisterNetEvent('g-mysterybox:server:rewardMoney', function(loot)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    for k, v in pairs(loot.moneyRewards) do
        if not player.Functions.AddMoney(k, v) then
            TriggerEvent('QBCore:Notify', src, Lang:t('error.money_type', { type = k }), 'error')
        end
    end
end)

RegisterNetEvent('g-mysterybox:server:setMysteryBoxOpenState', function(state)
    isMysteryBoxOpen = state
end)

RegisterNetEvent('g-mysterybox:server:recordOpenedMysteryBox', function(loot)
    local src = source
    local currentBox = getCurrentBoxFromDatabase()
    local foundDate = os.date('%Y-%m-%d %H:%M:%S')
    local lootBoxName = loot.name
    local playerData = QBCore.Functions.GetPlayer(src).PlayerData
    local name = playerData.name
    local license = playerData.license
    local firstName = playerData.charinfo.firstname
    local lastName = playerData.charinfo.lastname
    local citizenid = playerData.citizenid
    local data = {}
    data.currentBox = currentBox
    data.found_date = foundDate
    data.loot_name = lootBoxName
    data.recipient_name = name
    data.recipient_citizenid = citizenid
    data.recipient_license = license
    TriggerEvent('g-mysterybox:server:log', Lang:t('success_log.box_opened', { name = name, license = license, firstName = firstName, lastName = lastName, citizenid = citizenid, lootBoxName = lootBoxName }))
    if Config.NotifyEveryoneOnOpen then
        TriggerEvent('g-mysterybox:server:log', '@everyone')
    end
    TriggerEvent('g-mysterybox:server:saveOpenedMysteryBoxInDatabase', data)
end)

RegisterNetEvent('g-mysterybox:server:saveOpenedMysteryBoxInDatabase', function(data)
    local sql = 'INSERT INTO mysterybox_history (spawn_date, spawn_coords_x, spawn_coords_y, spawn_coords_z, spawn_coords_w, found_date, loot_name, recipient_name, recipient_citizenid, recipient_license) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'
    MySQL.insert(sql, {
        data.currentBox.spawn_date,
        data.currentBox.spawn_coords_x,
        data.currentBox.spawn_coords_y,
        data.currentBox.spawn_coords_z,
        data.currentBox.spawn_coords_w,
        data.found_date,
        data.loot_name,
        data.recipient_name,
        data.recipient_citizenid,
        data.recipient_license
    }, function(result)
        if result > 0 then
            TriggerEvent('g-mysterybox:server:log', Lang:t('success_log.saved_opened_database'))
        else
            TriggerEvent('g-mysterybox:server:log', Lang:t('error_log.insert_opened_database'))
        end
    end)
end)

-- Callbacks --

QBCore.Functions.CreateCallback('g-mysterybox:server:getCurrentSpawnInConfig', function(source, cb)
    local found = false
    for k, v in pairs(Config.BoxSpawning.locations) do
        if v.isCurrentSpawn then
            found = true
            cb(k)
        end
    end
    if not found then
        cb(nil)
    end
end)

QBCore.Functions.CreateCallback('g-mysterybox:server:getOpenStatus', function(source, cb)
    if isMysteryBoxOpen then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('g-mysterybox:server:isAceAllowed', function(source, cb)
    local src = source
    if IsPlayerAceAllowed(src, Config.BoxSpawning.commandAceGroup) then
        cb(true)
    else
        cb(false)
    end
end)