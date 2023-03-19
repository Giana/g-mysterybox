-- Functions --

function setUpTarget()
    local coords = nil
    while not coords do
        for k, v in pairs(Config.BoxSpawning.locations) do
            if LocalPlayer.state.isLoggedIn then
                if v.isCurrentSpawn then
                    coords = v.coords
                end
            end
        end
        Wait(1000)
    end
    exports['qb-target']:AddBoxZone('mysterybox', coords, 2, 2, {
        name = 'mysterybox',
        heading = 0,
        debugPoly = false,
        minZ = coords.z - 1,
        maxZ = coords.z + 1,
    }, {
        options = {
            {
                type = 'server',
                event = 'g-mysterybox:server:openMysteryBox',
                icon = 'fa-solid fa-gift',
                label = Lang:t('other.target_label'),
            },
        },
        distance = 3
    })
end

-- Events --

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end
    if Config.OpenBoxMethod == 'target' then
        setUpTarget()
    end
end)

RegisterNetEvent('g-mysterybox:client:setUpTarget', function()
    setUpTarget()
end)