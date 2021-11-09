local notInteressted = false

local function ClearTimeOut()
    notInteressted = not notInteressted
end

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inRange = false

        if not notInteressted then
            for k, v in pairs(QBDiving.SellLocations) do
                local dist = #(pos - vector3(v["coords"]["x"], v["coords"]["y"], v["coords"]["z"]))

                if dist < 20 then
                    inRange = true
                    if dist < 1 then
                        DrawText3D(v["coords"]["x"], v["coords"]["y"], v["coords"]["z"] - 0.1, '~g~G~w~ - Selling Coral')
                        if IsControlJustPressed(0, 47) then
                            LocalPlayer.state:set("inv_busy", true, true)
                            TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_STAND_IMPATIENT", 0, true)
                            QBCore.Functions.Progressbar("sell_coral_items", "Check Pockets To Sell Coral", math.random(2000, 4000), false, true, {}, {}, {}, {}, function() -- Done
                                ClearPedTasks(PlayerPedId())
                                TriggerServerEvent('qb-diving:server:SellCoral')
                                notInteressted = true
                                SetTimeout(0, ClearTimeOut)
                                LocalPlayer.state:set("inv_busy", false, true)
                            end, function() -- Cancel
                                ClearPedTasks(PlayerPedId())
                                QBCore.Functions.Notify("Canceled..", "error")
                                LocalPlayer.state:set("inv_busy", false, true)
                            end)
                        end
                    end
                end
            end
        else
            Wait(5000)
        end

        if not inRange then
            Wait(1500)
        end

        Wait(3)
    end
end)