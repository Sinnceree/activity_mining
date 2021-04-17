-- Call event to assign you a mining zone
RegisterCommand("startmining", function(source, args)
  local canDoActivity = false
  local playerServerId = GetPlayerServerId(PlayerId())

  if Config.enableNopixelExports then
    canDoActivity = exports["np-activities"]:canDoActivity("activity_mining", playerServerId)
  else
    canDoActivity = true
  end

  if canDoActivity then
    TriggerServerEvent("np-mining:assignZone")
  else
    sendNotification("You cant do this actvity at this time.", playerServerId)
  end


end, false)

-- Call event to remove you from mining job
RegisterCommand("stopmining", function(source, args)
  TriggerEvent("np-mining:stopMining")
end, false)

-- RegisterCommand("genrock", function(source, args)
--   local playerPed = GetPlayerPed(-1)
--   TriggerServerEvent("np-mining:genRock", GetEntityCoords(playerPed))
-- end, false)