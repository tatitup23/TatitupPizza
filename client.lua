local QBCore = exports['qb-core']:GetCoreObject()
local onJob = false
local currentBlip = nil
local deliveryCoords = nil

-- Create Start NPC
Citizen.CreateThread(function()
    RequestModel(Config.PizzaPed)
    while not HasModelLoaded(Config.PizzaPed) do
        Wait(10)
    end
    local npc = CreatePed(4, Config.PizzaPed, Config.PizzaStart.x, Config.PizzaStart.y, Config.PizzaStart.z-1, 250.0, false, true)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
end)

-- Marker and interaction
Citizen.CreateThread(function()
    while true do
        Wait(1)
        local pos = GetEntityCoords(PlayerPedId())
        if #(pos - Config.PizzaStart) < 2.5 then
            DrawMarker(2, Config.PizzaStart.x, Config.PizzaStart.y, Config.PizzaStart.z+0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.3, 255, 140, 0, 200, false, true, 2, false, nil, nil, false)
            QBCore.Functions.DrawText3D(Config.PizzaStart.x, Config.PizzaStart.y, Config.PizzaStart.z+1.0, '[E] Start/Stop Pizza Job')
            if IsControlJustReleased(0, 38) then
                if not onJob then
                    StartPizzaJob()
                else
                    EndPizzaJob()
                end
            end
        else
            Wait(500)
        end
    end
end)

function StartPizzaJob()
    onJob = true
    QBCore.Functions.Notify('Pizza job started! Vehicle spawned.', 'success')
    TriggerServerEvent('qb-pizzajob:server:givePizza')
    -- Spawn vehicle
    QBCore.Functions.SpawnVehicle(Config.PizzaVehicle, function(veh)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        SetVehicleNumberPlateText(veh, "PIZZA"..tostring(math.random(100,999)))
        SetEntityAsMissionEntity(veh, true, true)
    end, Config.PizzaStart, true)
    SetNewDelivery()
end

function SetNewDelivery()
    deliveryCoords = Config.DeliveryLocations[math.random(#Config.DeliveryLocations)]
    if currentBlip then RemoveBlip(currentBlip) end
    currentBlip = AddBlipForCoord(deliveryCoords)
    SetBlipSprite(currentBlip, 1)
    SetBlipColour(currentBlip, 2)
    SetBlipScale(currentBlip, 0.8)
    SetBlipRoute(currentBlip, true)
    QBCore.Functions.Notify('Deliver the pizza to the marked location!', 'primary')
end

Citizen.CreateThread(function()
    while true do
        Wait(1500)
        if onJob and deliveryCoords then
            local pos = GetEntityCoords(PlayerPedId())
            if #(pos - deliveryCoords) < 4.0 then
                QBCore.Functions.DrawText3D(deliveryCoords.x, deliveryCoords.y, deliveryCoords.z+1.0, '[E] Deliver Pizza')
                if IsControlJustReleased(0, 38) then
                    TriggerServerEvent('qb-pizzajob:server:deliverPizza')
                    SetNewDelivery()
                end
            end
        else
            Wait(2000)
        end
    end
end)

function EndPizzaJob()
    onJob = false
    if currentBlip then
        RemoveBlip(currentBlip)
        currentBlip = nil
    end
    QBCore.Functions.Notify('Pizza job ended!', 'error')
    -- Optionally: Delete pizza vehicle
end