Config = {}

Config.PizzaStart = vector3(807.59, -750.81, 26.78) -- Example location for starting job
Config.PizzaPed = 's_m_y_chef_01' -- Ped model for pizza job NPC
Config.PizzaVehicle = 'faggio' -- Delivery vehicle

Config.DeliveryLocations = {
    vector3(452.12, -662.19, 28.49),
    vector3(1150.95, -793.46, 57.60),
    vector3(-1487.21, -380.03, 40.16),
    vector3(-1227.12, -908.35, 12.33)
    -- Add more!
}

Config.Payment = {min = 200, max = 300}
Config.PizzaItem = 'pizza' -- Must exist in your qb-core/shared/items.lua