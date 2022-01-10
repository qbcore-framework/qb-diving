QBCore = exports['qb-core']:GetCoreObject()
local AvailableCoral = {}

-- Functions

local function InsertBoat(boatModel, Player, plate)
    MySQL.Async.insert('INSERT INTO player_boats (citizenid, model, plate) VALUES (?, ?, ?)', {Player.PlayerData.citizenid, boatModel, plate})
end

local function GetItemPrice(Item, price)
    if Item.amount > 5 then
        price = price / 100 * 80
    elseif Item.amount > 10 then
        price = price / 100 * 70
    elseif Item.amount > 15 then
        price = price / 100 * 50
    end
    return price
end

local function HasCoral(src)
    local Player = QBCore.Functions.GetPlayer(src)
    local retval = false
    AvailableCoral = {}
    for k, v in pairs(QBDiving.CoralTypes) do
        local Item = Player.Functions.GetItemByName(v.item)
        if Item ~= nil then
            AvailableCoral[#AvailableCoral+1] = v
            retval = true
        end
    end
    return retval
end

-- Events

RegisterNetEvent('qb-diving:server:SetBerthVehicle', function(BerthId, vehicleModel)
    TriggerClientEvent('qb-diving:client:SetBerthVehicle', -1, BerthId, vehicleModel)
    QBBoatshop.Locations["berths"][BerthId]["boatModel"] = boatModel
end)

RegisterNetEvent('qb-diving:server:SetDockInUse', function(BerthId, InUse)
    QBBoatshop.Locations["berths"][BerthId]["inUse"] = InUse
    TriggerClientEvent('qb-diving:client:SetDockInUse', -1, BerthId, InUse)
end)

RegisterNetEvent('qb-diving:server:BuyBoat', function(boatModel, BerthId)
    local BoatPrice = QBBoatshop.ShopBoats[boatModel]["price"]
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local PlayerMoney = {
        cash = Player.PlayerData.money.cash,
        bank = Player.PlayerData.money.bank
    }
    local missingMoney = 0
    local plate = "QB" .. math.random(1000, 9999)

    if PlayerMoney.cash >= BoatPrice then
        Player.Functions.RemoveMoney('cash', BoatPrice, "bought-boat")
        TriggerClientEvent('qb-diving:client:BuyBoat', src, boatModel, plate)
        InsertBoat(boatModel, Player, plate)
    elseif PlayerMoney.bank >= BoatPrice then
        Player.Functions.RemoveMoney('bank', BoatPrice, "bought-boat")
        TriggerClientEvent('qb-diving:client:BuyBoat', src, boatModel, plate)
        InsertBoat(boatModel, Player, plate)
    else
        if PlayerMoney.bank > PlayerMoney.cash then
            missingMoney = (BoatPrice - PlayerMoney.bank)
        else
            missingMoney = (BoatPrice - PlayerMoney.cash)
        end
        TriggerClientEvent('QBCore:Notify', src, 'Not Enough Money, You Are Missing $' .. missingMoney .. '', 'error')
    end
end)

RegisterNetEvent('qb-diving:server:RemoveItem', function(item, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(item, amount)
end)

RegisterNetEvent('qb-diving:server:SetBoatState', function(plate, state, boathouse, fuel)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local result = MySQL.Sync.fetchScalar('SELECT 1 FROM player_boats WHERE plate = ?', {plate})
    if result ~= nil then
        MySQL.Async.execute(
            'UPDATE player_boats SET state = ?, boathouse = ?, fuel = ? WHERE plate = ? AND citizenid = ?',
            {state, boathouse, fuel, plate, Player.PlayerData.citizenid})
    end
end)

RegisterNetEvent('qb-diving:server:CallCops', function(Coords)
    local src = source
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                local msg = "This coral may be stolen"
                TriggerClientEvent('qb-diving:client:CallCops', Player.PlayerData.source, Coords, msg)
                local alertData = {
                    title = "Illegal diving",
                    coords = {
                        x = Coords.x,
                        y = Coords.y,
                        z = Coords.z
                    },
                    description = msg
                }
                TriggerClientEvent("qb-phone:client:addPoliceAlert", -1, alertData)
            end
        end
    end
end)

RegisterNetEvent('qb-diving:server:SellCoral', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if HasCoral(src) then
        for k, v in pairs(AvailableCoral) do
            local Item = Player.Functions.GetItemByName(v.item)
            local price = (Item.amount * v.price)
            local Reward = math.ceil(GetItemPrice(Item, price))
            if Item.amount > 1 then
                for i = 1, Item.amount, 1 do
                    Player.Functions.RemoveItem(Item.name, 1)
                    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Item.name], "remove")
                    Player.Functions.AddMoney('cash', math.ceil((Reward / Item.amount)), "sold-coral")
                    Wait(250)
                end
            else
                Player.Functions.RemoveItem(Item.name, 1)
                Player.Functions.AddMoney('cash', Reward, "sold-coral")
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Item.name], "remove")
            end
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'You don\'t have any coral to sell..', 'error')
    end
end)

-- Callbacks

QBCore.Functions.CreateCallback('qb-diving:server:GetBusyDocks', function(source, cb)
    cb(QBBoatshop.Locations["berths"])
end)

QBCore.Functions.CreateCallback('qb-diving:server:GetMyBoats', function(source, cb, dock)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local result = MySQL.Sync.fetchAll('SELECT * FROM player_boats WHERE citizenid = ? AND boathouse = ?', {Player.PlayerData.citizenid, dock})
    if result[1] ~= nil then
        cb(result)
    else
        cb(nil)
    end
end)

QBCore.Functions.CreateCallback('qb-diving:server:GetDepotBoats', function(source, cb, dock)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local result = MySQL.Sync.fetchAll('SELECT * FROM player_boats WHERE citizenid = ? AND state = ?', {Player.PlayerData.citizenid, 0})
    if result[1] ~= nil then
        cb(result)
    else
        cb(nil)
    end
end)

-- Items

QBCore.Functions.CreateUseableItem("jerry_can", function(source, item)
    TriggerClientEvent("qb-diving:client:UseJerrycan", source)
end)

QBCore.Functions.CreateUseableItem("diving_gear", function(source, item)
    TriggerClientEvent("qb-diving:client:UseGear", source, true)
end)

-- Commands

QBCore.Commands.Add("divingsuit", "Take off your diving suit", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("qb-diving:client:UseGear", source, false)
end)
