-- Commands
RegisterCommand("startmining", function(source, args)
  print("Want to mine")
  TriggerEvent("np-mining:startMining", source)
end, false)

-- Commands
RegisterCommand("stopmining", function(source, args)
  TriggerEvent("np-mining:stopMining", source)
end, false)