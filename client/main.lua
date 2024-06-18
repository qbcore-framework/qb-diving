local QBCore = exports['qb-core']:GetCoreObject()
local isLoggedIn = LocalPlayer.state['isLoggedIn']
local Zones = {}
local CurrentArea = 0
local inSellerZone = false
local isWearingSuit = false
local OxygenLevel = 0

local CurrentDivingLocation = {
    area = 0,
    blip = {
        radius = nil,
        label = nil
    }
}

local CurrentGear = {
    mask = 0,
    tank = 0,
    oxygen = 0,
    enabled = false
}

-- Functions
local function callCops()
    local call = math.random(1, 3)
    local chance = math.random(1, 3)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    if call == chance then
        TriggerServerEvent('qb-diving:server:CallCops', coords)
    end
end

local function deleteGear()
	if CurrentGear.mask ~= 0 then
        DetachEntity(CurrentGear.mask, false, true)
        DeleteEntity(CurrentGear.mask)
		CurrentGear.mask = 0
    end
	if CurrentGear.tank ~= 0 then
        DetachEntity(CurrentGear.tank, false, true)
        DeleteEntity(CurrentGear.tank)
		CurrentGear.tank = 0
	end
end

local function gearAnim()
    RequestAnimDict("clothingshirt")
    while not HasAnimDictLoaded("clothingshirt") do
        Wait(0)
    end
	TaskPlayAnim(PlayerPedId(), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end

local function takeCoral(coral)
    if Config.CoralLocations[CurrentDivingLocation.area].coords.Coral[coral].PickedUp then return end
    local ped = PlayerPedId()
    local times = math.random(2, 5)
    if math.random() > Config.CopsChance then callCops() end
    FreezeEntityPosition(ped, true)
    QBCore.Functions.Progressbar("take_coral", Lang:t("info.collecting_coral"), times * 1000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@",
        anim = "plant_floor",
        flags = 16,
    }, {}, {}, function() -- Done
        Config.CoralLocations[CurrentDivingLocation.area].coords.Coral[coral].PickedUp = true
        TriggerServerEvent('qb-diving:server:TakeCoral', CurrentDivingLocation.area, coral, true)
        ClearPedTasks(ped)
        FreezeEntityPosition(ped, false)
    end, function() -- Cancel
        ClearPedTasks(ped)
        FreezeEntityPosition(ped, false)
    end)
end

