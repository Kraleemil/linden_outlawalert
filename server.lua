-- ESX Framework Stuff ---------------------------------------------------------------
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('linden_outlawalert:getCharData', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end

    local identifier = xPlayer.getIdentifier()
    MySQL.Async.fetchAll('SELECT firstname, lastname, phone_number FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(results)
		cb(results[1])
	end)
end)

ESX.RegisterServerCallback('linden_outlawalert:isVehicleOwned', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT plate FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] then
			cb(true)
		else
			cb(false)
		end
	end)
end)
-- ESX Framework Stuff ---------------------------------------------------------------

local dispatchCodes = {

    melee = { displayCode = 'KODE 2', description = _U('melee'), isImportant = 0, recipientList = {'police'},
    blipSprite = 652, blipColour = 84, blipScale = 1.5 },

    officerdown = {displayCode = 'KODE 3', description = _U('officerdown'), isImportant = 1, recipientList = {'police', 'ambulance'},
    blipSprite = 653, blipColour = 84, blipScale = 1.5, infoM = 'fa-portrait'},

    officerdown2 = {displayCode = 'KODE 3', description = _U('officerdown2'), isImportant = 1, recipientList = {'police', 'ambulance'},
    blipSprite = 653, blipColour = 84, blipScale = 1.7, infoM = 'fa-portrait'},

    persondown = {displayCode = 'KODE 2', description = _U('persondown'), isImportant = 0, recipientList = {'police', 'ambulance'},
    blipSprite = 153, blipColour = 84, blipScale = 1.5, infoM = 'fa-portrait'},

    autotheft = {displayCode = 'KODE 2', description = _U('autotheft'), isImportant = 0, recipientList = {'police'},
    blipSprite = 651, blipColour = 84, blipScale = 1.5, infoM = 'fa-car', infoM2 = 'fa-palette' },

    speeding = {displayCode = 'KODE 1', description = _U('speeding'), isImportant = 0, recipientList = {'police'},
    blipSprite = 650, blipColour = 84, blipScale = 1.5, infoM = 'fa-car', infoM2 = 'fa-palette' },

    shooting = { displayCode = 'KODE 3', description = _U('shooting'), isImportant = 0, recipientList = {'police', 'ambulance'},
    blipSprite = 648, blipColour = 84, blipScale = 1.5 },

    driveby = { displayCode = 'KODE 3', description = _U('driveby'), isImportant = 0, recipientList = {'police', 'ambulance'},
    blipSprite = 649, blipColour = 84, blipScale = 1.5, infoM = 'fa-car', infoM2 = 'fa-palette' },
}


--[[ Example custom alert

RegisterCommand('Vangelico-robbery', function(playerId, args, rawCommand)
    local data = {displayCode = 'KODE 3', description = 'Røveri', isImportant = 0, recipientList = {'police'}, length = '10000', infoM = 'fa-info-circle', info = 'Vangelico Smykker Butik'}
    local dispatchData = {dispatchData = data, caller = 'Alarm', coords = vector3(-628.27172851562, -235.14242553711, 38.057056427002)}
    TriggerEvent('wf-alerts:svNotify', dispatchData)
end, false)
 --]]
--[[ Example custom alert 
RegisterCommand('Bank-midt-by', function(playerId, args, rawCommand)
    local data = {displayCode = 'KODE 3', description = 'Røveri', isImportant = 0, recipientList = {'police'}, length = '10000', infoM = 'fa-info-circle', info = 'Bank Røveri Midt By Bank'}
    local dispatchData = {dispatchData = data, caller = 'Alarm', coords = vector3(150.33166503906, -1038.7174072266, 29.377780914307)}
    TriggerEvent('wf-alerts:svNotify', dispatchData)
end, false)
--]]
--[[ Example custom alert 
RegisterCommand('Bank-vest-kyst', function(playerId, args, rawCommand)
    local data = {displayCode = 'KODE 3', description = 'Røveri', isImportant = 0, recipientList = {'police'}, length = '10000', infoM = 'fa-info-circle', info = 'Bank Røveri Vest Kyst Bank'}
    local dispatchData = {dispatchData = data, caller = 'Alarm', coords = vector3(-2964.73828125, 482.93658447266, 15.706809043884)}
    TriggerEvent('wf-alerts:svNotify', dispatchData)
end, false)
--]]
--[[ Example custom alert 
RegisterCommand('Bank-hovede', function(playerId, args, rawCommand)
    local data = {displayCode = 'KODE 3', description = 'Røveri', isImportant = 0, recipientList = {'police'}, length = '10000', infoM = 'fa-info-circle', info = 'Bank Røveri Hovede Banken'}
    local dispatchData = {dispatchData = data, caller = 'Alarm', coords = vector3(233.49534606934, 215.64181518555, 106.2866897583)}
    TriggerEvent('wf-alerts:svNotify', dispatchData)
end, false)
--]]
--[[ Example custom alert 
RegisterCommand('Bank-peleto', function(playerId, args, rawCommand)
    local data = {displayCode = 'KODE 3', description = 'Røveri', isImportant = 0, recipientList = {'police'}, length = '10000', infoM = 'fa-info-circle', info = 'Bank Røveri Peleto Bank'}
    local dispatchData = {dispatchData = data, caller = 'Alarm', coords = vector3(-110.30471038818, 6463.0869140625, 31.626705169678)}
    TriggerEvent('wf-alerts:svNotify', dispatchData)
end, false)
--]]

