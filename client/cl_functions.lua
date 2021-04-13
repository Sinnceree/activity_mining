
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

function startMiningAnimation(rock)
  local hits = 0;
  Citizen.CreateThread(function()

      while hits < 3 do
        Citizen.Wait(1)
        local ped = PlayerPedId()	
        RequestAnimDict("melee@large_wpn@streamed_core")
        Citizen.Wait(100)
        TaskPlayAnim((ped), "melee@large_wpn@streamed_core", "ground_attack_on_spot", 8.0, 8.0, -1, 80, 0, 0, 0, 0)
        SetEntityHeading(ped, 270.0)
        if hits == 0 then
            pickaxe = CreateObject(GetHashKey("prop_tool_pickaxe"), 0, 0, 0, true, true, true) 
            AttachEntityToEntity(pickaxe, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.18, -0.02, -0.02, 350.0, 100.00, 140.0, true, true, false, true, 1, true)
        end  
        Citizen.Wait(2500)
        ClearPedTasks(ped)
        hits = hits + 1
        if hits == 3 then
            DetachEntity(pickaxe, 1, true)
            DeleteEntity(pickaxe)
            DeleteObject(pickaxe)
            print("finished mining delete axe")
            TriggerEvent("np-mining:collectedRock", rock)
            break
        end        
      end
  end)
end