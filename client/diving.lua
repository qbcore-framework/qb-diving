local MaskModel = `p_d_scuba_mask_s`
local TankModel = `p_s_scuba_tank_s`
local ScubaProps = {}
local hasOxygenTank = false
local CurrentAir = nil

local CurrentDivingLocation = {
    Area = 0,
    Blip = {
        Radius = nil,
        Label = nil
    }
}

-- Functions

local function RequestModelHash(Model)
   RequestModel(Model)
	 while not HasModelLoaded(Model) do
		Wait(1)
   end
end

local function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(0)
    end
end

local function TakeCoral(coral)
    QBDiving.Locations[CurrentDivingLocation.Area].coords.Coral[coral].PickedUp = true
    TriggerServerEvent('qb-diving:server:TakeCoral', CurrentDivingLocation.Area, coral, true)
end

local function CallCops()
    local Call = math.random(1, 3)
    local Chance = math.random(1, 3)
    local Ped = PlayerPedId()
    local Coords = GetEntityCoords(Ped)
    if Call == Chance then
        TriggerServerEvent('qb-diving:server:CallCops', Coords)
    end
end

local function GearAnim()
    loadAnimDict("clothingshirt")
	TaskPlayAnim(PlayerPedId(), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end

-- Events

RegisterNetEvent('qb-diving:client:NewLocations', function()
    QBCore.Functions.TriggerCallback('qb-diving:server:GetDivingConfig', function(Config, Area)
        QBDiving.Locations = Config
        TriggerEvent('qb-diving:client:SetDivingLocation', Area)
    end)
end)

RegisterNetEvent('qb-diving:client:SetDivingLocation', function(DivingLocation)
    CurrentDivingLocation.Area = DivingLocation

    for _,Blip in pairs(CurrentDivingLocation.Blip) do
        if Blip ~= nil then
            RemoveBlip(Blip)
        end
    end

    CreateThread(function()
        RadiusBlip = AddBlipForRadius(QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.x, QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.y, QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.z, 100.0)

        SetBlipRotation(RadiusBlip, 0)
        SetBlipColour(RadiusBlip, 47)

        CurrentDivingLocation.Blip.Radius = RadiusBlip

        LabelBlip = AddBlipForCoord(QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.x, QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.y, QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.z)

        SetBlipSprite (LabelBlip, 597)
        SetBlipDisplay(LabelBlip, 4)
        SetBlipScale  (LabelBlip, 0.7)
        SetBlipColour(LabelBlip, 0)
        SetBlipAsShortRange(LabelBlip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName('Diving Area')
        EndTextCommandSetBlipName(LabelBlip)

        CurrentDivingLocation.Blip.Label = LabelBlip
    end)
end)

RegisterNetEvent('qb-diving:client:UpdateCoral', function(Area, Coral, Bool)
    QBDiving.Locations[Area].coords.Coral[Coral].PickedUp = Bool
end)

RegisterNetEvent('qb-diving:server:CallCops', function(Coords, msg)
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerEvent("chatMessage", "911 MESSAGE", "error", msg)
    local transG = 100
    local blip = AddBlipForRadius(Coords.x, Coords.y, Coords.z, 100.0)
    SetBlipSprite(blip, 9)
    SetBlipColour(blip, 1)
    SetBlipAlpha(blip, transG)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("911 - Dive site")
    EndTextCommandSetBlipName(blip)
    while transG ~= 0 do
        Wait(180 * 4)
        transG = transG - 1
        SetBlipAlpha(blip, transG)
        if transG == 0 then
            SetBlipSprite(blip, 2)
            RemoveBlip(blip)
            return
        end
    end
end)

RegisterNetEvent('qb-diving:client:UseGear', function(AirAmount)
    if not hasOxygenTank and AirAmount > 10 then
		LocalPlayer.state:set("inv_busy", true, true) -- Busy
		GearAnim()
		QBCore.Functions.Progressbar("equip_gear", "Put on a diving suit", 5000, false, true, {}, {}, {}, {}, function() -- Done
			CurrentAir = AirAmount
			hasOxygenTank = true
			RequestModelHash(TankModel)
			RequestModelHash(MaskModel)
			local TankObject = CreateObject(TankModel, 1.0, 1.0, 1.0, 1, 1, 0)
			AttachEntityToEntity(TankObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 24818), -0.25, -0.25, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
			ScubaProps[#ScubaProps+1] = TankObject
			local MaskObject = CreateObject(MaskModel, 1.0, 1.0, 1.0, 1, 1, 0)
			AttachEntityToEntity(MaskObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 12844), 0.0, 0.0, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
			ScubaProps[#ScubaProps+1] = MaskObject
			SetPedDiesInWater(PlayerPedId(), false)
			SetEnableScuba(PlayerPedId(), true)
			SetPedMaxTimeUnderwater(PlayerPedId(), 2000.00)
			TriggerServerEvent("QBCore:Server:RemoveItem", "diving_gear", 1)
			TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["diving_gear"], "remove")
			LocalPlayer.state:set("inv_busy", false, true) -- Not Busy
			ClearPedTasks(PlayerPedId())
			TriggerEvent('chatMessage', "SYSTEM", "error", "/divingsuit to take off your diving suit")
		end)
    else
        QBCore.Functions.Notify("Action not possible..", "error")
    end
end)

RegisterNetEvent('qb-diving:client:RemoveGear', function()
    if hasOxygenTank then
		GearAnim()
		QBCore.Functions.Progressbar("remove_gear", "Pull out a diving suit ..", 5000, false, true, {}, {}, {}, {}, function() -- Done
            for k, v in pairs(ScubaProps) do
                NetworkRequestControlOfEntity(v)
                SetEntityAsMissionEntity(v, true, true)
                DetachEntity(v, 1, 1)
                DeleteEntity(v)
                DeleteObject(v)
            end
            SetPedDiesInWater(PlayerPedId(), true)
            SetEnableScuba(PlayerPedId(), false)
			SetPedMaxTimeUnderwater(PlayerPedId(), 1.00)
            TriggerServerEvent('qb-diving:server:RemoveGear', CurrentAir)
			ClearPedTasks(PlayerPedId())
            CurrentAir, hasOxygenTank = nil, false
        end)
	else
		QBCore.Functions.Notify('You are not wearing a diving gear ..', 'error')
	end
end)

-- Threads

CreateThread(function()
    while true do
        Wait(4)
        if LocalPlayer.state.isLoggedIn then
            if hasOxygenTank then
                if CurrentAir > 10 then
                    CurrentAir = CurrentAir - 10
                    Wait(30000)
                    if hasOxygenTank then
                        if CurrentAir < 10 then
                            SetPedDiesInWater(PlayerPedId(), true)
                            SetEnableScuba(PlayerPedId(), false)
                            QBCore.Functions.Notify("Your air tank is empty you are drowning..", "error")
                        end
                    end
                end
            end
        else
            Wait(1500)
        end
    end
end)

CreateThread(function()
    while true do
        local inRange = false
        local Ped = PlayerPedId()
        local Pos = GetEntityCoords(Ped)
        if CurrentDivingLocation.Area ~= 0 then
            local AreaDistance = #(Pos - vector3(QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.x, QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.y, QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.z))
            local CoralDistance = nil
            if AreaDistance < 100 then
                inRange = true
            end
            if inRange then
                for cur, CoralLocation in pairs(QBDiving.Locations[CurrentDivingLocation.Area].coords.Coral) do
                    CoralDistance = #(Pos - vector3(CoralLocation.coords.x, CoralLocation.coords.y, CoralLocation.coords.z))
                    if CoralDistance ~= nil then
                        if CoralDistance <= 30 then
                            if not CoralLocation.PickedUp then
                                DrawMarker(32, CoralLocation.coords.x, CoralLocation.coords.y, CoralLocation.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 1.0, 0.4, 255, 223, 0, 255, true, false, false, false, false, false, false)
                                if CoralDistance <= 1.5 then
                                    DrawText3D(CoralLocation.coords.x, CoralLocation.coords.y, CoralLocation.coords.z, '[E] Collecting coral')
                                    if IsControlJustPressed(0, 38) then
                                        -- loadAnimDict("pickup_object")
                                        local times = math.random(2, 5)
                                        CallCops()
                                        FreezeEntityPosition(Ped, true)
                                        QBCore.Functions.Progressbar("take_coral", "Collecting coral", times * 1000, false, true, {
                                            disableMovement = true,
                                            disableCarMovement = true,
                                            disableMouse = false,
                                            disableCombat = true,
                                        }, {
                                            animDict = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@",
                                            anim = "plant_floor",
                                            flags = 16,
                                        }, {}, {}, function() -- Done
                                            TakeCoral(cur)
                                            ClearPedTasks(Ped)
                                            FreezeEntityPosition(Ped, false)
                                        end, function() -- Cancel
                                            ClearPedTasks(Ped)
                                            FreezeEntityPosition(Ped, false)
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        if not inRange then
            Wait(2500)
        end
        Wait(3)
    end
end)

local function hasOxygenTankOn()
    return hasOxygenTank
end

exports('hasOxygenTankOn', hasOxygenTankOn)