local function setDivingLocation(divingLocation)
    if CurrentDivingLocation.area ~= 0 then
        for k in pairs(Config.CoralLocations[CurrentDivingLocation.area].coords.Coral) do
            if Config.UseTarget then
                exports['qb-target']:RemoveZone(k)
            else
                if next(Zones) then Zones[k]:destroy() end
            end
        end
    end
    CurrentDivingLocation.area = divingLocation
    for _, blip in pairs(CurrentDivingLocation.blip) do if blip then RemoveBlip(blip) end end
    local radiusBlip = AddBlipForRadius(Config.CoralLocations[CurrentDivingLocation.area].coords.Area, 100.0)
    SetBlipRotation(radiusBlip, 0)
    SetBlipColour(radiusBlip, 47)
    CurrentDivingLocation.blip.radius = radiusBlip
    local labelBlip = AddBlipForCoord(Config.CoralLocations[CurrentDivingLocation.area].coords.Area)
    SetBlipSprite(labelBlip, 597)
    SetBlipDisplay(labelBlip, 4)
    SetBlipScale(labelBlip, 0.7)
    SetBlipColour(labelBlip, 0)
    SetBlipAsShortRange(labelBlip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(Lang:t("info.diving_area"))
    EndTextCommandSetBlipName(labelBlip)
    CurrentDivingLocation.blip.label = labelBlip
    for k, v in pairs(Config.CoralLocations[CurrentDivingLocation.area].coords.Coral) do
        if Config.UseTarget then
            exports['qb-target']:AddBoxZone('diving_coral_zone_'..k, v.coords, v.length, v.width, {
                name = 'diving_coral_zone_'..k,
                heading = v.heading,
                debugPoly = false,
                minZ = v.coords.z - 3,
                maxZ = v.coords.z + 2
            }, {
                options = {
                    {
                        label = Lang:t("info.collect_coral"),
                        icon = 'fa-solid fa-water',
                        action = function()
                            takeCoral(k)
                        end
                    }
                },
                distance = 2.0
            })
        else
            Zones[k] = BoxZone:Create(v.coords, v.length, v.width, {
                name = 'diving_coral_zone_'..k,
                heading = v.heading,
                debugPoly = false,
                minZ = v.coords.z - 3,
                maxZ = v.coords.z + 2
            })
            Zones[k]:onPlayerInOut(function(inside)
                if inside then
                    CurrentArea = k
                    exports['qb-core']:DrawText(Lang:t("info.collect_coral_dt"))
                else
                    CurrentArea = 0
                    exports['qb-core']:HideText()
                end
            end)
        end
    end
end

local function sellCoral()
    local playerPed = PlayerPedId()
    LocalPlayer.state:set("inv_busy", true, true)
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_STAND_IMPATIENT", 0, true)
    QBCore.Functions.Progressbar("sell_coral_items", Lang:t("info.checking_pockets"), math.random(2000, 4000), false, true, {}, {}, {}, {}, function() -- Done
        ClearPedTasks(playerPed)
        TriggerServerEvent('qb-diving:server:SellCoral')
        LocalPlayer.state:set("inv_busy", false, true)
    end, function() -- Cancel
        ClearPedTasksImmediately(playerPed)
        QBCore.Functions.Notify(Lang:t("error.canceled"), "error")
        LocalPlayer.state:set("inv_busy", false, true)
    end)
end

local function createSeller()
    for i = 1, #Config.SellLocations do
        local current = Config.SellLocations[i]
        current.model = type(current.model) == 'string' and joaat(current.model) or current.model
        RequestModel(current.model)
        while not HasModelLoaded(current.model) do
            Wait(0)
        end
        local currentCoords = vector4(current.coords.x, current.coords.y, current.coords.z - 1, current.coords.w)
        local ped = CreatePed(0, current.model, currentCoords, false, false)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        if Config.UseTarget then
            exports['qb-target']:AddTargetEntity(ped, {
                options = {
                    {
                        label = Lang:t("info.sell_coral"),
                        icon = 'fa-solid fa-dollar-sign',
                        action = function()
                            sellCoral()
                        end
                    }
                },
                distance = 2.0
            })
        else
            local zone = BoxZone:Create(current.coords.xyz, current.zoneOptions.length, current.zoneOptions.width, {
                name = 'diving_coral_seller_'..i,
                heading = current.coords.w,
                debugPoly = false,
                minZ = current.coords.z - 1.5,
                maxZ = current.coords.z + 1.5
            })
            zone:onPlayerInOut(function(inside)
                if inside then
                    inSellerZone = true
                    exports['qb-core']:DrawText(Lang:t("info.sell_coral_dt"))
                else
                    inSellerZone = false
                    exports['qb-core']:HideText()
                end
            end)
        end
    end
end

-- Events

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.TriggerCallback('qb-diving:server:GetDivingConfig', function(config, area)
        Config.CoralLocations = config
        setDivingLocation(area)
        createSeller()
        isLoggedIn = true
    end)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('qb-diving:client:NewLocations', function()
    QBCore.Functions.TriggerCallback('qb-diving:server:GetDivingConfig', function(config, area)
        Config.CoralLocations = config
        setDivingLocation(area)
    end)
end)

RegisterNetEvent('qb-diving:client:UpdateCoral', function(area, coral, bool)
    Config.CoralLocations[area].coords.Coral[coral].PickedUp = bool
end)

RegisterNetEvent('qb-diving:client:CallCops', function(coords, msg)
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerEvent("chatMessage", Lang:t("error.911_chatmessage"), "error", msg)
    local transG = 100
    local blip = AddBlipForRadius(coords.x, coords.y, coords.z, 100.0)
    SetBlipSprite(blip, 9)
    SetBlipColour(blip, 1)
    SetBlipAlpha(blip, transG)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(Lang:t("info.blip_text"))
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

RegisterNetEvent("qb-diving:client:SetOxygenLevel", function()
    if OxygenLevel == 0 then
       OxygenLevel = Config.OxygenLevel -- oxygenlevel
       QBCore.Functions.Notify(Lang:t("success.tube_filled"), 'success')
       TriggerServerEvent('qb-diving:server:removeItemAfterFill')
    else
        QBCore.Functions.Notify(Lang:t("error.oxygenlevel", {oxygenlevel = OxygenLevel}), 'error')
    end
end)

function DrawText2(text)
	SetTextFont(4)
	SetTextProportional(true)
	SetTextScale(0.0, 0.45)
	SetTextDropshadow(1, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.45, 0.90)
end

RegisterNetEvent('qb-diving:client:UseGear', function()
    local ped = PlayerPedId()
    if isWearingSuit == false then
        if OxygenLevel > 0 then
            isWearingSuit = true
            if not IsPedSwimming(ped) and not IsPedInAnyVehicle(ped, false) then
                gearAnim()
                QBCore.Functions.Progressbar("equip_gear", Lang:t("info.put_suit"), 5000, false, true, {}, {}, {}, {},
                    function() -- Done
                        deleteGear()
                        local maskModel = `p_d_scuba_mask_s`
                        local tankModel = `p_s_scuba_tank_s`
                        RequestModel(tankModel)
                        while not HasModelLoaded(tankModel) do
                            Wait(0)
                        end
                        CurrentGear.tank = CreateObject(tankModel, 1.0, 1.0, 1.0, 1, 1, 0)
                        local bone1 = GetPedBoneIndex(ped, 24818)
                        AttachEntityToEntity(CurrentGear.tank, ped, bone1, -0.25, -0.25, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)

                        RequestModel(maskModel)
                        while not HasModelLoaded(maskModel) do
                            Wait(0)
                        end
                        CurrentGear.mask = CreateObject(maskModel, 1.0, 1.0, 1.0, 1, 1, 0)
                        local bone2 = GetPedBoneIndex(ped, 12844)
                        AttachEntityToEntity(CurrentGear.mask, ped, bone2, 0.0, 0.0, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
                        SetEnableScuba(ped, true)
                        SetPedMaxTimeUnderwater(ped, 2000.00)
                        CurrentGear.enabled = true
                        ClearPedTasks(ped)
                        TriggerServerEvent("InteractSound_SV:PlayOnSource", "breathdivingsuit", 0.25)
                        OxygenLevel = OxygenLevel
                        CreateThread(function()
                            while CurrentGear.enabled do
                                if IsPedSwimmingUnderWater(PlayerPedId()) then
                                    OxygenLevel = OxygenLevel - 1

                                    if OxygenLevel % 10 == 0 and OxygenLevel <= 90 and OxygenLevel > 0 then
                                        TriggerServerEvent("InteractSound_SV:PlayOnSource", "breathdivingsuit", 0.25)
                                    elseif OxygenLevel == 0 then
                                        if Config.RemoveDivingGear then deleteGear() end
                                        SetEnableScuba(ped, false)
                                        SetPedMaxTimeUnderwater(ped, 1.00)
                                        CurrentGear.enabled = false
                                        isWearingSuit = false                                        
                                        return
                                    end
                                end
                                Wait(1000)
                            end
                        end)
                    end)
            else
                QBCore.Functions.Notify(Lang:t("error.not_standing_up"), 'error')
            end
        else
            QBCore.Functions.Notify(Lang:t("error.need_otube"), 'error')
        end
    elseif isWearingSuit == true then
        gearAnim()
        QBCore.Functions.Progressbar("remove_gear", Lang:t("info.pullout_suit"), 5000, false, true, {}, {}, {}, {}, function() -- Done
            SetEnableScuba(ped, false)
            SetPedMaxTimeUnderwater(ped, 50.00)
            CurrentGear.enabled = false
            ClearPedTasks(ped)
            deleteGear()
            QBCore.Functions.Notify(Lang:t("success.took_out"))
            TriggerServerEvent("InteractSound_SV:PlayOnSource", nil, 0.25)
            isWearingSuit = false
            OxygenLevel = OxygenLevel
        end)
    end
end)

-- Threads

CreateThread(function()
    if isLoggedIn then
        QBCore.Functions.TriggerCallback('qb-diving:server:GetDivingConfig', function(config, area)
            Config.CoralLocations = config
            setDivingLocation(area)
            createSeller()
        end)
    end

    if Config.UseTarget then return end

    while true do
        local sleep = 1000
        if isLoggedIn then
            if CurrentArea ~= 0 then
                sleep = 0
                if IsControlJustPressed(0, 51) then -- E
                    takeCoral(CurrentArea)
                    exports['qb-core']:KeyPressed()
                    Wait(500)
                    exports['qb-core']:HideText()
                    sleep = 3000
                end
            end

            if inSellerZone then
                sleep = 0
                if IsControlJustPressed(0, 51) then -- E
                    sellCoral()
                    exports['qb-core']:KeyPressed()
                    Wait(500)
                    exports['qb-core']:HideText()
                    sleep = 3000
                end
            end
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        if CurrentGear.enabled == true and isWearingSuit == true and OxygenLevel > 0 then
            if IsPedSwimmingUnderWater(PlayerPedId()) then
                DrawText2(OxygenLevel..'⏱')
            end
        end
    end
end)
