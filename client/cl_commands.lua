-- Call event to assign you a mining zone
RegisterCommand("startmining", function(source, args)
  TriggerServerEvent("np-mining:assignZone")
end, false)

-- Call event to remove you from mining job
RegisterCommand("stopmining", function(source, args)
  TriggerEvent("np-mining:stopMining")
end, false)

-- RegisterCommand("genrock", function(source, args)
--   local playerPed = GetPlayerPed(-1)
--   TriggerServerEvent("np-mining:genRock", GetEntityCoords(playerPed))
-- end, false)