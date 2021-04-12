local miningZone = {
  zone = BoxZone:Create(vector3(435.18, 2016.35, 110.49), 20, 20, {
    name="mining_zone",
    heading=340,
    debugPoly=true,
    minZ=106.69,
    maxZ=114.29
  }),
  mineableBlocks = {
    {x = 438.3135, y = 2014.07, z = 108.9353}
  }
}



local miningStatus = ""
local mining = false
local insideMiningZone = false

Citizen.CreateThread(function()
    while true do
        local plyPed = GetPlayerPed(-1)
        local coord = GetEntityCoords(plyPed)
        insideMiningZone = miningZone.zone:isPointInside(coord)
        if insideMiningZone and mining then
          miningStatus = "You can start mining now"

          -- Check if the player is near any mineable blocks
          for k, block in pairs(miningZone.mineableBlocks) do
            local dis = GetDistanceBetweenCoords(coord["x"], coord["y"], coord["z"], block["x"], block["y"], block["z"], false)
            if dis < 2 then
              miningStatus = "Mine meee"
            end
          end
          
        else
          miningStatus = "Please enter a mining zone"
        end
        Citizen.Wait(500)
    end
end)


Citizen.CreateThread(function()
  while true do
      if mining then
        for k, block in pairs(miningZone.mineableBlocks) do
          DrawText3Ds(block["x"], block["y"], block["z"], "cunt")
        end
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

function DrawText3Ds(x,y,z, text)
  local onScreen,_x,_y=World3dToScreen2d(x,y,z)
  local px,py,pz=table.unpack(GetGameplayCamCoords())
  
  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(1)
  AddTextComponentString(text)
  DrawText(_x,_y)
  local factor = (string.len(text)) / 370
  DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end