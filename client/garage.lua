local CurrentDock = nil
local ClosestDock = nil
local PoliceBlip = nil
local p = nil

-- Functions
function FetchBoathouse()
    if p then return end
    p = promise.new()
    QBCore.Functions.TriggerCallback("qb-diving:server:GetMyBoats", function(result)
        p:resolve(result)
    end, CurrentDock)
    return Citizen.Await(p)
end

function FetchDepot()
    if p then return end
    p = promise.new()
    QBCore.Functions.TriggerCallback("qb-diving:server:GetDepotBoats", function(result)
        p:resolve(result)
    end)
    return Citizen.Await(p)
end

function MenuBoatDepot()
    local depotResult = FetchDepot()
    p = nil

    if depotResult == nil then
        QBCore.Functions.Notify("You have no vehicles in this Depot", "error", 5000)
        CloseMenu()
    else
        local depotMenu = {
            {
                header = "Your Boats",
                isMenuHeader = true
            }
        }

        for k, v in pairs(depotResult) do
            local currentFuel = v.fuel
            local state = "In Boathouse"

            if v.state == 0 then
                state = "In Depot"
            end
            depotMenu[#depotMenu+1] = {
                header = QBBoatshop.ShopBoats[v.model]["label"],
                txt = "State: "..state.."<br>Fuel: "..currentFuel,
                params = {
                    event = "diving:client:TakeOutDepot",
                    args = {
                        boat = v
                    }
                }
            }

        end
        depotMenu[#depotMenu+1] = {
            header = "⬅ Close Menu",
            txt = "",
            params = {
                event = "qb-menu:client:closeMenu"
            }

        }
        exports['qb-menu']:openMenu(depotMenu)
    end

end

function MenuGarage()
    local boathouseResult = FetchBoathouse()
    p = nil

    if boathouseResult == nil then
        QBCore.Functions.Notify("You have no vehicles in this Boathouse", "error", 5000)
        CloseMenu()
    else
        local boathouseMenu = {
            {
                header = "Your Boats",
                isMenuHeader = true
            }
        }
        for k, v in pairs(boathouseResult) do
            local currentFuel = v.fuel
            local state = "Impounded"
            if v.state == 0 then
                state = "In Depot"
            elseif v.state == 1 then
                state = "In Boathouse"
            end
            boathouseMenu[#boathouseMenu+1] = {
                header = QBBoatshop.ShopBoats[v.model]["label"],
                txt = "State: "..state.."<br>Fuel: "..currentFuel,
                params = {
                    event = "diving:client:TakeOutBoathouse",
                    args = {
                        boat = v
                    }
                }
            }

        end

        boathouseMenu[#boathouseMenu+1] = {
            header = "⬅ Close Menu",
            txt = "",
            params = {
                event = "qb-menu:client:closeMenu"
            }

        }
        exports['qb-menu']:openMenu(boathouseMenu)
    end

end

function CloseMenu()
    exports['qb-menu']:closeMenu()
end

local function RemoveVehicle()
    local ped = PlayerPedId()
    local Boat = IsPedInAnyBoat(ped)

    if Boat then
        local CurVeh = GetVehiclePedIsIn(ped)
        local totalFuel = exports['LegacyFuel']:GetFuel(CurVeh)
        TriggerServerEvent('qb-diving:server:SetBoatState', QBCore.Functions.GetPlate(CurVeh), 1, ClosestDock, totalFuel)

        QBCore.Functions.DeleteVehicle(CurVeh)
        SetEntityCoords(ped, QBBoatshop.Docks[ClosestDock].coords.take.x, QBBoatshop.Docks[ClosestDock].coords.take.y, QBBoatshop.Docks[ClosestDock].coords.take.z)
    end
end

-- Events

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    if PlayerJob.name == "police" then
        if PoliceBlip ~= nil then
            RemoveBlip(PoliceBlip)
        end
        PoliceBlip = AddBlipForCoord(QBBoatshop.PoliceBoat.x, QBBoatshop.PoliceBoat.y, QBBoatshop.PoliceBoat.z)
        SetBlipSprite(PoliceBlip, 410)
        SetBlipDisplay(PoliceBlip, 4)
        SetBlipScale(PoliceBlip, 0.8)
        SetBlipAsShortRange(PoliceBlip, true)
        SetBlipColour(PoliceBlip, 29)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Police Boats")
        EndTextCommandSetBlipName(PoliceBlip)
    end
end)

RegisterNetEvent('diving:client:TakeOutBoathouse', function(data)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local putVec3 = vector3(QBBoatshop.Docks[CurrentDock].coords.take.x, QBBoatshop.Docks[CurrentDock].coords.take.y, QBBoatshop.Docks[CurrentDock].coords.take.z)
    if #(pos - putVec3) <= 1 then
        local vehicle = data.boat
        QBCore.Functions.SpawnVehicle(vehicle.model, function(veh)
            SetVehicleNumberPlateText(veh, vehicle.plate)
            SetEntityHeading(veh, QBBoatshop.Docks[CurrentDock].coords.put.w)
            exports['LegacyFuel']:SetFuel(veh, vehicle.fuel)
            CloseMenu()
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
            SetVehicleEngineOn(veh, true, true)
        end, QBBoatshop.Docks[CurrentDock].coords.put, true)
    else
        QBCore.Functions.Notify('You are to far away', 'error')
    end
end)

