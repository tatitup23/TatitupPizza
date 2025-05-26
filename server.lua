local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-pizzajob:server:givePizza', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.AddItem(Config.PizzaItem, 1, false)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.PizzaItem], "add")
    end
end)

RegisterNetEvent('qb-pizzajob:server:deliverPizza', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        if Player.Functions.RemoveItem(Config.PizzaItem, 1, false) then
            local reward = math.random(Config.Payment.min, Config.Payment.max)
            Player.Functions.AddMoney('cash', reward, "pizza-delivery")
            TriggerClientEvent('QBCore:Notify', src, 'Pizza delivered! You earned $'..reward, "success")
            -- Optionally: Give another pizza box for next delivery
            Player.Functions.AddItem(Config.PizzaItem, 1, false)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.PizzaItem], "add")
        else
            TriggerClientEvent('QBCore:Notify', src, 'You have no pizza to deliver!', "error")
        end
    end
end)