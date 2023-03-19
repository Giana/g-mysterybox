local QBCore = exports['qb-core']:GetCoreObject()

local mysteryBoxSpawned = false
local mysteryBox = nil

-- Commands --

RegisterCommand(Config.BoxSpawning.resetMysteryBoxCommand, function()
    QBCore.Functions.TriggerCallback('g-mysterybox:server:isAceAllowed', function(isAceAllowed)
        if isAceAllowed then
            local playerData = QBCore.Functions.GetPlayerData()
            local name = playerData.name
            local license = playerData.license
            QBCore.Functions.Notify(Lang:t('primary.resetting'), 'primary')
            resetMysteryBox()
            TriggerServerEvent('g-mysterybox:server:log', Lang:t('success_log.reset_command', { name = name, license = license }))
        else
            QBCore.Functions.Notify(Lang:t('error.unauthorized'), 'error')
        end
    end)
end)

-- Functions --

function createMysteryBox(coords)
    if mysteryBoxSpawned and mysteryBox then
        destroyMysteryBox()
    end
    mysteryBoxSpawned = true
    local model = Config.BoxSpawning.model
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(250)
    end
    mysteryBox = CreateObject(model, coords.x, coords.y, coords.z, true, true, true)
    SetModelAsNoLongerNeeded(model)
    PlaceObjectOnGroundProperly(mysteryBox)
    SetEntityHeading(mysteryBox, coords.w)
    FreezeEntityPosition(mysteryBox, true)
end

function destroyMysteryBox()
    if not mysteryBoxSpawned and not mysteryBox then
        return
    end
    mysteryBoxSpawned = false
    DeleteEntity(mysteryBox)
end

function DrawText3Ds(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function resetMysteryBox()
    destroyMysteryBox()
    local currentSpawnIndex = getCurrentSpawnIndex()
    TriggerServerEvent('g-mysterybox:server:deleteCurrentBoxSpawn')
    Wait(1000)
    TriggerServerEvent('g-mysterybox:server:setBoxLocation', currentSpawnIndex)
    TriggerServerEvent('g-mysterybox:server:setMysteryBoxOpenState', false)
    TriggerEvent('g-mysterybox:client:setUpTarget')
end

function getCurrentSpawnIndex()
    local currentSpawnIndex = -1
    for k, v in pairs(Config.BoxSpawning.locations) do
        if v.isCurrentSpawn then
            currentSpawnIndex = k
            break
        end
    end
    return currentSpawnIndex
end

-- Events --

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end
    destroyMysteryBox()
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    TriggerEvent('g-mysterybox:client:setSpawnStateInConfig', nil, true)
    TriggerEvent('g-mysterybox:client:setUpTarget')
end)

RegisterNetEvent('g-mysterybox:client:openShop', function(loot)
    TriggerServerEvent('inventory:server:OpenInventory', 'shop', Config.BoxShopName, loot.itemConfig)
end)

RegisterNetEvent('g-mysterybox:client:setSpawnStateInConfig', function(index, state)
    if index then
        Config.BoxSpawning.locations[index].isCurrentSpawn = state
    else
        QBCore.Functions.TriggerCallback('g-mysterybox:server:getCurrentSpawnInConfig', function(returnedIndex)
            if returnedIndex then
                Config.BoxSpawning.locations[returnedIndex].isCurrentSpawn = state
            end
        end)
    end
end)

RegisterNetEvent('g-mysterybox:client:openMysteryBox', function(loot)
    local ped = PlayerPedId()
    QBCore.Functions.Progressbar('open_mysterybox', Lang:t('other.opening_progress'), 4 * 1000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        -- Animation
        animDict = 'anim@amb@warehouse@toolbox@',
        anim = 'enter',
        flags = 16,
    }, {}, {}, function()
        -- Done
        QBCore.Functions.TriggerCallback('g-mysterybox:server:getOpenStatus', function(isAlreadyOpen)
            if not isAlreadyOpen then
                TriggerServerEvent('g-mysterybox:server:recordOpenedMysteryBox', loot)
                TriggerServerEvent('g-mysterybox:server:setMysteryBoxOpenState', true)
                TriggerServerEvent('g-mysterybox:server:rewardMoney', loot)
                if Config.OpenBoxView == 'shop' then
                    TriggerEvent('g-mysterybox:client:openShop', loot)
                else
                    TriggerServerEvent('g-mysterybox:server:autoGiveLoot', loot)
                end
                Wait(1000)
                if Config.BoxSpawning.respawnAfterOpen then
                    resetMysteryBox()
                else
                    TriggerServerEvent('g-mysterybox:server:deleteCurrentBoxSpawn')
                    Wait(1000)
                    destroyMysteryBox()
                end
            else
                QBCore.Functions.Notify(Lang:t('error.already_opened'), 'error')
            end
        end)
        Wait(500)
        ClearPedTasks(ped)
        ClearPedSecondaryTask(ped)
        FreezeEntityPosition(ped, false)
    end, function()
        -- Cancel
        ClearPedTasks(ped)
        ClearPedSecondaryTask(ped)
        FreezeEntityPosition(ped, false)
    end)
end)

-- Threads --

-- Setting box location in config for client
Citizen.CreateThread(function()
    while not LocalPlayer.state.isLoggedIn do
        Wait(1000)
    end
    TriggerEvent('g-mysterybox:client:setSpawnStateInConfig', nil, true)
end)

-- Box model spawning setup
Citizen.CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local inRange = false
            for k, v in pairs(Config.BoxSpawning.locations) do
                if v.isCurrentSpawn then
                    local dist = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
                    if dist < Config.BoxSpawning.renderDistance then
                        if not mysteryBoxSpawned then
                            createMysteryBox(v.coords)
                        end
                        inRange = true
                    elseif mysteryBoxSpawned then
                        destroyMysteryBox()
                    end
                end
            end
            if not inRange then
                Wait(2000)
            end
        end
        Wait(10)
    end
end)

-- Walk up setup
if Config.OpenBoxMethod == 'walkup' then
    Citizen.CreateThread(function()
        while true do
            if LocalPlayer.state.isLoggedIn then
                local ped = PlayerPedId()
                local pos = GetEntityCoords(ped)
                local inRange = false
                for k, v in pairs(Config.BoxSpawning.locations) do
                    if v.isCurrentSpawn then
                        local dist = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
                        if dist < 3 then
                            DrawText3Ds(v.coords.x, v.coords.y, v.coords.z, Lang:t('other.walkup_text'))
                            if IsControlJustPressed(0, 38) then
                                TriggerServerEvent('g-mysterybox:server:openMysteryBox')
                            end
                            inRange = true
                        end
                    end
                end
                if not inRange then
                    Wait(2000)
                end
            end
            Wait(10)
        end
    end)
end