RegisterNetEvent('diving:client:TakeOutDepot', function(data)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local putVec3 = vector3(QBBoatshop.Docks[CurrentDock].coords.take.x, QBBoatshop.Docks[CurrentDock].coords.take.y, QBBoatshop.Docks[CurrentDock].coords.take.z)
    if #(pos - putVec3) <= 1 then
        local vehicle = data.boat
        if vehicle.state == 1 then
            QBCore.Functions.SpawnVehicle(vehicle.model, function(veh)
                SetVehicleNumberPlateText(veh, vehicle.plate)
                SetEntityHeading(veh, QBBoatshop.Docks[CurrentDock].coords.put.w)
                exports['LegacyFuel']:SetFuel(veh, vehicle.fuel)
                QBCore.Functions.Notify("vehicle Out: Fuel: "..currentFuel.. "%", "primary", 4500)
                TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
                SetVehicleEngineOn(veh, true, true)
                TriggerServerEvent('qb-diving:server:SetBoatState', QBCore.Functions.GetPlate(veh), 0, CurrentDock, 100)
                CloseMenu()
            end, QBBoatshop.Docks[CurrentDock].coords.put, true)
        else
            QBCore.Functions.Notify("The boat is not in the boathouse", "error", 4500)
        end
    else
        QBCore.Functions.Notify('You are to far away', 'error')
    end
end)

-- Threads

CreateThread(function()
    while true do
        local sleep = 1000
        if LocalPlayer.state.isLoggedIn then
            local inRange = false
            local Ped = PlayerPedId()
            local Pos = GetEntityCoords(Ped)

            for k, v in pairs(QBBoatshop.Docks) do
                local TakeDistance = #(Pos - vector3(v.coords.take.x, v.coords.take.y, v.coords.take.z))

                if TakeDistance < 50 then
                    ClosestDock = k
                    inRange = true
                    PutDistance = #(Pos - vector3(v.coords.put.x, v.coords.put.y, v.coords.put.z))

                    local inBoat = IsPedInAnyBoat(Ped)

                    if inBoat then
                        DrawMarker(35, v.coords.put.x, v.coords.put.y, v.coords.put.z + 0.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.7, 1.7, 1.7, 255, 55, 15, 255, false, false, false, true, false, false, false)
                        if PutDistance < 2 then
                            if inBoat then
                                DrawText3D(v.coords.put.x, v.coords.put.y, v.coords.put.z, '~g~E~w~ - Store Boat')
                                if IsControlJustPressed(0, 38) then
                                    RemoveVehicle()
                                end
                            end
                        end
                    end

                    if not inBoat then
                        DrawMarker(2, v.coords.take.x, v.coords.take.y, v.coords.take.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.5, -0.30, 15, 255, 55, 255, false, false, false, true, false, false, false)
                        if TakeDistance < 2 then
                            DrawText3D(v.coords.take.x, v.coords.take.y, v.coords.take.z, '~g~E~w~ - Boat Garage')
                            if IsControlJustPressed(1, 177) then
                                CloseMenu()
                                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                                CurrentDock = nil
                            elseif IsControlJustPressed(0, 38) then
                                CurrentDock = k
                                MenuGarage()

                            end

                        end
                    end
                elseif TakeDistance > 51 then
                    if ClosestDock ~= nil then
                        ClosestDock = nil
                    end
                end
            end

            for k, v in pairs(QBBoatshop.Depots) do
                local TakeDistance = #(Pos - vector3(v.coords.take.x, v.coords.take.y, v.coords.take.z))

                if TakeDistance < 50 then
                    ClosestDock = k
                    inRange = true
                    PutDistance = #(Pos - vector3(v.coords.put.x, v.coords.put.y, v.coords.put.z))

                    local inBoat = IsPedInAnyBoat(Ped)

                    if not inBoat then
                        DrawMarker(2, v.coords.take.x, v.coords.take.y, v.coords.take.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.5, -0.30, 15, 255, 55, 255, false, false, false, true, false, false, false)
                        if TakeDistance < 2 then
                            DrawText3D(v.coords.take.x, v.coords.take.y, v.coords.take.z, '~g~E~w~ -Boat storage')
                            if IsControlJustPressed(1, 177) then
                                CloseMenu()
                                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                                CurrentDock = nil
                            elseif IsControlJustPressed(0, 38)then
                                CurrentDock = k
                                MenuBoatDepot()
                            end

                        end
                    end
                elseif TakeDistance > 51 then
                    if ClosestDock ~= nil then
                        ClosestDock = nil
                    end
                end
            end

            sleep = 5
            if not inRange then
                sleep = 1000
            end
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    for k, v in pairs(QBBoatshop.Docks) do
        local DockGarage = AddBlipForCoord(v.coords.put.x, v.coords.put.y, v.coords.put.z)
        SetBlipSprite (DockGarage, 410)
        SetBlipDisplay(DockGarage, 4)
        SetBlipScale  (DockGarage, 0.8)
        SetBlipAsShortRange(DockGarage, true)
        SetBlipColour(DockGarage, 3)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(v.label)
        EndTextCommandSetBlipName(DockGarage)
    end

    for k, v in pairs(QBBoatshop.Depots) do
        local BoatDepot = AddBlipForCoord(v.coords.take.x, v.coords.take.y, v.coords.take.z)
        SetBlipSprite (BoatDepot, 410)
        SetBlipDisplay(BoatDepot, 4)
        SetBlipScale  (BoatDepot, 0.8)
        SetBlipAsShortRange(BoatDepot, true)
        SetBlipColour(BoatDepot, 3)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(v.label)
        EndTextCommandSetBlipName(BoatDepot)
    end
end)