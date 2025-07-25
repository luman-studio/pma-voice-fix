local allowedInteriors = {}
for k,hash in ipairs(Config.Interiors) do
    allowedInteriors[hash] = true
end
CreateThread(function()
    local function onEnteredInterior(interiorId)
        local _, hash = GetInteriorLocationAndNamehash(interiorId)
        if not allowedInteriors[hash] then
            return
        end
        print('Entered into interior', interiorId, hash)
        for k,v in ipairs(GetActivePlayers()) do
            if v ~= PlayerId() then
                local pInteriorId = GetInteriorFromEntity(GetPlayerPed(v))
                if pInteriorId == interiorId then
                    CreateThread(function()
                        print('[fix mlo voice]: Volume override for player', v)
                        MumbleSetVolumeOverride(v, 1.0)
                        Wait(1000)
                        MumbleSetVolumeOverride(v, -1.0)
                    end)
                end
            end
        end
    end

    local previousInteriorId = GetInteriorFromEntity(PlayerPedId())
    if previousInteriorId ~= 0 then
        onEnteredInterior(previousInteriorId)
    end
    while true do
        local interiorId = GetInteriorFromEntity(PlayerPedId())
        if interiorId ~= previousInteriorId and interiorId ~= 0 then
            onEnteredInterior(interiorId)
        end
        previousInteriorId = interiorId
        Wait(100)
    end
end)