RegisterServerEvent('wf-alerts:svNotify')
AddEventHandler('wf-alerts:svNotify', function(pData)
    local dispatchData
    if not pData.dispatchCode then dispatchData = pData.dispatchData elseif dispatchCodes[pData.dispatchCode] ~= nil then dispatchData = dispatchCodes[pData.dispatchCode] end
    if not pData.info then pData.info = dispatchData.info end
    if not pData.info2 then pData.info2 = dispatchData.info2 end
    if not pData.length then pData.length = dispatchData.length end
    pData.displayCode = dispatchData.displayCode
    pData.dispatchMessage = dispatchData.description
    pData.isImportant = dispatchData.isImportant
    pData.recipientList = dispatchData.recipientList
    pData.infoM = dispatchData.infoM
    pData.infoM2 = dispatchData.infoM2
    pData.sprite = dispatchData.blipSprite
    pData.colour = dispatchData.blipColour
    pData.scale = dispatchData.blipScale
    Citizen.Wait(1500)
    local xPlayers = ESX.GetPlayers()
	for i= 1, #xPlayers do
        local source = xPlayers[i]
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.job.name == pData.recipientList[1] or xPlayer.job.name == pData.recipientList[2] then
            TriggerClientEvent('wf-alerts:clNotify', source, pData)
        end
    end
    local n = [[

]]
    local details = pData.dispatchMessage
    if pData.info then details = details .. n .. pData.info end
    if pData.info2 then details = details .. n .. pData.info2 end
    if pData.recipientList[1] == 'police' then TriggerEvent('mdt:newCall', details, pData.caller, vector3(pData.coords.x, pData.coords.y, pData.coords.z), false) end
end)


RegisterServerEvent('wf-alerts:svNotify911')
AddEventHandler('wf-alerts:svNotify911', function(message, caller, coords)
    if message ~= nil then
        local pData = {}
        pData.displayCode = '112'
        if caller == _U('caller_unknown') then pData.dispatchMessage = _U('unknown_caller') else
        pData.dispatchMessage = _U('call_from') .. caller end
        pData.recipientList = {'police', 'ambulance'}
        pData.length = 6000
        pData.infoM = 'fa-phone'
        pData.info = message
        pData.coords = vector3(coords.x, coords.y, coords.z)
        pData.sprite, pData.colour, pData.scale =  480, 84, 2.0 -- radar_vip, blue
        local xPlayers = ESX.GetPlayers()
		for i= 1, #xPlayers do
            local source = xPlayers[i]
            local xPlayer = ESX.GetPlayerFromId(source)
            if xPlayer.job.name == 'police' or xPlayer.job.name == 'ambulance' then
                TriggerClientEvent('wf-alerts:clNotify', source, pData)
            end
        end
        TriggerEvent('mdt:newCall', message, caller, vector3(coords.x, coords.y, coords.z), false)
    end
end)


-- VERSION CHECK
CreateThread(function()
    local resourceName = GetCurrentResourceName()
    local currentVersion, latestVersion = GetResourceMetadata(resourceName, 'version')
    local outdated = '^6[%s]^3 Version ^2%s^3 is available! You are using version ^1%s^7'
    Citizen.Wait(2000)
    while Config.CheckVersion do
        Citizen.Wait(0)
        PerformHttpRequest(GetResourceMetadata(resourceName, 'versioncheck'), function (errorCode, resultData, resultHeaders)
            if errorCode ~= 200 then print("Returned error code:" .. tostring(errorCode)) else
                local data, version = tostring(resultData)
                for line in data:gmatch("([^\n]*)\n?") do
                    if line:find('^version') then version = line:sub(10, (line:len(line) - 1)) break end
                end         
                latestVersion = version
            end
        end)
        if latestVersion then 
            if currentVersion ~= latestVersion then
                print(outdated:format(resourceName, latestVersion, currentVersion))
            end
            Citizen.Wait(60000*Config.CheckVersionDelay)
        end
    end
end)
