local miningZone = BoxZone:Create(vector3(435.18, 2016.35, 110.49), 20, 20, {
  name="mining_zone",
  heading=340,
  debugPoly=true,
  minZ=106.69,
  maxZ=114.29
})



local miningStatus = ""
local mining = false
local insideMiningZone = false

Citizen.CreateThread(function()
    while true do
        local plyPed = PlayerPedId()
        local coord = GetEntityCoords(plyPed)
        insideMiningZone = miningZone:isPointInside(coord)
        if insideMiningZone and mining then
          miningStatus = "You can start mining now"
        else
          miningStatus = "Please enter a mining zone"
        end
        Citizen.Wait(500)
    end
end)


Citizen.CreateThread(function()
  while true do
      if mining then
        showText(miningStatus)
      end
      Citizen.Wait(1)
  end
end)

local hasRock = nil








-- Event Handlers
RegisterNetEvent("np-mining:startMining")
AddEventHandler("np-mining:startMining", function(source)
  if not mining then
    mining = true
    print("Wanting to start mining " .. source)
  end
  
end)

function showText(message)
  SetTextFont(0)
  SetTextProportional(1)
  SetTextScale(0.0, 0.5)
  SetTextColour(128, 128, 128, 255)
  SetTextDropshadow(0, 0, 0, 0, 255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextEntry("STRING")
  AddTextComponentString(message)
  DrawText(100, 100)
end