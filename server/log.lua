-- Events --

RegisterNetEvent('g-mysterybox:server:log')
AddEventHandler('g-mysterybox:server:log', function(logText)
    if Config.EnablePrintLogs and logText ~= '@everyone' then
        print(logText)
    end
    if Config.EnableWebhookLogs and #Config.WebhookLink > 0 then
        if logText == '@everyone' then
            PerformHttpRequest(Config.WebhookLink, function(err, text, headers)
            end, 'POST', json.encode({
                username = Lang:t('other.bot_name'),
                content = '@everyone'
            }), {
                ['Content-Type'] = 'application/json'
            })
        else
            PerformHttpRequest(Config.WebhookLink, function(err, text, headers)
            end, 'POST', json.encode({
                username = Lang:t('other.bot_name'),
                embeds = { {
                               ['color'] = 65280,
                               ['author'] = {
                                   ['name'] = Lang:t('other.bot_name'),
                                   ['icon_url'] = ''
                               },
                               ['title'] = GetCurrentResourceName(),
                               ['description'] = '' .. logText .. '',
                               ['footer'] = {
                                   ['text'] = os.date('%x %X %p'),
                                   ['icon_url'] = '',
                               },
                           } },
                avatar_url = ''
            }), {
                ['Content-Type'] = 'application/json'
            })
        end
    end
end)