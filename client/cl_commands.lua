-- Commands
RegisterCommand("startmining", function(source, args)
  TriggerServerEvent("np-mining:assignZone")
end, false)

-- Commands
RegisterCommand("stopmining", function(source, args)
  TriggerEvent("np-mining:stopMining")
end, false)

local rock = nil
RegisterCommand("spawnrock", function(source, args)
  Citizen.CreateThread(function()
    local playerPed = GetPlayerPed(-1)
    local playerCoord = GetEntityCoords(playerPed)

    -- print("z " .. GetGroundZFor_3dCoord(playerCoord["x"], playerCoord["y"], playerCoord["z"], false))
    -- rock = CreateObject(GetHashKey("prop_rock_3_d"), playerCoord["x"], playerCoord["y"], playerCoord["z"], true, true, false)
    -- print("spawning rock " .. rock)
    -- FreezeEntityPosition(rock, true)
  
    -- Citizen.Wait(5000)
    -- DetachEntity(rock, 1, true)
    -- DeleteEntity(rock)
    -- DeleteObject(rock)
    rock = CreateObject(GetHashKey("v_res_fa_crystal01"), playerCoord["x"], playerCoord["y"], playerCoord["z"], true, true, false)
    FreezeEntityPosition(rock, true)


  end)
end, false)

RegisterCommand("genrock", function(source, args)
  local playerPed = GetPlayerPed(-1)
  TriggerServerEvent("np-mining:genRock", GetEntityCoords(playerPed))
end, false)