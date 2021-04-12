-- Commands
RegisterCommand("startmining", function(source, args)
  print("Want to mine")
  TriggerEvent("np-mining:startMining", source)
end, false)