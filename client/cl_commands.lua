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
    rock = CreateObject(GetHashKey("v_res_fa_crystal01"), playerCoord["x"], playerCoord["y"], playerCoord["z"], true, true, false)
    FreezeEntityPosition(rock, true)
  end)
end, false)

RegisterCommand("genrock", function(source, args)
  local playerPed = GetPlayerPed(-1)
  TriggerServerEvent("np-mining:genRock", GetEntityCoords(playerPed))
end, false)