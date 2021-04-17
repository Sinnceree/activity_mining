local pickaxe = nil

function givePlayerPickaxe(ped)
  pickaxe = CreateObject(GetHashKey("prop_tool_pickaxe"), 0, 0, 0, true, true, true) 
  AttachEntityToEntity(pickaxe, ped, GetPedBoneIndex(ped, 28422), 0.0, -0.06, -0.04, -102.0, 177.0, -12.0, true, true, false, true, false, true)
end

function removePlayerPickaxe()
  DetachEntity(pickaxe, 1, true)
  DeleteEntity(pickaxe)
  DeleteObject(pickaxe)
end

function startMiningAnimation(zone, ped, rock, hitsNeeded, source)
  local hitsDone = 0
  local hitsRequired = hitsNeeded

  Citizen.CreateThread(function()

    while hitsDone < hitsRequired do
      Citizen.Wait(1)

      -- Lets request animation dict first
      RequestAnimDict("anim@heists@box_carry@")
      RequestAnimDict("melee@large_wpn@streamed_core")

      while not HasAnimDictLoaded("melee@large_wpn@streamed_core") and not HasAnimDictLoaded("anim@heists@box_carry@") do
        Citizen.Wait(1)
      end
      
      TaskPlayAnim(ped, "melee@large_wpn@streamed_core", "ground_attack_on_spot", 8.0, 8.0, -1, 80, 0, 0, 0, 0)

      -- Just started animation so give the player the pickaxd
      if hitsDone == 0 then
        givePlayerPickaxe(ped)
      end

      Citizen.Wait(2500)
      ClearPedTasks(ped)
      hitsDone = hitsDone + 1

      if hitsDone >= hitsNeeded then
        removePlayerPickaxe()
        Citizen.Wait(250)
        pickupRock() -- Called to hold rock in hand with animation until player puts the item in the truck/car?
        TriggerServerEvent("np-mining:completedMining", zone, rock, source)
        break
    end  
      
    end
    
  end)
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



function pickupRock()
  local holding = false
  Citizen.CreateThread(function()
    Citizen.Wait(1)
    local ped = PlayerPedId()	
    if not holding then
      TaskPlayAnim(ped,"anim@heists@box_carry@","idle",4.0, 1.0, -1,49,0, 0, 0, 0)
      rockObject = CreateObject(GetHashKey("prop_rock_4_cl_2"), 0, 0, 0, true, true, true) 
      AttachEntityToEntity(rockObject, ped, GetPedBoneIndex(ped, 28422), 0, -0.25, -0.04, -102.0, 177.0, -12.0, true, true, false, true, false, true)
    end

    Citizen.Wait(5000)
    ClearPedTasks(ped)
    DetachEntity(rockObject, 1, true)
    DeleteEntity(rockObject)
    DeleteObject(rockObject)
    SetModelAsNoLongerNeeded(rockObject)
    SetEntityAsMissionEntity(rockObject)
    print("Dropping rock")
    return
  end)

end

-- Used to generate a prop
function createProp(x, y, prop)
  local unused, objectZ = GetGroundZFor_3dCoord(x, y, 99999.0, 1)
  local obj = CreateObject(GetHashKey(prop), x, y, objectZ, true, true, false)
  FreezeEntityPosition(obj, true)
  return obj
end

-- Used to show text on top left of screen aka (mining status)
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

function sendNotification(message, playerServerId)
  if not Config.enableNopixelExports then
    print(message) -- Just log it if its not enabled
  else
    exports["np-activities"]:notifyPlayer(playerServerId, message) -- Use nopixel exported notification
  end
end